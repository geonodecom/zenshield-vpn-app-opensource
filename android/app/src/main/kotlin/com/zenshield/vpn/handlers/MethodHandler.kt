package com.zenshield.vpn.handlers

import PingCallbackDelegate
import android.net.VpnService
import android.util.Log
import com.zenshield.vpn.Application
import com.zenshield.vpn.MainActivity
import com.zenshield.vpn.Settings
import com.zenshield.vpn.bg.BoxService
import com.vpnapp.zenshield.libbox.Libbox
import com.zenshield.vpn.utils.SafeResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class MethodHandler(private val scope: CoroutineScope) :
        FlutterPlugin, MethodChannel.MethodCallHandler {
    private var channel: MethodChannel? = null
    private var isStopInProgress = false

    companion object {
        private const val TAG = "MethodHandler"
        private const val START_TIMEOUT_MS = 20_000L
        const val CHANNEL_NAME = "com.zenshield.vpn/method"

        enum class Trigger(val method: String) {
            Init("init"),
            Start("start"),
            Stop("stop"),
            GetPing("get_ping"),
            ChangeServer("change_server"),
            TestLink("test_link"),
            GetLinksOutbounds("get_links_outbounds"),
            CheckVpnPermission("check_vpn_permission"),
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel =
                MethodChannel(
                        flutterPluginBinding.binaryMessenger,
                        CHANNEL_NAME,
                )
        channel!!.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val safeResult = SafeResult(result)
        when (call.method) {
            Trigger.Init.method -> handleInit(safeResult)
            Trigger.Start.method -> handleStart(call, safeResult)
            Trigger.Stop.method -> handleStop(safeResult)
            Trigger.GetPing.method -> handleGetPing(call, safeResult)
            Trigger.ChangeServer.method -> handleChangeServer(call, safeResult)
            Trigger.TestLink.method -> handleTestLink(call, safeResult)
            Trigger.GetLinksOutbounds.method -> handleGetLinksOutbounds(call, safeResult)
            Trigger.CheckVpnPermission.method -> handleCheckVpnPermission(safeResult)
            else -> safeResult.notImplemented()
        }
    }

    private fun handleInit(result: SafeResult) {
        scope.launch {
            try {
                val basePath =
                        initDirectory(Settings.basePath, Application.Companion.application.filesDir)
                val workingPath =
                        initDirectory(
                                Settings.workingPath,
                                Application.Companion.application.getExternalFilesDir(null)
                        )
                val tempPath =
                        initDirectory(Settings.tempPath, Application.Companion.application.cacheDir)

                result.success(
                        mapOf(
                                "basePath" to basePath,
                                "workingPath" to workingPath,
                                "tempPath" to tempPath
                        )
                )
            } catch (e: Exception) {
                result.error("INIT_ERROR", "Failed to initialize directories: ${e.message}", null)
            }
        }
    }

    private fun handleStart(call: MethodCall, result: SafeResult) {
        val startedAt = System.currentTimeMillis()
        Log.i(TAG, "handleStart: received from Dart, isStopInProgress=$isStopInProgress")
        scope.launch {
            try {
                isStopInProgress = false
                val args = call.arguments as? Map<*, *> ?: mapOf<String, Any>()
                Settings.npvpnConfig = args["config"] as? String ?: ""
                Settings.isPaid = args["isPaid"] as? Boolean == true
                Settings.vpnTimeoutSec = args["timeoutSec"] as? Int ?: 30

                if (!MainActivity.Companion.isInstanceInitialized()) {
                    Log.e(TAG, "handleStart: MainActivity not initialized — app not in foreground")
                    result.error("START_ERROR", "MainActivity instance is not initialized. Please ensure the app is in the foreground.", null)
                    return@launch
                }
                val mainActivity = MainActivity.Companion.instance

                val serviceCallback =
                        object : MainActivity.ServiceStartCallback {
                            override fun onServiceStarted(success: Boolean) {
                                val elapsedMs = System.currentTimeMillis() - startedAt
                                if (success) {
                                    Log.i(TAG, "handleStart: service started successfully (${elapsedMs}ms)")
                                    result.success(true)
                                } else {
                                    Log.e(TAG, "handleStart: service reported failure to start (${elapsedMs}ms)")
                                    result.error("START_ERROR", "Failed to start service", null)
                                }
                            }

                            override fun onPermissionDenied() {
                                val elapsedMs = System.currentTimeMillis() - startedAt
                                Log.w(TAG, "handleStart: VPN permission denied by user (${elapsedMs}ms)")
                                result.error("PERMISSION_DENIED", "VPN permission was denied", null)
                            }
                        }

                mainActivity.startService(serviceCallback)

                // startService() defers to a system consent dialog when VPN
                // permission needs re-confirming; if that dialog never
                // resolves (observed to silently vanish on some OEM builds),
                // neither ServiceStartCallback method fires and Dart's
                // enableVpn() future hangs forever with no user feedback.
                // SafeResult ignores this once the real callback lands.
                delay(START_TIMEOUT_MS)
                Log.w(TAG, "handleStart: timed out waiting for service start confirmation")
                result.error("START_TIMEOUT", "Timed out waiting for VPN service to start", null)
            } catch (e: Exception) {
                Log.e(TAG, "handleStart: exception while starting service: ${e.message}", e)
                result.error("START_ERROR", "Failed to start service: ${e.message}", null)
            }
        }
    }

    private fun handleStop(result: SafeResult) {
        val startedAt = System.currentTimeMillis()
        Log.i(TAG, "handleStop: received from Dart, isStopInProgress=$isStopInProgress")
        scope.launch {
            try {
                if (isStopInProgress) {
                    Log.w(TAG, "handleStop: stop already in progress — ignoring duplicate request")
                    return@launch
                }
                isStopInProgress = true
                BoxService.stop()
                val elapsedMs = System.currentTimeMillis() - startedAt
                Log.i(TAG, "handleStop: service stopped successfully (${elapsedMs}ms)")
                result.success(true)
            } catch (e: Exception) {
                Log.e(TAG, "handleStop: exception while stopping service: ${e.message}", e)
                result.error("STOP_ERROR", "Failed to stop service: ${e.message}", null)
                isStopInProgress = false
            }
        }
    }

    private fun handleGetPing(call: MethodCall, result: SafeResult) {
        scope.launch {
            try {
                val linksString = call.arguments as? String ?: ""
                val delegate = PingCallbackDelegate { result.success(it) }

                val wrapper = Libbox.newPingResultExportWrapper(delegate)
                wrapper.checkIcmpPingForLinks(linksString)
            } catch (e: Exception) {
                result.error("PING_ERROR", "Failed to get ping: ${e.message}", null)
            }
        }
    }

    private fun handleChangeServer(call: MethodCall, result: SafeResult) {
        scope.launch {
            try {
                val args = call.arguments as? Map<*, *> ?: mapOf<String, Any>()
                val link = args["link"] as? String ?: ""
                val bearer = args["bearer"] as? String ?: ""
                val port = args["port"] as? Int ?: 0
                Libbox.putSelector(link, bearer, port.toLong())
                result.success(null)
            } catch (e: Exception) {
                result.error("CHANGE_SERVER_ERROR", "Failed to change server: ${e.message}", null)
            }
        }
    }

    private fun handleTestLink(call: MethodCall, result: SafeResult) {
        scope.launch {
            try {
                val link = call.arguments as? String ?: ""
                val isCorrect = Libbox.testLink(link)
                if (isCorrect) {
                    result.success(null)
                } else {
                    result.error("NOT_CORRECT_LINK", "Link is not correct", null)
                }
            } catch (e: Exception) {
                result.error("TEST_LINK_ERROR", "Failed to test link: ${e.message}", null)
            }
        }
    }

    private fun handleGetLinksOutbounds(call: MethodCall, result: SafeResult) {
        scope.launch {
            try {
                val links = call.arguments as? String ?: ""
                val outboundsJsonString = Libbox.getLinksJson(links)
                result.success(outboundsJsonString)
            } catch (e: Exception) {
                result.error("GET_LINKS_ERROR", "Failed to get links outbounds: ${e.message}", null)
            }
        }
    }

    private fun handleCheckVpnPermission(result: SafeResult) {
        scope.launch {
            try {
                val isGranted = VpnService.prepare(Application.Companion.application) == null
                result.success(isGranted)
            } catch (e: Exception) {
                result.error("PERMISSION_CHECK_ERROR", "Failed to check VPN permission: ${e.message}", null)
            }
        }
    }

    private fun initDirectory(currentPath: String?, directory: File?): String {
        if (currentPath.isNullOrEmpty() && directory != null) {
            directory.mkdir()
            val newPath = directory.path
            when (directory) {
                Application.Companion.application.filesDir -> Settings.basePath = newPath
                Application.Companion.application.getExternalFilesDir(null) ->
                        Settings.workingPath = newPath
                Application.Companion.application.cacheDir -> Settings.tempPath = newPath
            }
            return newPath
        }
        return currentPath ?: ""
    }
}
