package com.zenshield.vpn

import android.Manifest
import android.content.Context
import android.content.Intent
import android.net.VpnService
import androidx.activity.result.contract.ActivityResultContract
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.zenshield.vpn.bg.ServiceNotification
import com.zenshield.vpn.handlers.MethodHandler
import com.zenshield.vpn.handlers.PlatformSettingsHandler
import com.zenshield.vpn.handlers.ReviewHandler
import com.zenshield.vpn.handlers.UserIdMethodHandler
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : FlutterFragmentActivity() {
    companion object {
        const val EXTRA_BOOT_RESTORE = "boot_restore"
        lateinit var instance: MainActivity
        var serviceStartCallback: ServiceStartCallback? = null

        fun isInstanceInitialized(): Boolean {
            return ::instance.isInitialized
        }
    }

    interface ServiceStartCallback {
        fun onServiceStarted(success: Boolean)
        fun onPermissionDenied()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        instance = this

        flutterEngine.plugins.add(UserIdMethodHandler())
        flutterEngine.plugins.add(MethodHandler(lifecycleScope))
        flutterEngine.plugins.add(PlatformSettingsHandler())
        flutterEngine.plugins.add(ReviewHandler(lifecycleScope))
    }

    fun startService(callback: ServiceStartCallback?) {
        serviceStartCallback = callback

        if (!ServiceNotification.checkPermission()) {
            notificationPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
            return
        }

        lifecycleScope.launch(Dispatchers.IO) {
            if (prepare()) {
                return@launch
            }

            val intent = Intent(Application.application, Settings.serviceClass())
            withContext(Dispatchers.Main) {
                ContextCompat.startForegroundService(Application.application, intent)
                serviceStartCallback?.onServiceStarted(true)
                clearServiceCallback()
            }
        }
    }

    private fun clearServiceCallback() {
        serviceStartCallback = null
    }

    private val notificationPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted ->
        if (isGranted) {
            startService(serviceStartCallback)
        } else {
            serviceStartCallback?.onPermissionDenied()
            clearServiceCallback()
        }
    }

    private val prepareLauncher = registerForActivityResult(PrepareService()) { isGranted ->
        if (isGranted) {
            startService(serviceStartCallback)
        } else {
            serviceStartCallback?.onPermissionDenied()
            clearServiceCallback()
        }
    }

    private class PrepareService : ActivityResultContract<Intent, Boolean>() {
        override fun createIntent(context: Context, input: Intent): Intent {
            return input
        }

        override fun parseResult(resultCode: Int, intent: Intent?): Boolean {
            return resultCode == RESULT_OK
        }
    }

    private suspend fun prepare() = withContext(Dispatchers.Main) {
        try {
            val intent = VpnService.prepare(this@MainActivity)
            if (intent != null) {
                prepareLauncher.launch(intent)
                true
            } else {
                false
            }
        } catch (_: Exception) {
            serviceStartCallback?.onPermissionDenied()
            clearServiceCallback()
            false
        }
    }

    override fun onDestroy() {
        clearServiceCallback()
        super.onDestroy()
    }
}
