package com.foundercodes.rainbow_partner

import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.os.PowerManager
import android.os.VibrationEffect
import android.os.Vibrator
import android.util.Log
import androidx.core.content.ContextCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import java.util.Locale

class IncomingOrderFirebaseService : FirebaseMessagingService() {
    private val tag = "IncomingOrderFCM"

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)

        val payload = remoteMessage.data
        Log.d(tag, "FCM Received: $payload")

        val rawType = payload["type"]?.toString()
        val type = rawType?.trim()?.lowercase(Locale.US)

        val orderId = payload["ride_id"]?.toString()
            ?: payload["rideId"]?.toString()
            ?: payload["order_id"]?.toString()
            ?: payload["booking_id"]?.toString()
            ?: payload["id"]?.toString()
            ?: ""

        val userId = payload["user_id"]?.toString() ?: ""

        if (type == "remove_ride" || type == "remove_order" || type == "cancel_order" || type == "remove_service") {
            stopIncomingOrderAlert(this@IncomingOrderFirebaseService)
            return
        }

        val isDriverNotification = type == "incoming_order" || payload["incoming_order"] == "1"
        val isServicemanNotification = type == "incoming_service_order" ||
                type == "new_service" ||
                type == "service_order" ||
                type == "service_booking" ||
                payload["incoming_service_order"] == "1"

        if (!isDriverNotification && !isServicemanNotification) {
            Log.d(tag, "Ignoring: Not a recognized order type ($type)")
            return
        }

        val prefs = getSharedPreferences("rapido_online_prefs", Context.MODE_PRIVATE)
        val isOnline = prefs.getBoolean("is_online", false)

        if (!isOnline) {
            Log.d(tag, "Ignoring: User is OFFLINE in system prefs")
            return
        }

        var pickup = payload["pickup_address"]?.toString()
            ?: payload["service_address"]?.toString()
            ?: payload["address"]?.toString()
            ?: ""

        var drop = payload["drop_address"]?.toString()
            ?: payload["service_name"]?.toString()
            ?: payload["category_name"]?.toString()
            ?: "New Service Request"

        val distance = payload["pickup_distance_km"]?.toString()
            ?: payload["distance"]?.toString()
            ?: "0.0"

        val rideDistance = payload["distance_km"]?.toString() ?: "0.0"

        val amount = payload["amount"]?.toString()
            ?: payload["final_amount"]?.toString()
            ?: payload["total_amount"]?.toString()
            ?: "0"

        val panel = if (isServicemanNotification) "serviceman" else "driver"

        startIncomingOrderAlert(this@IncomingOrderFirebaseService)

        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        val isScreenOn = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT_WATCH) {
            pm.isInteractive
        } else {
            @Suppress("DEPRECATION") pm.isScreenOn
        }

        Log.d(tag, "Triggering UI: ScreenOn=$isScreenOn, Panel=$panel, OrderId=$orderId")

        if (!isScreenOn) {
            wakeScreenBriefly()
            val lockIntent = Intent(this, IncomingOrderLockScreenActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                putExtra(RapidoIncomingOrderOverlayService.EXTRA_ORDER_ID, orderId)
                putExtra("user_id", userId); putExtra("pickup_address", pickup)
                putExtra("drop_address", drop); putExtra("pickup_distance_km", distance)
                putExtra("distance_km", rideDistance)
                putExtra("amount", amount); putExtra("panel", panel)
            }
            startActivity(lockIntent)
        } else {
            val overlayIntent = Intent(this, RapidoIncomingOrderOverlayService::class.java).apply {
                action = RapidoIncomingOrderOverlayService.ACTION_SCHEDULE_SHOW
                putExtra("pickup", pickup); putExtra("drop", drop)
                putExtra("pickup_distance_km", distance); putExtra("id", orderId)
                putExtra("distance_km", rideDistance)
                putExtra("amount", amount); putExtra("panel", panel); putExtra("user_id", userId)
                putExtra("order_type", payload["order_type"]?.toIntOrNull() ?: 1)
                putExtra("schedule_time", payload["schedule_time"] ?: "")
            }
            // Use helper or ContextCompat for foreground service start
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                startForegroundService(overlayIntent)
            } else {
                startService(overlayIntent)
            }
        }
    }

    private fun wakeScreenBriefly() {
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        val wakeLock = pm.newWakeLock(PowerManager.SCREEN_BRIGHT_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP, "rainbow:incoming_order")
        wakeLock.acquire(10_000L)
    }

    companion object {
        const val ACTION_REMOVE_INCOMING_ORDER_UI = "com.foundercodes.rainbow_partner.ACTION_REMOVE_INCOMING_ORDER_UI"
        private var mediaPlayer: MediaPlayer? = null
        private var vibrator: Vibrator? = null

        @Synchronized
        fun startIncomingOrderAlert(context: Context) {
            try {
                val appCtx = context.applicationContext
                if (mediaPlayer?.isPlaying == true) return
                vibrator = appCtx.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                val pattern = longArrayOf(0, 800, 400, 800)
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                    vibrator?.vibrate(VibrationEffect.createWaveform(pattern, 0))
                } else { @Suppress("DEPRECATION") vibrator?.vibrate(pattern, 0) }

                mediaPlayer?.release()
                val resId = appCtx.resources.getIdentifier("driver_rainbow", "raw", appCtx.packageName)
                mediaPlayer = if (resId != 0) MediaPlayer.create(appCtx, resId) else {
                    val alarmUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM) ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
                    MediaPlayer().apply { setDataSource(appCtx, alarmUri!!) }
                }
                mediaPlayer?.apply { isLooping = true; if (resId == 0) prepare(); start() }
            } catch (e: Exception) { Log.e("FCM", "startAlert error", e) }
        }

        @Synchronized
        fun stopIncomingOrderAlert(context: Context) {
            try {
                mediaPlayer?.let { if (it.isPlaying) it.stop() }
                mediaPlayer?.release(); mediaPlayer = null
                vibrator?.cancel(); vibrator = null
                RapidoIncomingOrderOverlayService.start(context, RapidoIncomingOrderOverlayService.ACTION_HIDE)
                context.sendBroadcast(Intent(ACTION_REMOVE_INCOMING_ORDER_UI).apply { setPackage(context.packageName) })
            } catch (e: Exception) { Log.e("FCM", "stopAlert error", e) }
        }
    }
}