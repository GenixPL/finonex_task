package com.example.finonex_task

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var secureStorageManager: SecureStorageManager

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        secureStorageManager = SecureStorageManager(this)

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.finonex_task/connectivity",
        ).setStreamHandler(ConnectivityManager(this))

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.finonex_task/secure_storage"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getKey" -> {
                    val key = call.argument<String>("key")
                    if (key != null) {
                        result.success(secureStorageManager.get(key))
                    } else {
                        result.error("INVALID_ARGUMENT", "Key is null", null)
                    }
                }
                "setKey" -> {
                    val key = call.argument<String>("key")
                    val value = call.argument<String>("value")
                    if (key != null && value != null) {
                        secureStorageManager.set(key, value)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "Key or value is null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
