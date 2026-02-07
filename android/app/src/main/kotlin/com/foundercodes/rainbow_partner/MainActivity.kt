package com.foundercodes.rainbow_partner

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private lateinit var methodChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createServiceChannel()
            recreateBookingChannel()
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "rainbow_partner/native_callback"
        )
    }

    // 🔹 FOREGROUND SERVICE CHANNEL
    private fun createServiceChannel() {
        val channel = NotificationChannel(
            "SERVICE_CHANNEL",
            "Background Service",
            NotificationManager.IMPORTANCE_LOW
        )
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(channel)
    }

    // 🔔 BOOKING / CALL CHANNEL
    private fun recreateBookingChannel() {
        val manager = getSystemService(NotificationManager::class.java)

        manager.deleteNotificationChannel("BOOKING_CHANNEL")

        val soundUri = Uri.parse(
            "android.resource://$packageName/raw/booking_ring"
        )

        val channel = NotificationChannel(
            "BOOKING_CHANNEL",
            "Booking Alerts",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Incoming ride requests"
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            setShowBadge(true)
            setSound(
                soundUri,
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                    .build()
            )
        }

        manager.createNotificationChannel(channel)
    }

    // ✅ EXAMPLE: native → flutter trigger
    fun sendRideToFlutter(data: Map<String, Any>) {
        if (::methodChannel.isInitialized) {
            methodChannel.invokeMethod("onRideEvent", data)
        }
    }
}
