package com.celeb.planner

import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val UPI_CHANNEL = "upi/tez"
    private val SOURCE_CHANNEL = "source_channel"
    private val APP_CONTROL_CHANNEL = "app/control"
    private var callResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ✅ Source Channel (to check if installed from Play Store or Website)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SOURCE_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSource") {
                val source = getAppSource()
                result.success(source)
            } else {
                result.notImplemented()
            }
        }

        // ✅ UPI Channel (to launch UPI payment intent)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, UPI_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "launchUpi") {
                launchUpiIntent(call, result)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, APP_CONTROL_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "forceClose") {
                finishAffinity() // Close all activities
                System.exit(0)   // Kill the app process
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    // ✅ Fetch App Source (Play Store vs Website)
    private fun getAppSource(): String {
        return try {
            val appInfo: ApplicationInfo = packageManager.getApplicationInfo(packageName, PackageManager.GET_META_DATA)
            appInfo.metaData?.getString("source") ?: "unknown"
        } catch (e: Exception) {
            "error"
        }
    }

    // ✅ Launch UPI Intent
    private fun launchUpiIntent(call: MethodCall, result: MethodChannel.Result) {
        val uriString = call.argument<String>("url")
        if (uriString.isNullOrEmpty()) {
            result.error("INVALID_URL", "URL is null or empty", null)
            return
        }

        val uri = Uri.parse(uriString)
        val intent = Intent(Intent.ACTION_VIEW, uri)

        try {
            val chooserIntent = Intent.createChooser(intent, "Choose UPI app")
            startActivityForResult(chooserIntent, 1)
            callResult = result
        } catch (e: Exception) {
            Log.e("LaunchUPI", "Error launching UPI intent: ${e.message}")
            result.error("LAUNCH_ERROR", e.message, null)
        }
    }

    // ✅ Handle UPI Payment Result
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == 1 && callResult != null) {
            val res = data?.getStringExtra("response")
            val response = if (!res.isNullOrEmpty() && res.lowercase().contains("success")) {
                "Success"
            } else {
                "Failed"
            }
            callResult?.success(response)
            callResult = null  // Reset the result reference
        }
    }
}

