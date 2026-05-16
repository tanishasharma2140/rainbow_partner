package com.foundercodes.rainbow_partner

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.util.Log

object IncomingOrderNotification {
    private const val tag = "IncomingOrderNotification"
    private const val NOTIFICATION_ID = 9301
    const val CHANNEL_ID = "incoming_order_service_channel"

    fun ensureChannel(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Incoming Order"
            val descriptionText = "Service for incoming ride requests"
            val importance = NotificationManager.IMPORTANCE_LOW
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
                setShowBadge(false)
            }
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    fun createForegroundNotification(context: Context): Notification {
        ensureChannel(context)
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(context, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(context)
        }

        return builder
            .setContentTitle("New Order Request")
            .setContentText("Incoming order overlay is active")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setOngoing(true)
            .build()
    }

    fun show(
        context: Context,
        orderId: String,
        pickupAddress: String,
        dropAddress: String,
        distance: String = "",
        amount: String = "",
        routeName: String = "live_ride_screen"
    ) {
        Log.d(tag, "show: Status bar notification is disabled. Using Overlay instead.")
    }

    fun cancel(context: Context) {
        try {
            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.cancel(NOTIFICATION_ID)
        } catch (e: Exception) {
            Log.e(tag, "Error cancelling notification", e)
        }
    }
}
