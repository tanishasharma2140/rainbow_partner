package com.foundercodes.rainbow_partner

import android.annotation.SuppressLint
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.provider.Settings
import android.util.Log
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView

class RapidoIncomingOrderOverlayService : Service() {
    private var windowManager: WindowManager? = null
    private var overlayView: View? = null
    private var layoutParams: WindowManager.LayoutParams? = null
    private val tag = "RapidoIncomingOrder"

    private val mainHandler = Handler(Looper.getMainLooper())
    private var scheduledShow: Runnable? = null

    private var pickup: String = ""
    private var drop: String = ""
    private var distance: String = ""
    private var rideDistance: String = ""
    private var id: String = ""
    private var userId: String = ""
    private var amount: String = ""
    private var panel: String = "driver"
    private var orderType: Int = 1
    private var scheduleTime: String = ""

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        // Start as foreground service to ensure it runs even when app is killed
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForeground(9301, IncomingOrderNotification.createForegroundNotification(this))
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_SCHEDULE_SHOW -> {
                pickup   = intent.getStringExtra("pickup")   ?: ""
                drop     = intent.getStringExtra("drop")     ?: ""
                distance = intent.getStringExtra("pickup_distance_km") ?: intent.getStringExtra("distance") ?: "0.0"
                rideDistance = intent.getStringExtra("distance_km") ?: "0.0"
                id       = intent.getStringExtra("id")       ?: ""
                userId   = intent.getStringExtra("user_id")  ?: ""
                amount   = intent.getStringExtra("amount")   ?: ""
                panel    = intent.getStringExtra("panel")    ?: "driver"
                orderType = intent.getIntExtra("order_type", 1)
                scheduleTime = intent.getStringExtra("schedule_time") ?: ""
                
                Log.d(tag, "Action Schedule Show: ID=$id, Panel=$panel, Amount=$amount, RideDist=$rideDistance")
                scheduleShow(intent.getLongExtra(EXTRA_DELAY_MS, DEFAULT_DELAY_MS))
            }
            ACTION_SHOW_NOW -> showNow()
            ACTION_HIDE -> hideAndStop()
        }
        return START_STICKY
    }

    private fun scheduleShow(delayMs: Long) {
        val canDraw = Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(this)
        if (!canDraw) { 
            Log.e(tag, "Cannot draw overlay: Permission missing")
            hideAndStop(); return 
        }
        cancelScheduledShow()
        val runnable = Runnable { showNow() }
        scheduledShow = runnable
        mainHandler.postDelayed(runnable, delayMs.coerceAtLeast(0))
    }

    private fun cancelScheduledShow() {
        scheduledShow?.let { mainHandler.removeCallbacks(it) }
        scheduledShow = null
    }

    private fun showNow() {
        cancelScheduledShow()
        val canDraw = Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(this)
        if (!canDraw || overlayView != null) return

        val root = FrameLayout(this).apply { isClickable = false; isFocusable = false }
        val expandedCard = buildExpandedCardView(
            onAccept = {
                sendAcceptToFlutter(id)
                IncomingOrderFirebaseService.stopIncomingOrderAlert(this@RapidoIncomingOrderOverlayService)
            },
            onIgnore = {
                sendIgnoreToFlutter(id)
                IncomingOrderFirebaseService.stopIncomingOrderAlert(this@RapidoIncomingOrderOverlayService)
            }
        )
        root.addView(expandedCard)

        val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
                   else @Suppress("DEPRECATION") WindowManager.LayoutParams.TYPE_PHONE

        layoutParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.WRAP_CONTENT,
            type, WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.CENTER_HORIZONTAL
            y = dp(20)
        }
        
        try {
            overlayView = root
            windowManager?.addView(overlayView, layoutParams)
        } catch (e: Exception) {
            Log.e(tag, "Error adding overlay view", e)
        }
    }

    @SuppressLint("ClickableViewAccessibility")
    private fun buildExpandedCardView(onAccept: () -> Unit, onIgnore: () -> Unit): View {
        val card = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(dp(20), dp(16), dp(20), dp(20))
            background = GradientDrawable().apply { cornerRadius = dp(28).toFloat(); setColor(Color.WHITE) }
            elevation = dp(16).toFloat()
            layoutParams = FrameLayout.LayoutParams(-1, -2).apply { setMargins(dp(20), 0, dp(20), 0) }
        }

        val headerRow = FrameLayout(this).apply {
            layoutParams = LinearLayout.LayoutParams(-1, -2)
        }
        
        val closeBtn = ImageView(this).apply {
            setImageResource(android.R.drawable.ic_menu_close_clear_cancel); setColorFilter(Color.GRAY)
            layoutParams = FrameLayout.LayoutParams(dp(24), dp(24)).apply { gravity = Gravity.END }
            setOnClickListener { onIgnore() }
        }
        headerRow.addView(closeBtn)
        card.addView(headerRow)

        val amountTv = TextView(this).apply {
            text = "₹$amount"; textSize = 34f; setTypeface(null, Typeface.BOLD); setTextColor(Color.parseColor("#1A237E")); gravity = Gravity.CENTER
        }
        card.addView(amountTv)

        val distanceBadge = TextView(this).apply {
            val distText = when {
                panel == "serviceman" -> "● New Service Request"
                orderType == 2       -> "● Scheduled Ride"
                else                 -> "● Pickup $distance km away"
            }
            text = distText; textSize = 14f; setTextColor(Color.parseColor("#2E7D32"))
            setPadding(dp(14), dp(6), dp(14), dp(6)); gravity = Gravity.CENTER
            background = GradientDrawable().apply { setColor(Color.parseColor("#F5F5F5")); cornerRadius = dp(20).toFloat() }
            layoutParams = LinearLayout.LayoutParams(-2, -2).apply { gravity = Gravity.CENTER; topMargin = dp(8) }
        }
        card.addView(distanceBadge)

        if (rideDistance.isNotEmpty() && rideDistance != "0.0") {

            val rideText = if (panel == "serviceman") {
                "You need to travel $rideDistance km to provide this service"
            } else {
                "User Travelling distance: $rideDistance km"
            }

            val rideDistTv = TextView(this).apply {
                text = rideText
                textSize = 14f
                setTypeface(null, Typeface.BOLD)
                setTextColor(Color.parseColor("#424242"))
                gravity = Gravity.CENTER
                layoutParams = LinearLayout.LayoutParams(-1, -2).apply {
                    topMargin = dp(8)
                }
            }

            card.addView(rideDistTv)
        }

        if (orderType == 2 && scheduleTime.isNotEmpty()) {
            val scheduleBanner = TextView(this).apply {
                text = "Scheduled: $scheduleTime"
                textSize = 14f
                setTextColor(Color.WHITE)
                setPadding(dp(14), dp(10), dp(14), dp(10))
                gravity = Gravity.CENTER
                background = GradientDrawable().apply {
                    setColor(Color.parseColor("#1A237E"))
                    cornerRadius = dp(12).toFloat()
                }
                layoutParams = LinearLayout.LayoutParams(-1, -2).apply { topMargin = dp(10) }
            }
            card.addView(scheduleBanner)
        }

        card.addView(spacer(dp(20)))

        // Pickup and Drop section with Green/Red indicators
        val locationContainer = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            layoutParams = LinearLayout.LayoutParams(-1, -2)
        }

        val indicatorColumn = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
            layoutParams = LinearLayout.LayoutParams(dp(20), -2).apply { topMargin = dp(6) }
        }
        
        val greenCircle = View(this).apply {
            layoutParams = LinearLayout.LayoutParams(dp(10), dp(10))
            background = GradientDrawable().apply { shape = GradientDrawable.OVAL; setColor(Color.parseColor("#4CAF50")) }
        }
        val line = View(this).apply {
            layoutParams = LinearLayout.LayoutParams(dp(2), dp(50)) // height kam ki
            background = GradientDrawable().apply {
                setColor(Color.LTGRAY)
            }
        }
        val redCircle = View(this).apply {
            layoutParams = LinearLayout.LayoutParams(dp(10), dp(10))
            background = GradientDrawable().apply { shape = GradientDrawable.OVAL; setColor(Color.parseColor("#F44336")) }
        }
        indicatorColumn.addView(greenCircle); indicatorColumn.addView(line); indicatorColumn.addView(redCircle)

        val addressColumn = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(0, -2, 1f).apply { marginStart = dp(12) }
        }
        
        val pickupTv = TextView(this).apply {
            text = pickup; setTextColor(Color.BLACK); textSize = 14f; maxLines = 2; setTypeface(null, Typeface.BOLD)
        }
        val dropTv = TextView(this).apply {
            text = drop; setTextColor(Color.parseColor("#616161")); textSize = 14f; maxLines = 2; setTypeface(null, Typeface.BOLD)
            layoutParams = LinearLayout.LayoutParams(-1, -2).apply { topMargin = dp(20) }
        }
        
        addressColumn.addView(pickupTv); addressColumn.addView(dropTv)
        
        locationContainer.addView(indicatorColumn); locationContainer.addView(addressColumn)
        card.addView(locationContainer)

        card.addView(spacer(dp(24)))

        val slideContainer = FrameLayout(this).apply {
            layoutParams = LinearLayout.LayoutParams(-1, dp(64))
            background = GradientDrawable().apply { cornerRadius = dp(32).toFloat(); setColor(Color.parseColor("#4169E1")) }
        }
        val slideText = TextView(this).apply {
            text = if (orderType == 2) "Accept Schedule ₹$amount" else "Accept for ₹$amount"
            gravity = Gravity.CENTER; textSize = 17f; setTypeface(null, Typeface.BOLD); setTextColor(Color.WHITE)
            setPadding(dp(70), 0, dp(16), 0)
        }
        val knob = FrameLayout(this).apply {
            layoutParams = FrameLayout.LayoutParams(dp(56), dp(56)).apply { gravity = Gravity.START or Gravity.CENTER_VERTICAL; leftMargin = dp(4) }
            background = GradientDrawable().apply { shape = GradientDrawable.OVAL; setColor(Color.WHITE) }
            addView(ImageView(this@RapidoIncomingOrderOverlayService).apply { setImageResource(android.R.drawable.ic_media_play); setColorFilter(Color.parseColor("#4169E1")); layoutParams = FrameLayout.LayoutParams(dp(24), dp(24), Gravity.CENTER) })
        }
        slideContainer.addView(slideText); slideContainer.addView(knob)

        knob.setOnTouchListener(object : View.OnTouchListener {
            private var dX = 0f
            override fun onTouch(v: View, event: MotionEvent): Boolean {
                val maxSlide = slideContainer.width - v.width - dp(8)
                when (event.action) {
                    MotionEvent.ACTION_DOWN -> dX = v.x - event.rawX
                    MotionEvent.ACTION_MOVE -> {
                        var newX = event.rawX + dX
                        v.x = newX.coerceIn(dp(4).toFloat(), maxSlide.toFloat())
                    }
                    MotionEvent.ACTION_UP -> {
                        if (v.x > maxSlide * 0.8) { v.x = maxSlide.toFloat(); onAccept() }
                        else v.animate().x(dp(4).toFloat()).setDuration(200).start()
                    }
                }
                return true
            }
        })
        card.addView(slideContainer)

        val ignoreBtn = TextView(this).apply {
            text = "Ignore Order"; textSize = 15f; setTextColor(Color.GRAY); gravity = Gravity.CENTER
            setPadding(dp(16), dp(12), dp(16), dp(12)); setOnClickListener { onIgnore() }
        }
        card.addView(ignoreBtn)
        return card
    }

    private fun spacer(h: Int) = View(this).apply { layoutParams = LinearLayout.LayoutParams(-1, h) }

    private fun sendAcceptToFlutter(id: String) {
        val i = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            putExtra(EXTRA_NAV_ROUTE, ROUTE_ACCEPT_RIDE); putExtra(EXTRA_ORDER_ID, id); putExtra("user_id", userId)
            putExtra("pickup_address", pickup); putExtra("drop_address", drop); putExtra("distance", distance)
            putExtra("distance_km", rideDistance)
            putExtra("amount", amount); putExtra("panel", panel)
            putExtra("order_type", orderType); putExtra("schedule_time", scheduleTime)
        }
        startActivity(i); hideAndStop()
    }

    private fun sendIgnoreToFlutter(id: String) {
        val i = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            putExtra(EXTRA_NAV_ROUTE, ROUTE_IGNORE_RIDE); putExtra(EXTRA_ORDER_ID, id); putExtra("panel", panel)
        }
        startActivity(i); hideAndStop()
    }

    private fun hideAndStop() { removeOverlayIfPresent(); stopSelf() }
    private fun removeOverlayIfPresent() { overlayView?.let { try { windowManager?.removeView(it) } catch (_: Throwable) {} }; overlayView = null }
    private fun dp(v: Int) = (v * resources.displayMetrics.density).toInt()

    companion object {
        const val ACTION_SCHEDULE_SHOW = "com.foundercodes.rainbow_partner.action.SCHEDULE_INCOMING_ORDER_OVERLAY"
        const val ACTION_SHOW_NOW      = "com.foundercodes.rainbow_partner.action.SHOW_INCOMING_ORDER_OVERLAY"
        const val ACTION_HIDE          = "com.foundercodes.rainbow_partner.action.HIDE_INCOMING_ORDER_OVERLAY"
        const val EXTRA_NAV_ROUTE      = "com.foundercodes.rainbow_partner.extra.NAV_ROUTE"
        const val EXTRA_ORDER_ID       = "com.foundercodes.rainbow_partner.extra.ORDER_ID"
        const val ROUTE_ACCEPT_RIDE    = "accept_ride_action"
        const val ROUTE_IGNORE_RIDE    = "ignore_ride_action"
        const val ROUTE_LIVE_RIDE      = "live_ride_screen"
        const val EXTRA_DELAY_MS       = "com.foundercodes.rainbow_partner.extra.DELAY_MS"
        const val DEFAULT_DELAY_MS     = 0L
        fun start(context: Context, action: String) { 
            val intent = Intent(context, RapidoIncomingOrderOverlayService::class.java).apply { this.action = action }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }
    }
}
