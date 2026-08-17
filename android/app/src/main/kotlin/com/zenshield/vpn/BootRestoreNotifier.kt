package com.zenshield.vpn

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat

object BootRestoreNotifier {
    private const val CHANNEL_ID = "boot_restore"
    private const val NOTIFICATION_ID = 1002

    fun show(context: Context) {
        val appContext = context.applicationContext
        val manager =
            appContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel =
                NotificationChannel(
                    CHANNEL_ID,
                    appContext.getString(R.string.boot_restore_channel_name),
                    NotificationManager.IMPORTANCE_HIGH,
                )
            manager.createNotificationChannel(channel)
        }

        val launchIntent =
            Intent(appContext, MainActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                putExtra(MainActivity.EXTRA_BOOT_RESTORE, true)
            }

        val pendingFlags =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }

        val contentIntent =
            PendingIntent.getActivity(appContext, 0, launchIntent, pendingFlags)

        val builder =
            NotificationCompat.Builder(appContext, CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_menu)
                .setContentTitle(appContext.getString(R.string.boot_restore_title))
                .setContentText(appContext.getString(R.string.boot_restore_body))
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setCategory(NotificationCompat.CATEGORY_STATUS)
                .setAutoCancel(true)
                .setContentIntent(contentIntent)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            builder.setFullScreenIntent(contentIntent, true)
        }

        manager.notify(NOTIFICATION_ID, builder.build())
    }
}
