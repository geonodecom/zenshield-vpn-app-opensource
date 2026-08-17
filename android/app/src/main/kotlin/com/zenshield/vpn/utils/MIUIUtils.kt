package com.zenshield.vpn.utils

import android.annotation.SuppressLint

object MIUIUtils {

    val isMIUI by lazy {
        val miuiVersion = getSystemProperty("ro.miui.ui.version.name")
        val hyperOSVersion = getSystemProperty("ro.mi.os.version.name")
        val manufacturer = android.os.Build.MANUFACTURER

        when {
            !miuiVersion.isNullOrBlank() -> true
            !hyperOSVersion.isNullOrBlank() -> true
            manufacturer.equals("Xiaomi", ignoreCase = true) -> true
            else -> false
        }
    }

    @SuppressLint("PrivateApi")
    private fun getSystemProperty(key: String?): String? {
        return try {
            Class.forName("android.os.SystemProperties")
                .getMethod("get", String::class.java)
                .invoke(null, key) as String
        } catch (_: Exception) {
            null
        }
    }
}
