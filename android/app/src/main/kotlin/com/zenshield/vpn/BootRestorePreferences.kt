package com.zenshield.vpn

import android.content.Context
import android.os.Build

/**
 * Device-protected prefs so [BootReceiver] can read restore state after reboot,
 * including before credential-encrypted Flutter storage is unlocked.
 */
object BootRestorePreferences {
    private const val PREFS_NAME = "boot_restore"
    private const val KEY_RESTORE = "restore_on_boot"

    fun setRestoreOnBoot(context: Context, value: Boolean) {
        prefs(context).edit().putBoolean(KEY_RESTORE, value).commit()
    }

    fun shouldRestoreOnBoot(context: Context): Boolean {
        if (prefs(context).getBoolean(KEY_RESTORE, false)) {
            return true
        }
        return Settings.vpnRestoreOnBoot
    }

    private fun prefs(context: Context) =
        storageContext(context).getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    private fun storageContext(context: Context): Context {
        val app = context.applicationContext
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            app.createDeviceProtectedStorageContext()
        } else {
            app
        }
    }
}
