package com.zenshield.vpn.bg

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.ParcelFileDescriptor
import android.os.PowerManager
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.zenshield.vpn.Application
import com.zenshield.vpn.BootRestorePreferences
import com.zenshield.vpn.R
import com.zenshield.vpn.Settings
import com.zenshield.vpn.constant.Action
import com.zenshield.vpn.constant.Bugs
import com.zenshield.vpn.ktx.hasPermission
import com.vpnapp.zenshield.libbox.BoxService
import com.vpnapp.zenshield.libbox.CommandServer
import com.vpnapp.zenshield.libbox.CommandServerHandler
import com.vpnapp.zenshield.libbox.Libbox
import com.vpnapp.zenshield.libbox.Notification
import com.vpnapp.zenshield.libbox.PlatformInterface
import com.vpnapp.zenshield.libbox.SetupOptions
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import go.Seq
import java.io.File
import java.io.FileOutputStream
import java.nio.ByteBuffer
import java.nio.ByteOrder
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext

class BoxService(
    private val service: Service, private val platformInterface: PlatformInterface
) : CommandServerHandler {

    companion object {

        private var initializeOnce = false
        private fun initialize() {
            if (initializeOnce) return
            val workingPath = Settings.workingPath
            Libbox.setup(
                    SetupOptions().also {
                        it.basePath = Settings.basePath
                        it.workingPath = workingPath
                        it.tempPath = Settings.tempPath
                        it.fixAndroidStack = Bugs.fixAndroidStack
                    }
            )
            Libbox.redirectStderr("$workingPath/stderr.log")
            initializeOnce = true
            return
        }

        fun start() {
            val intent = runBlocking {
                withContext(Dispatchers.IO) {
                    Intent(Application.application, Settings.serviceClass())
                }
            }
            ContextCompat.startForegroundService(Application.application, intent)
        }

        fun stop() {
            Application.application.sendBroadcast(
                Intent(Action.SERVICE_CLOSE).setPackage(
                    Application.application.packageName
                )
            )
        }
    }

    var fileDescriptor: ParcelFileDescriptor? = null
    private val notification = ServiceNotification(service)
    private var boxService: BoxService? = null
    private var commandServer: CommandServer? = null
    private var receiverRegistered = false
    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                Action.SERVICE_CLOSE -> {
                    stopService()
                }


                PowerManager.ACTION_DEVICE_IDLE_MODE_CHANGED -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        serviceUpdateIdleMode()
                    }
                }
            }
        }
    }

    private fun startCommandServer() {
        val commandServer = CommandServer(this, 300)
        commandServer.start()
        this.commandServer = commandServer
    }

    private var lastProfileName = ""

    private suspend fun startService() {
        try {
            withContext(Dispatchers.Main) {
                notification.show(lastProfileName, R.string.status_starting)
            }

            val npvpnConfig = Settings.npvpnConfig
            var content = Libbox.getFullConfig(npvpnConfig)

            // Merge SOCKS inbound from npvpnConfig if socksInbound.enabled (same as NPVPN-Singbox-Utils inbounds.go)
            content = mergeSocksInboundIfEnabled(npvpnConfig, content)

            // Debug: log full config (preview in Logcat, full body to file)
            val tag = "BoxService"
            Log.d(tag, "Full config length: ${content.length}")
            Log.d(tag, "Full config (preview): ${content.take(2500)}")
            Settings.workingPath?.let { path ->
                kotlin.runCatching {
                    File(path, "full_config_debug.json").writeText(content)
                    Log.d(tag, "Full config written to: $path/full_config_debug.json")
                }.onFailure { e -> Log.w(tag, "Failed to write full config to file", e) }
            }

            DefaultNetworkMonitor.start()
            Libbox.setMemoryLimit(!Settings.disableMemoryLimit)

            val newService =
                    try {
                        Libbox.newService(content, platformInterface)
                    } catch (e: Exception) {
                        Log.e(tag, "VPN-DIAG Libbox.newService failed", e)
                        stop()
                        return
                    }

            newService.start()

            if (newService.needWIFIState()) {
                val wifiPermission = if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
                    android.Manifest.permission.ACCESS_FINE_LOCATION
                } else {
                    android.Manifest.permission.ACCESS_BACKGROUND_LOCATION
                }
                if (!service.hasPermission(wifiPermission)) {
                    newService.close()
                    stop()
                    return
                }
            }

            boxService = newService
            commandServer?.setService(boxService)
            withContext(Dispatchers.Main) {
                notification.show(lastProfileName, R.string.status_started)
            }
            BootRestorePreferences.setRestoreOnBoot(Application.application, true)
            Settings.vpnRestoreOnBoot = true
            notification.start()
        } catch (e: Exception) {
            Log.e("VPN-DIAG", "BoxService.startService failed", e)
            stop()
            return
        }
    }

    /**
     * If npvpnConfig has socksInbound.enabled, appends a SOCKS inbound to the full config's inbounds
     * (same logic as NPVPN-Singbox-Utils utils/converter/inbounds.go).
     */
    private fun mergeSocksInboundIfEnabled(npvpnConfig: String, fullConfig: String): String {
        return runCatching {
            val input = JsonParser.parseString(npvpnConfig).asJsonObject
            val socksInbound = input.get("socksInbound")?.asJsonObject ?: return fullConfig
            if (socksInbound.get("enabled")?.asBoolean != true) return fullConfig

            val listen = socksInbound.get("listen")?.asString?.takeIf { it.isNotBlank() } ?: "127.0.0.1"
            val port = socksInbound.get("port")?.asInt?.takeIf { it > 0 } ?: 10801
            val tag = socksInbound.get("tag")?.asString?.takeIf { it.isNotBlank() } ?: "local-socks"

            val root = JsonParser.parseString(fullConfig).asJsonObject
            val inbounds = root.getAsJsonArray("inbounds") ?: JsonArray().also { root.add("inbounds", it) }

            val socksInboundEntry = JsonObject().apply {
                addProperty("type", "socks")
                addProperty("tag", tag)
                addProperty("listen", listen)
                addProperty("listen_port", port)
            }
            inbounds.add(socksInboundEntry)

            // When socksInbound.direct is true, route traffic from this inbound to direct (NPVPN-Singbox-Utils route.go)
            if (socksInbound.get("direct")?.asBoolean == true) {
                val route = root.get("route")?.asJsonObject
                val rules = route?.getAsJsonArray("rules")
                if (route != null && rules != null) {
                    val directRule = JsonObject().apply {
                        add("inbound", JsonArray().apply { add(tag) })
                        addProperty("outbound", "direct")
                    }
                    val newRules = JsonArray().apply {
                        add(directRule)
                        for (i in 0 until rules.size()) add(rules.get(i))
                    }
                    route.remove("rules")
                    route.add("rules", newRules)
                }
            }

            root.toString()
        }.getOrElse { e ->
            Log.w("BoxService", "Failed to merge SOCKS inbound, using original config", e)
            fullConfig
        }
    }

    override fun serviceReload() {
        notification.close()
        val pfd = fileDescriptor
        if (pfd != null) {
            pfd.close()
            fileDescriptor = null
        }
        boxService?.apply {
            runCatching {
                close()
            }.onFailure {
                writeLog("service: error when closing: $it")
            }
            Seq.destroyRef(refnum)
        }
        commandServer?.setService(null)
        commandServer?.resetLog()
        boxService = null
        runBlocking {
            startService()
        }
    }

    override fun postServiceClose() {
        // Not used on Android
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun serviceUpdateIdleMode() {
        if (Application.powerManager.isDeviceIdleMode) {
            boxService?.pause()
        } else {
            boxService?.wake()
        }
    }

    @OptIn(DelicateCoroutinesApi::class)
    private fun stopService() {
        BootRestorePreferences.setRestoreOnBoot(Application.application, false)
        Settings.vpnRestoreOnBoot = false
        if (receiverRegistered) {
            service.unregisterReceiver(receiver)
            receiverRegistered = false
        }
        notification.close()
        GlobalScope.launch(Dispatchers.IO) {
            val pfd = fileDescriptor
            if (pfd != null) {
                pfd.close()
                fileDescriptor = null
            }
            boxService?.apply {
                runCatching {
                    close()
                }.onFailure {
                    writeLog("service: error when closing: $it")
                }
                Seq.destroyRef(refnum)
            }
            commandServer?.setService(null)
            boxService = null
            DefaultNetworkMonitor.stop()

            commandServer?.apply {
                runCatching {
                    close()
                }.onFailure {
                    writeLog("commandServer: error when closing: $it")
                }
                Seq.destroyRef(refnum)
            }
            commandServer = null
            withContext(Dispatchers.Main) {
                service.stopSelf()
            }
        }
    }

    private suspend fun stop() {
        withContext(Dispatchers.Main) {
            if (receiverRegistered) {
                service.unregisterReceiver(receiver)
                receiverRegistered = false
            }
            notification.close()
        }
    }

    @OptIn(DelicateCoroutinesApi::class)
    @Suppress("SameReturnValue")
    internal fun onStartCommand(): Int {
        if (!receiverRegistered) {
            ContextCompat.registerReceiver(service, receiver, IntentFilter().apply {
                addAction(Action.SERVICE_CLOSE)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    addAction(PowerManager.ACTION_DEVICE_IDLE_MODE_CHANGED)
                }
            }, ContextCompat.RECEIVER_NOT_EXPORTED)
            receiverRegistered = true
        }

        GlobalScope.launch(Dispatchers.IO) {
            initialize()
            try {
                startCommandServer()
            } catch (_: Exception) {
                stop()
                return@launch
            }

            startService()
        }
        return Service.START_NOT_STICKY
    }

    internal fun onRevoke() {
        stopService()
    }

    internal fun writeLog(message: String) {
        commandServer?.writeMessage(message)
    }

    internal fun sendNotification(notification: Notification) {
        val builder =
            NotificationCompat.Builder(service, notification.identifier).setShowWhen(false)
                .setContentTitle(notification.title)
                .setContentText(notification.body)
                .setOnlyAlertOnce(true)

                .setCategory(NotificationCompat.CATEGORY_EVENT)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setAutoCancel(true)
        if (!notification.subtitle.isNullOrBlank()) {
            builder.setContentInfo(notification.subtitle)
        }
        GlobalScope.launch(Dispatchers.Main) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Application.notification.createNotificationChannel(
                    NotificationChannel(
                        notification.identifier,
                        notification.typeName,
                        NotificationManager.IMPORTANCE_HIGH
                    )
                )
            }
            Application.notification.notify(notification.typeID, builder.build())
        }
    }
}