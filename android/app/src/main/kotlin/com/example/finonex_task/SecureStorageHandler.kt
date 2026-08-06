package com.example.finonex_task

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SecureStorageHandler(private val secureStorageManager: SecureStorageManager) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
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
            "deleteKey" -> {
                val key = call.argument<String>("key")
                if (key != null) {
                    secureStorageManager.delete(key)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "Key is null", null)
                }
            }
            else -> result.notImplemented()
        }
    }
}
