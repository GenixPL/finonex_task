package com.example.finonex_task

import android.content.Context
import android.net.ConnectivityManager as AndroidConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel

class ConnectivityManager(private val context: Context) : EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null
    private var networkCallback: AndroidConnectivityManager.NetworkCallback? = null
    private val handler = Handler(Looper.getMainLooper())

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as AndroidConnectivityManager

        networkCallback = object : AndroidConnectivityManager.NetworkCallback() {
            override fun onAvailable(network: Network) {
                handler.post { eventSink?.success("connected") }
            }

            override fun onLost(network: Network) {
                handler.post { eventSink?.success("notConnected") }
            }
        }

        val networkRequest = NetworkRequest.Builder()
            .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
            .build()
        connectivityManager.registerNetworkCallback(networkRequest, networkCallback!!)

        // Initial state
        val activeNetwork = connectivityManager.activeNetwork
        val capabilities = connectivityManager.getNetworkCapabilities(activeNetwork)
        val isConnected = capabilities?.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) == true
        eventSink?.success(if (isConnected) "connected" else "notConnected")
    }

    override fun onCancel(arguments: Any?) {
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as AndroidConnectivityManager
        networkCallback?.let { connectivityManager.unregisterNetworkCallback(it) }
        networkCallback = null
        eventSink = null
    }
}
