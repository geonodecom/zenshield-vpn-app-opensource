package com.zenshield.vpn

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.zenshield.vpn.bg.BoxService

/**
 * Restores VPN and attempts to open the app after reboot when the tunnel was active.
 *
 * Starting an Activity directly from [onReceive] is blocked on Android 10+, so we:
 * 1. Restart the VPN foreground service (allowed on boot)
 * 2. Post a high-priority notification (tap to open)
 * 3. Schedule a delayed launch via AlarmManager + WorkManager
 */
class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return

        // Credential-encrypted Flutter prefs are unavailable until the user unlocks.
        if (action == Intent.ACTION_LOCKED_BOOT_COMPLETED) {
            return
        }

        if (action != Intent.ACTION_BOOT_COMPLETED &&
            action != ACTION_QUICKBOOT_POWERON &&
            action != ACTION_HTC_QUICKBOOT_POWERON
        ) {
            return
        }

        val pendingResult = goAsync()
        Thread {
            try {
                handleBoot(context.applicationContext)
            } catch (e: Exception) {
                Log.e(TAG, "Boot restore failed", e)
            } finally {
                pendingResult.finish()
            }
        }.start()
    }

    private fun handleBoot(context: Context) {
        if (!BootRestorePreferences.shouldRestoreOnBoot(context)) {
            Log.i(TAG, "Boot completed; VPN restore not requested, skipping")
            return
        }

        if (Settings.npvpnConfig.isBlank()) {
            Log.w(TAG, "Boot completed; restore requested but config is empty, skipping")
            return
        }

        Log.i(TAG, "Boot completed; restoring VPN and scheduling app launch")

        try {
            BoxService.start()
            Log.i(TAG, "VPN foreground service start requested")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start VPN service on boot", e)
        }

        BootRestoreNotifier.show(context)
        BootRestoreScheduler.schedule(context)

        try {
            val launchIntent =
                Intent(context, MainActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    putExtra(MainActivity.EXTRA_BOOT_RESTORE, true)
                }
            context.startActivity(launchIntent)
            Log.i(TAG, "Immediate MainActivity launch attempted")
        } catch (e: Exception) {
            Log.w(TAG, "Immediate MainActivity launch blocked (expected on Android 10+)", e)
        }
    }

    companion object {
        private const val TAG = "BootReceiver"
        private const val ACTION_QUICKBOOT_POWERON = "android.intent.action.QUICKBOOT_POWERON"
        private const val ACTION_HTC_QUICKBOOT_POWERON =
            "com.htc.intent.action.QUICKBOOT_POWERON"
    }
}
