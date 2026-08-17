package com.zenshield.vpn.utils

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel

class SafeResult(private val result: MethodChannel.Result) : MethodChannel.Result {
    @Volatile
    private var isUsed = false
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun success(response: Any?) {
        if (markUsed()) {
            mainHandler.post {
                result.success(response)
            }
        }
    }

    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
        if (markUsed()) {
            mainHandler.post {
                result.error(errorCode, errorMessage, errorDetails)
            }
        }
    }

    override fun notImplemented() {
        if (markUsed()) {
            mainHandler.post {
                result.notImplemented()
            }
        }
    }

    @Synchronized
    private fun markUsed(): Boolean {
        return if (!isUsed) {
            isUsed = true
            true
        } else {
            false
        }
    }
} 