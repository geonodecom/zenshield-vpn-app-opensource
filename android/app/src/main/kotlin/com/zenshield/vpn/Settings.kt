package com.zenshield.vpn

import android.content.Context
import androidx.core.content.edit
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.zenshield.vpn.bg.VPNService
import com.zenshield.vpn.constant.PerAppProxyMode
import com.zenshield.vpn.constant.SettingsKey

object Settings {
    const val PER_APP_PROXY_DISABLED = 0
    const val PER_APP_PROXY_EXCLUDE = 1
    const val PER_APP_PROXY_INCLUDE = 2

    private val preferences by lazy {
        val context = Application.application.applicationContext
        context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
    }

    private const val LIST_IDENTIFIER = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu"

    var basePath: String?
        get() = preferences.getString(SettingsKey.BASE_PATH, "")
        set(value) = preferences.edit { putString(SettingsKey.BASE_PATH, value) }

    var workingPath: String?
        get() = preferences.getString(SettingsKey.WORK_PATH, "")
        set(value) = preferences.edit { putString(SettingsKey.WORK_PATH, value) }

    var tempPath: String?
        get() = preferences.getString(SettingsKey.TEMP_PATH, "")
        set(value) = preferences.edit { putString(SettingsKey.TEMP_PATH, value) }

    private var _perAppProxyMode: String
        get() = preferences.getString(SettingsKey.PER_APP_PROXY_MODE, PerAppProxyMode.OFF)!!
        set(value) = preferences.edit { putString(SettingsKey.PER_APP_PROXY_MODE, value) }

    val perAppProxyEnabled: Boolean
        get() = _perAppProxyMode != PerAppProxyMode.OFF

    val perAppProxyMode: Int
        get() =
                when (_perAppProxyMode) {
                    PerAppProxyMode.INCLUDE -> PER_APP_PROXY_INCLUDE
                    PerAppProxyMode.EXCLUDE -> PER_APP_PROXY_EXCLUDE
                    else -> PER_APP_PROXY_DISABLED
                }

    val perAppProxyList: List<String>
        get() {
            val key =
                    when (_perAppProxyMode) {
                        PerAppProxyMode.INCLUDE -> SettingsKey.PER_APP_PROXY_INCLUDE_LIST
                        PerAppProxyMode.EXCLUDE -> SettingsKey.PER_APP_PROXY_EXCLUDE_LIST
                        else -> SettingsKey.PER_APP_PROXY_EXCLUDE_LIST
                    }
            android.util.Log.i("Settings", "perAppProxyList: mode=$_perAppProxyMode, key=$key")
            val stringValue = preferences.getString(key, "")!!
            android.util.Log.i(
                    "Settings",
                    "perAppProxyList: raw stringValue length=${stringValue.length}, startsWith=${stringValue.startsWith(LIST_IDENTIFIER)}"
            )

            if (!stringValue.startsWith(LIST_IDENTIFIER)) {
                android.util.Log.i(
                        "Settings",
                        "perAppProxyList: stringValue doesn't start with LIST_IDENTIFIER, returning empty list"
                )
                return emptyList()
            }
            val decoded = decodeListString(stringValue.substring(LIST_IDENTIFIER.length))
            android.util.Log.i(
                    "Settings",
                    "perAppProxyList: decoded list size=${decoded.size}, list=$decoded"
            )
            return decoded
        }

    private fun decodeListString(listString: String): List<String> {
        return try {
            val jsonString = listString.trimStart('!')
            Gson().fromJson(jsonString, object : TypeToken<List<String>>() {}.type)
        } catch (e: Exception) {
            emptyList()
        }
    }

    var npvpnConfig: String
        get() = preferences.getString(SettingsKey.CONFIG_PATH, "")!!
        set(value) = preferences.edit { putString(SettingsKey.CONFIG_PATH, value) }

    var isPaid: Boolean
        get() = preferences.getBoolean(SettingsKey.IS_PAID, false)
        set(value) = preferences.edit { putBoolean(SettingsKey.IS_PAID, value) }

    var vpnTimeoutSec: Int
        get() = preferences.getInt(SettingsKey.VPN_TIMEOUT, 30)
        set(value) = preferences.edit { putInt(SettingsKey.VPN_TIMEOUT, value) }

    var disableMemoryLimit: Boolean
        get() = preferences.getBoolean(SettingsKey.DISABLE_MEMORY_LIMIT, false)
        set(value) = preferences.edit { putBoolean(SettingsKey.DISABLE_MEMORY_LIMIT, value) }

    val isSmartModeEnabled: Boolean
        get() = preferences.getBoolean(SettingsKey.IS_SMART_MODE_ENABLED, true)

    var vpnRestoreOnBoot: Boolean
        get() = preferences.getBoolean(SettingsKey.VPN_RESTORE_ON_BOOT, false)
        set(value) = preferences.edit { putBoolean(SettingsKey.VPN_RESTORE_ON_BOOT, value) }

    fun serviceClass(): Class<*> {
        return VPNService::class.java
    }
}
