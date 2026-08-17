package com.zenshield.vpn.handlers

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.Uri
import android.os.Build
import android.util.Base64
import com.google.gson.Gson
import com.google.gson.annotations.SerializedName
import com.zenshield.vpn.Application
import com.zenshield.vpn.Application.Companion.packageManager
import com.zenshield.vpn.utils.SafeResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.StandardMethodCodec
import java.io.ByteArrayOutputStream
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class PlatformSettingsHandler :
        FlutterPlugin,
        MethodChannel.MethodCallHandler,
        ActivityAware,
        PluginRegistry.ActivityResultListener {
    private var channel: MethodChannel? = null
    private var activity: Activity? = null
    private lateinit var ignoreRequestResult: MethodChannel.Result

    companion object {
        const val CHANNEL_NAME = "com.zenshield.vpn/platform"
        const val REQUEST_IGNORE_BATTERY_OPTIMIZATIONS = 44
        const val TARGET_ICON_SIZE = 72
        val gson = Gson()
        private val iconCache = mutableMapOf<String, String>()

        enum class Trigger(val method: String) {
            IsIgnoringBatteryOptimizations("is_ignoring_battery_optimizations"),
            RequestIgnoreBatteryOptimizations("request_ignore_battery_optimizations"),
            OpenBatteryOptimizationSettings("open_battery_optimization_settings"),
            GetInstalledPackages("get_installed_packages"),
            GetPackagesIcon("get_package_icon"),
            IsVpnActive("is_vpn_active"),
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val taskQueue = flutterPluginBinding.binaryMessenger.makeBackgroundTaskQueue()
        channel =
                MethodChannel(
                        flutterPluginBinding.binaryMessenger,
                        CHANNEL_NAME,
                        StandardMethodCodec.INSTANCE,
                        taskQueue
                )
        channel!!.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == REQUEST_IGNORE_BATTERY_OPTIMIZATIONS) {
            ignoreRequestResult.success(resultCode == Activity.RESULT_OK)
            return true
        }
        return false
    }

    data class AppItem(
            @SerializedName("package-name") val packageName: String,
            @SerializedName("name") val name: String,
            @SerializedName("is-system-app") val isSystemApp: Boolean
    )

    @SuppressLint("BatteryLife")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val safeResult = SafeResult(result)
        when (call.method) {
            Trigger.IsIgnoringBatteryOptimizations.method -> {
                try {
                    val isIgnoring =
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                Application.powerManager.isIgnoringBatteryOptimizations(
                                        Application.application.packageName
                                )
                            } else {
                                true
                            }
                    safeResult.success(isIgnoring)
                } catch (e: Exception) {
                    safeResult.error(
                            "BATTERY_OPT_ERROR",
                            "Failed to check battery optimizations: ${e.message}",
                            null
                    )
                }
            }
            Trigger.RequestIgnoreBatteryOptimizations.method -> {
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
                    return safeResult.success(true)
                }
                val intent =
                        Intent(
                                android.provider.Settings
                                        .ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
                                Uri.parse("package:${Application.application.packageName}")
                        )
                ignoreRequestResult = safeResult
                activity?.startActivityForResult(intent, REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
            }
            Trigger.OpenBatteryOptimizationSettings.method -> {
                // Android has no API for an app to revoke its own battery
                // optimization exemption, so send the user to the system
                // screen where they can turn it off themselves.
                try {
                    val intent =
                            Intent(
                                    android.provider.Settings
                                            .ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS
                            )
                    activity?.startActivity(intent)
                    safeResult.success(true)
                } catch (e: Exception) {
                    try {
                        val fallbackIntent =
                                Intent(
                                        android.provider.Settings
                                                .ACTION_APPLICATION_DETAILS_SETTINGS,
                                        Uri.parse(
                                                "package:${Application.application.packageName}"
                                        )
                                )
                        activity?.startActivity(fallbackIntent)
                        safeResult.success(true)
                    } catch (e2: Exception) {
                        safeResult.error(
                                "OPEN_SETTINGS_ERROR",
                                "Failed to open battery optimization settings: ${e2.message}",
                                null
                        )
                    }
                }
            }
            Trigger.GetInstalledPackages.method -> {
                GlobalScope.launch {
                    try {
                        val installedPackages =
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                    packageManager.getInstalledPackages(
                                            PackageManager.PackageInfoFlags.of(
                                                    PackageManager.GET_PERMISSIONS.toLong()
                                            )
                                    )
                                } else {
                                    @Suppress("DEPRECATION")
                                    packageManager.getInstalledPackages(
                                            PackageManager.GET_PERMISSIONS
                                    )
                                }

                        val list = mutableListOf<AppItem>()

                        for (packageInfo in installedPackages) {
                            if (packageInfo.packageName == Application.application.packageName ||
                                            packageInfo.requestedPermissions?.contains(
                                                    Manifest.permission.INTERNET
                                            ) != true
                            ) {
                                continue
                            }

                            try {
                                val appInfo = packageInfo.applicationInfo ?: continue
                                val labelSequence = appInfo.loadLabel(packageManager)
                                val appName =
                                        if (labelSequence.isNotBlank()) {
                                            labelSequence.toString()
                                        } else {
                                            packageInfo.packageName
                                        }

                                list.add(
                                        AppItem(
                                                packageInfo.packageName,
                                                appName,
                                                (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0
                                        )
                                )
                            } catch (e: Exception) {
                                continue
                            }
                        }

                        list.sortWith { a, b -> a.name.compareTo(b.name, ignoreCase = true) }
                        safeResult.success(gson.toJson(list))
                    } catch (e: Exception) {
                        safeResult.error(
                                "PACKAGES_ERROR",
                                "Failed to get installed packages: ${e.message}",
                                null
                        )
                    }
                }
            }
            Trigger.GetPackagesIcon.method -> {
                try {
                    val args = call.arguments as Map<*, *>
                    val packageName = args["packageName"] as String

                    if (iconCache.containsKey(packageName)) {
                        safeResult.success(iconCache[packageName])
                        return
                    }

                    val drawable = packageManager.getApplicationIcon(packageName)
                    val originalBitmap =
                            when (drawable) {
                                is BitmapDrawable -> drawable.bitmap
                                else -> {
                                    val bitmap =
                                            Bitmap.createBitmap(
                                                    drawable.intrinsicWidth,
                                                    drawable.intrinsicHeight,
                                                    Bitmap.Config.ARGB_8888
                                            )
                                    val canvas = Canvas(bitmap)
                                    drawable.setBounds(0, 0, canvas.width, canvas.height)
                                    drawable.draw(canvas)
                                    bitmap
                                }
                            }

                    val optimizedBitmap =
                            if (originalBitmap.width > TARGET_ICON_SIZE ||
                                            originalBitmap.height > TARGET_ICON_SIZE
                            ) {
                                Bitmap.createScaledBitmap(
                                        originalBitmap,
                                        TARGET_ICON_SIZE,
                                        TARGET_ICON_SIZE,
                                        true
                                )
                            } else {
                                originalBitmap
                            }

                    val byteArrayOutputStream = ByteArrayOutputStream()
                    optimizedBitmap.compress(Bitmap.CompressFormat.PNG, 0, byteArrayOutputStream)
                    val base64: String =
                            Base64.encodeToString(
                                    byteArrayOutputStream.toByteArray(),
                                    Base64.NO_WRAP
                            )

                    iconCache[packageName] = base64
                    safeResult.success(base64)
                } catch (e: Exception) {
                    safeResult.error("ICON_ERROR", "Failed to get package icon: ${e.message}", null)
                }
            }
            Trigger.IsVpnActive.method -> {
                try {
                    val connectivityManager =
                            Application.application.getSystemService(
                                    Context.CONNECTIVITY_SERVICE
                            ) as ConnectivityManager
                    // Our own app's traffic is deliberately excluded from the
                    // tunnel (see VPNService.openTun's addExcludePackage), so
                    // getActiveNetwork() for this process never reports the
                    // VPN transport even while it's genuinely up for every
                    // other app. Scan all networks instead of just our own.
                    val isActive =
                            connectivityManager.allNetworks.any { network: Network ->
                                connectivityManager
                                        .getNetworkCapabilities(network)
                                        ?.hasTransport(NetworkCapabilities.TRANSPORT_VPN) == true
                            }
                    safeResult.success(isActive)
                } catch (e: Exception) {
                    safeResult.error(
                            "VPN_STATE_ERROR",
                            "Failed to check VPN active state: ${e.message}",
                            null
                    )
                }
            }
            else -> safeResult.notImplemented()
        }
    }
}
