package com.foundercodes.rainbow_partner

import android.annotation.SuppressLint
import android.app.Activity
import android.app.KeyguardManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView

class IncomingOrderLockScreenActivity : Activity() {
    private val tag = "LockScreenActivity"
    private var removeReceiver: BroadcastReceiver? = null

    @SuppressLint("ClickableViewAccessibility")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Ensure activity shows over lockscreen
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            )
        }

        removeReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                Log.d(tag, "Received remove UI broadcast")
                finish()
            }
        }
        val filter = IntentFilter(IncomingOrderFirebaseService.ACTION_REMOVE_INCOMING_ORDER_UI)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(removeReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            registerReceiver(removeReceiver, filter)
        }

        IncomingOrderNotification.cancel(this)

        val orderId = intent.getStringExtra(RapidoIncomingOrderOverlayService.EXTRA_ORDER_ID) ?: ""
        val userId = intent.getStringExtra("user_id") ?: ""
        val pickupAddress = intent.getStringExtra("pickup_address") ?: "N/A"
        val dropAddress = intent.getStringExtra("drop_address") ?: "N/A"
        val pickupDistanceKm = intent.getStringExtra("pickup_distance_km") ?: "N/A"
        val amount = intent.getStringExtra("amount") ?: ""
        val panel = intent.getStringExtra("panel") ?: "driver"

        val root = FrameLayout(this).apply {
            setBackgroundColor(Color.parseColor("#99000000")) 
        }

        val card = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(dp(20), dp(20), dp(20), dp(20))
            layoutParams = FrameLayout.LayoutParams(-1, -2).apply {
                gravity = Gravity.CENTER
                setMargins(dp(24), 0, dp(24), 0)
            }
            background = GradientDrawable().apply {
                setColor(Color.WHITE)
                cornerRadius = dp(28).toFloat()
            }
            elevation = dp(16).toFloat()
        }

        // Amount
        card.addView(TextView(this).apply {
            text = "₹$amount"; textSize = 34f; setTypeface(null, Typeface.BOLD)
            setTextColor(Color.parseColor("#1A237E")); gravity = Gravity.CENTER
        })

        // Distance
        card.addView(TextView(this).apply {
            text = "● Pickup $pickupDistanceKm km away"; textSize = 14f; setTextColor(Color.parseColor("#2E7D32"))
            setPadding(dp(14), dp(6), dp(14), dp(6)); gravity = Gravity.CENTER
            background = GradientDrawable().apply { setColor(Color.parseColor("#F5F5F5")); cornerRadius = dp(20).toFloat() }
            layoutParams = LinearLayout.LayoutParams(-2, -2).apply { gravity = Gravity.CENTER; topMargin = dp(8) }
        })
        card.addView(spacer(dp(24)))

        // Pickup/Drop
        val texts = LinearLayout(this).apply { orientation = LinearLayout.VERTICAL; setPadding(dp(8), 0, 0, 0) }
        texts.addView(TextView(this).apply { text = pickupAddress; setTextColor(Color.BLACK); textSize = 15f; maxLines = 2 })
        texts.addView(spacer(dp(24)))
        texts.addView(TextView(this).apply { text = dropAddress; setTextColor(Color.DKGRAY); textSize = 15f; maxLines = 2 })
        card.addView(texts); card.addView(spacer(dp(30)))

        // SLIDER (Royal Blue)
        val slideContainer = FrameLayout(this).apply {
            layoutParams = LinearLayout.LayoutParams(-1, dp(64))
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#4169E1"))
                cornerRadius = dp(32).toFloat()
            }
        }

        val slideText = TextView(this).apply {
            text = "Agree for ₹$amount"; gravity = Gravity.CENTER; setTextColor(Color.WHITE); textSize = 17f; setTypeface(null, Typeface.BOLD)
        }

        val knob = FrameLayout(this).apply {
            layoutParams = FrameLayout.LayoutParams(dp(56), dp(56)).apply { gravity = Gravity.START or Gravity.CENTER_VERTICAL; leftMargin = dp(4) }
            background = GradientDrawable().apply { setColor(Color.WHITE); shape = GradientDrawable.OVAL }
            addView(ImageView(this@IncomingOrderLockScreenActivity).apply {
                setImageResource(android.R.drawable.ic_media_play); setColorFilter(Color.parseColor("#4169E1"))
                layoutParams = FrameLayout.LayoutParams(dp(24), dp(24), Gravity.CENTER)
            })
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
                        if (v.x > maxSlide * 0.8) {
                            v.x = maxSlide.toFloat()
                            handleAccept(orderId, userId, pickupAddress, dropAddress, pickupDistanceKm, amount, panel)
                        } else {
                            v.animate().x(dp(4).toFloat()).setDuration(200).start()
                        }
                    }
                }
                return true
            }
        })
        card.addView(slideContainer)

        // Ignore Order
        card.addView(TextView(this).apply {
            text = "Ignore Order"; textSize = 15f; setTextColor(Color.GRAY); gravity = Gravity.CENTER
            setPadding(dp(16), dp(12), dp(16), dp(12)); setOnClickListener {
                launchMain(orderId, userId, pickupAddress, dropAddress, pickupDistanceKm, amount, panel, isIgnore = true)
            }
        })

        root.addView(card)
        setContentView(root)
    }

    private fun handleAccept(orderId: String, userId: String, pickup: String, drop: String, dist: String, amt: String, panel: String) {
        val km = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            km.requestDismissKeyguard(this, object : KeyguardManager.KeyguardDismissCallback() {
                override fun onDismissSucceeded() {
                    Log.d(tag, "Keyguard dismiss succeeded")
                    Handler(Looper.getMainLooper()).postDelayed({
                        launchMain(orderId, userId, pickup, drop, dist, amt, panel, isIgnore = false)
                    }, 200)
                }
                override fun onDismissCancelled() {
                    Log.d(tag, "Keyguard dismiss cancelled")
                    finish()
                }
                override fun onDismissError() {
                    Log.d(tag, "Keyguard dismiss error")
                    launchMain(orderId, userId, pickup, drop, dist, amt, panel, isIgnore = false)
                }
            })
        } else {
            launchMain(orderId, userId, pickup, drop, dist, amt, panel, isIgnore = false)
        }
    }

    private fun launchMain(orderId: String, userId: String, pickup: String, drop: String, dist: String, amt: String, panel: String, isIgnore: Boolean) {
        val mainIntent = Intent(this, MainActivity::class.java).apply {
            // Use existing task to avoid losing debugger connection
            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
            putExtra(RapidoIncomingOrderOverlayService.EXTRA_NAV_ROUTE, 
                if (isIgnore) RapidoIncomingOrderOverlayService.ROUTE_IGNORE_RIDE 
                else RapidoIncomingOrderOverlayService.ROUTE_ACCEPT_RIDE)
            putExtra(RapidoIncomingOrderOverlayService.EXTRA_ORDER_ID, orderId)
            putExtra("user_id", userId)
            putExtra("pickup_address", pickup); putExtra("drop_address", drop)
            putExtra("distance", dist); putExtra("amount", amt); putExtra("panel", panel)
        }
        startActivity(mainIntent)
        IncomingOrderFirebaseService.stopIncomingOrderAlert(this)
        finish()
    }

    private fun dp(v: Int) = (v * resources.displayMetrics.density).toInt()
    private fun spacer(h: Int) = View(this).apply { layoutParams = LinearLayout.LayoutParams(-1, h) }

    override fun onDestroy() {
        try { removeReceiver?.let { unregisterReceiver(it) } } catch (_: Throwable) {}
        super.onDestroy()
    }
}
