package com.example.finonex_task

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.finonex_task/connectivity",
        ).setStreamHandler(ConnectivityManager(this))

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.finonex_task/secure_storage"
        ).setMethodCallHandler(SecureStorageHandler(SecureStorageManager(this)))
    }
}
