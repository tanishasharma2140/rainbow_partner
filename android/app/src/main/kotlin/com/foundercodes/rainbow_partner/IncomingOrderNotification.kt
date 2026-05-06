package com.foundercodes.rainbow_partner

import android.app.NotificationManager
import android.content.Context
import android.util.Log

object IncomingOrderNotification {
    private const val tag = "IncomingOrderNotification"
    private const val NOTIFICATION_ID = 9301

    fun ensureChannel(context: Context) {
        // No longer needed for overlay style
    }

    fun show(
        context: Context,
        orderId: String,
        pickupAddress: String,
        dropAddress: String,
        distance: String = "",
        amount: String = "",
        routeName: String = "live_ride_screen" // Directly using string to avoid unresolved reference
    ) {
        // Disabled status bar notification as per user request
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
