package com.zenshield.vpn.handlers

import android.content.Context
import com.fingerprintjs.android.fingerprint.Fingerprinter
import com.fingerprintjs.android.fingerprint.FingerprinterFactory
import com.zenshield.vpn.utils.SafeResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class UserIdMethodHandler : FlutterPlugin, MethodChannel.MethodCallHandler {
    private var channel: MethodChannel? = null
    private var context: Context? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            CHANNEL_NAME,
        )

        context = flutterPluginBinding.applicationContext
        channel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val safeResult = SafeResult(result)
        when (call.method) {
            Trigger.CheckPreviousId.method -> {
                val localContext = context
                if (localContext == null) {
                    safeResult.error("CONTEXT_ERROR", "Context is null", null)
                    return
                }
                val printer = FingerprinterFactory.create(localContext)
                printer.getDeviceId(version = Fingerprinter.Version.V_6) { deviceResult ->
                    val deviceId = deviceResult.deviceId
                    safeResult.success(deviceId)
                }
            }

            else -> safeResult.notImplemented()
        }
    }

    companion object {
        const val CHANNEL_NAME = "trustlane/id"

        enum class Trigger(val method: String) {
            CheckPreviousId("checkPreviousId")
        }
    }
}