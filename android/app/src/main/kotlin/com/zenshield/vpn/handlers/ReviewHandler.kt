package com.zenshield.vpn.handlers

import android.content.ActivityNotFoundException
import android.content.Intent
import android.os.Handler
import android.os.Looper.getMainLooper
import android.widget.Toast
import androidx.core.net.toUri
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.google.android.gms.tasks.Task
import com.google.android.play.core.review.ReviewInfo
import com.google.android.play.core.review.ReviewManagerFactory
import com.zenshield.vpn.Application
import com.zenshield.vpn.MainActivity
import com.zenshield.vpn.utils.SafeResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

class ReviewHandler(private val scope: CoroutineScope) :
        FlutterPlugin, MethodChannel.MethodCallHandler {
    private var channel: MethodChannel? = null

    companion object {
        const val CHANNEL_NAME = "com.zenshield.vpn/review"

        enum class Trigger(val method: String) {
            ShowReview("show_review")
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel =
                MethodChannel(
                        flutterPluginBinding.binaryMessenger,
                        CHANNEL_NAME,
                )
        channel!!.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val safeResult = SafeResult(result)
        when (call.method) {
            Trigger.ShowReview.method -> {
                scope.launch {
                    try {
                        openGoogleDialog()
                        safeResult.success(null)
                    } catch (e: Exception) {
                        safeResult.error(
                                "REVIEW_ERROR",
                                "Failed to show review dialog: ${e.message}",
                                null
                        )
                    }
                }
            }
            else -> safeResult.notImplemented()
        }
    }

    private fun openGoogleDialog() {
        val googleApi = GoogleApiAvailability.getInstance()
        val availability = googleApi.isGooglePlayServicesAvailable(MainActivity.instance)
        if (availability == ConnectionResult.SUCCESS) {
            val opened = booleanArrayOf(false)
            val reviewManager = ReviewManagerFactory.create(MainActivity.instance)

            val request = reviewManager.requestReviewFlow()
            request.addOnCompleteListener { task: Task<ReviewInfo?> ->
                if (task.isSuccessful) {
                    val reviewInfo = task.result
                    Application.lastCreatedActivity = ""
                    val flow = reviewManager.launchReviewFlow(MainActivity.instance, reviewInfo!!)
                    flow.addOnCompleteListener { task2: Task<Void?> ->
                        if (task2.isSuccessful) {
                            Handler(getMainLooper())
                                    .postDelayed(
                                            {
                                                if (Application.lastCreatedActivity.length < 5 &&
                                                                !opened[0]
                                                ) {
                                                    opened[0] = true
                                                    openGP(1)
                                                }
                                            },
                                            3000
                                    )
                        } else {
                            openGP(1)
                        }
                    }
                } else {
                    openGP(2)
                }
            }
        } else {
            openGP(3)
        }
    }

    private fun openGP(scenario: Int) {
        val context = MainActivity.instance
        val packageName = context.packageName

        try {
            val marketIntent =
                    Intent(Intent.ACTION_VIEW).apply {
                        data = "market://details?id=$packageName".toUri()
                        setPackage("com.android.vending")
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }
            context.startActivity(marketIntent)
        } catch (_: ActivityNotFoundException) {
            try {
                val webIntent =
                        Intent(Intent.ACTION_VIEW).apply {
                            data =
                                    "https://play.google.com/store/apps/details?id=$packageName".toUri()
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }
                context.startActivity(webIntent)
            } catch (e: Exception) {
                Toast.makeText(context, "Error opening Google Play", Toast.LENGTH_SHORT).show()
                logScenario(scenario, e)
            }
        }
    }

    private fun logScenario(scenario: Int, e: Exception? = null) {
        when (scenario) {
            1 -> println("Error while open review dialog")
            2 -> println("Error while get ReviewInfo")
            3 -> println("Google Play Services is not available")
        }
        e?.printStackTrace()
    }
}
