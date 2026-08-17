package com.zenshield.vpn.bg

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.BitmapFactory
import android.os.Build
import android.util.Log
import androidx.annotation.StringRes
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.zenshield.vpn.Application
import com.zenshield.vpn.MainActivity
import com.zenshield.vpn.R
import com.zenshield.vpn.Settings
import com.zenshield.vpn.constant.Action
import com.zenshield.vpn.utils.CommandClient
import com.vpnapp.zenshield.libbox.Libbox
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.withContext
import java.util.concurrent.TimeUnit

class ServiceNotification(
    private val service: Service
) : BroadcastReceiver(), CommandClient.Handler {
    companion object {
        private const val NOTIFICATION_ID = 1
        private const val NOTIFICATION_CHANNEL = "service"
        private const val WORK_MANAGER_TAG = "NOTIFICATION_WORK_MANAGER"
        val flags =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0

        fun checkPermission(): Boolean {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
                return true
            }
            return Application.notification.areNotificationsEnabled()
        }
    }

    @OptIn(DelicateCoroutinesApi::class)
    private val commandClient =
        CommandClient(GlobalScope, CommandClient.ConnectionType.Status, this)
    private var receiverRegistered = false

    private val notificationBuilder by lazy {
        NotificationCompat.Builder(service, NOTIFICATION_CHANNEL).setShowWhen(false)
            .setOngoing(true)
            .setContentTitle("Zensheild VPN").setOnlyAlertOnce(true)
            .setSmallIcon(R.drawable.ic_menu)
            // The small icon is forced to a plain white silhouette by Android
            // (API 21+), so it can't show the app's logo/branding on its own —
            // the large icon is what renders as the actual app icon on the
            // left of the notification.
            .setLargeIcon(BitmapFactory.decodeResource(service.resources, R.mipmap.ic_launcher))
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setContentIntent(
                PendingIntent.getActivity(
                    service,
                    0,
                    Intent(
                        service,
                        MainActivity::class.java
                    ).setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT),
                    flags
                )
            )
            .setPriority(NotificationCompat.PRIORITY_LOW).apply {
                addAction(
                    NotificationCompat.Action.Builder(
                        0, service.getText(R.string.stop), PendingIntent.getBroadcast(
                            service,
                            0,
                            Intent(Action.SERVICE_CLOSE).setPackage(service.packageName),
                            flags
                        )
                    ).build()
                )
            }
    }

    fun show(lastProfileName: String, @StringRes contentTextId: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Application.notification.createNotificationChannel(
                NotificationChannel(
                    NOTIFICATION_CHANNEL,
                    "Service Notifications",
                    NotificationManager.IMPORTANCE_LOW
                )
            )
        }
        service.startForeground(
            NOTIFICATION_ID, notificationBuilder
                .setContentTitle(lastProfileName.takeIf { it.isNotBlank() } ?: "Zensheild VPN")
                .setContentText(service.getString(contentTextId)).build()
        )

        val isPaid = Settings.isPaid
        if (isPaid == false) {
            setupTurnOffTimer()
        }
    }

    suspend fun start() {
        commandClient.connect()
        withContext(Dispatchers.Main) {
            registerReceiver()
        }
    }

    private fun registerReceiver() {
        service.registerReceiver(this, IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_ON)
            addAction(Intent.ACTION_SCREEN_OFF)
        })
        receiverRegistered = true
    }

    override fun updateStatus(status: String) {
        val map: Map<String, Any> =
            Gson().fromJson(status, object : TypeToken<Map<String, Any>>() {}.type)
        val uplink = map["uplink"] as Double
        val downlink = map["downlink"] as Double
        val content =
            Libbox.formatBytes(uplink.toLong()) + "/s ↑\t" + Libbox.formatBytes(downlink.toLong()) + "/s ↓"
        Application.notificationManager.notify(
            NOTIFICATION_ID,
            notificationBuilder.setContentText(content).build()
        )
    }

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            Intent.ACTION_SCREEN_ON -> {
                commandClient.connect()
            }

            Intent.ACTION_SCREEN_OFF -> {
                commandClient.disconnect()
            }
        }
    }

    fun close() {
        commandClient.disconnect()
        ServiceCompat.stopForeground(service, ServiceCompat.STOP_FOREGROUND_REMOVE)
        if (receiverRegistered) {
            service.unregisterReceiver(this)
            receiverRegistered = false
        }
    }

    private fun setupTurnOffTimer() {
        val delayHours = Settings.vpnTimeoutSec.toLong()
        val workRequest = OneTimeWorkRequestBuilder<TurnOffWorker>()
            .setInitialDelay(delayHours, TimeUnit.SECONDS)
            .addTag(WORK_MANAGER_TAG)
            .build()
        WorkManager.getInstance(service).enqueueUniqueWork(
            WORK_MANAGER_TAG,
            ExistingWorkPolicy.REPLACE,
            workRequest
        )
    }
}

class TurnOffWorker(
    context: Context,
    params: WorkerParameters
) : Worker(context, params) {

    companion object {
        private const val TAG = "TurnOffWorker"
    }

    override fun doWork(): Result {
        return try {
            Log.d(TAG, "TurnOffWorker: Sending ACTION_SERVICE_CLOSE")
            BoxService.stop()
            Result.success()
        } catch (e: Exception) {
            Log.e(TAG, "TurnOffWorker: Error while sending ACTION_SERVICE_CLOSE: ${e.message}")
            Result.failure()
        }
    }
}