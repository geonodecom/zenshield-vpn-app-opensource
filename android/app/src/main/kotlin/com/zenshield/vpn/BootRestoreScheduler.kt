package com.zenshield.vpn

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.SystemClock
import android.util.Log
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import java.util.concurrent.TimeUnit

object BootRestoreScheduler {
    private const val TAG = "BootRestoreScheduler"
    private const val WORK_NAME = "boot_restore_launch"
    private const val ALARM_REQUEST_CODE = 42_001
    private const val LAUNCH_DELAY_MS = 5_000L

    fun schedule(context: Context) {
        scheduleAlarm(context)
        scheduleWork(context)
    }

    private fun scheduleAlarm(context: Context) {
        val appContext = context.applicationContext
        val alarmManager =
            appContext.getSystemService(Context.ALARM_SERVICE) as? AlarmManager ?: return

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

        val pendingIntent =
            PendingIntent.getActivity(
                appContext,
                ALARM_REQUEST_CODE,
                launchIntent,
                pendingFlags,
            )

        val triggerAt = SystemClock.elapsedRealtime() + LAUNCH_DELAY_MS

        try {
            when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
                    alarmManager.canScheduleExactAlarms() -> {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.ELAPSED_REALTIME_WAKEUP,
                        triggerAt,
                        pendingIntent,
                    )
                }
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.M -> {
                    alarmManager.setAndAllowWhileIdle(
                        AlarmManager.ELAPSED_REALTIME_WAKEUP,
                        triggerAt,
                        pendingIntent,
                    )
                }
                else -> {
                    alarmManager.set(
                        AlarmManager.ELAPSED_REALTIME_WAKEUP,
                        triggerAt,
                        pendingIntent,
                    )
                }
            }
            Log.i(TAG, "Scheduled delayed app launch alarm")
        } catch (e: Exception) {
            Log.w(TAG, "Failed to schedule boot launch alarm", e)
        }
    }

    private fun scheduleWork(context: Context) {
        val request =
            OneTimeWorkRequestBuilder<BootRestoreLaunchWorker>()
                .setInitialDelay(LAUNCH_DELAY_MS, TimeUnit.MILLISECONDS)
                .build()
        WorkManager.getInstance(context.applicationContext).enqueueUniqueWork(
            WORK_NAME,
            ExistingWorkPolicy.REPLACE,
            request,
        )
        Log.i(TAG, "Scheduled delayed app launch work")
    }
}

class BootRestoreLaunchWorker(
    context: Context,
    params: WorkerParameters,
) : Worker(context, params) {

    override fun doWork(): Result {
        if (!BootRestorePreferences.shouldRestoreOnBoot(applicationContext)) {
            return Result.success()
        }

        return try {
            val intent =
                Intent(applicationContext, MainActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    putExtra(MainActivity.EXTRA_BOOT_RESTORE, true)
                }
            applicationContext.startActivity(intent)
            Log.i(TAG, "Boot restore worker launched MainActivity")
            Result.success()
        } catch (e: Exception) {
            Log.w(TAG, "Boot restore worker could not launch MainActivity", e)
            Result.success()
        }
    }

    companion object {
        private const val TAG = "BootRestoreLaunchWorker"
    }
}
