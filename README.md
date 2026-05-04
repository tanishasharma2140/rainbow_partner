# rainbow_partner

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Rapido-style Android Overlay (Bubble + Incoming Order Card) — Full Code

This document is meant to be **shared with another developer** so they can implement the same behavior in a different Flutter app.

## What this implementation does

### Bubble overlay
- Shows a draggable circular bubble when the app goes to background.
- Tap bubble → opens the app.

### Incoming order overlay (big card)
- Schedules a big top card overlay after **60 seconds** in background.
- Card interactions:
    - Tap card background → does nothing
    - Tap **Accept** → opens app + navigates to route `live_ride_screen`
    - Tap **Minimize (-)** → collapses to bubble
    - Tap minimized bubble → opens app and closes the overlay (does NOT expand)

### ONLINE rule
- Overlays show only when user is **ONLINE** (Flutter sends `setOnline` to Android).

### Android permission
- Overlay permission is `SYSTEM_ALERT_WINDOW`.
- Android cannot show a runtime popup for this permission; you must open Settings using `ACTION_MANAGE_OVERLAY_PERMISSION`.

---

## Copy-paste files (complete)

## When porting to another app (must update)

- Android package: update the Kotlin package line `package com.fc.rapido_style` and file path accordingly.
- MethodChannel name: keep consistent across Flutter + Android. Current value: `rapido_background_button`.
- Navigation route: update `ROUTE_LIVE_RIDE` (Android) and the Flutter route map. Current value: `live_ride_screen`.
- App icon/branding: overlays use `R.mipmap.ic_launcher`.

### 1) android/app/src/main/AndroidManifest.xml

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC" />
    <application
        android:label="rapido_style"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- Specifies an Android theme to apply to this Activity as soon as
                 the Android process has started. This theme is visible to the user
                 while the Flutter UI initializes. After that, this theme continues
                 to determine the Window background behind the Flutter UI. -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <!-- Don't delete the meta-data below.
             This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />


        <service
            android:name=".RapidoBubbleOverlayService"
            android:exported="false"
            android:foregroundServiceType="dataSync" />

        <service
            android:name=".RapidoIncomingOrderOverlayService"
            android:exported="false"
            android:foregroundServiceType="dataSync" />
    </application>
    <!-- Required to query activities that can process text, see:
         https://developer.android.com/training/package-visibility and
         https://developer.android.com/reference/android/content/Intent#ACTION_PROCESS_TEXT.

         In particular, this is used by the Flutter engine in io.flutter.plugin.text.ProcessTextPlugin. -->
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>
```

---

### 2) android/app/src/main/kotlin/com/fc/rapido_style/MainActivity.kt

```kotlin
package com.fc.rapido_style

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import androidx.annotation.UiThread
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val channelName = "rapido_background_button"
	private val tag = "RapidoOverlay"
	private var channel: MethodChannel? = null
	private var isOnlineFromFlutter: Boolean = false

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
		channel = methodChannel
		methodChannel.setMethodCallHandler { call, result ->
				when (call.method) {
					"setOnline" -> {
						val online = (call.argument<Boolean>("online") ?: false)
						isOnlineFromFlutter = online
						result.success(null)
					}

					"scheduleIncomingOrderOverlay" -> {
						val delayMs = call.argument<Number>("delayMs")?.toLong()
							?: RapidoIncomingOrderOverlayService.DEFAULT_DELAY_MS

						val canDraw = Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(this)
						if (canDraw) {
							RapidoIncomingOrderOverlayService.schedule(this, delayMs)
						}
						result.success(canDraw)
					}

					"cancelIncomingOrderOverlay" -> {
						RapidoIncomingOrderOverlayService.start(this, RapidoIncomingOrderOverlayService.ACTION_HIDE)
						result.success(null)
					}

					"hasOverlayPermission" -> {
						val has = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
							Settings.canDrawOverlays(this)
						} else {
							true
						}
						result.success(has)
					}

					"getLaunchRoute" -> {
						val route = consumeRouteFromIntent(intent)
						result.success(route)
					}

					"requestPermissions" -> {
						// Android overlay permission cannot be granted via runtime popup.
						// We can only navigate user to the system settings page.
						if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
							val intent = Intent(
								Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
								Uri.parse("package:$packageName")
							)
							intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
							startActivity(intent)
						}
						result.success(null)
					}

					"showBackgroundButton" -> {
						val has = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
							Settings.canDrawOverlays(this)
						} else {
							true
						}
						if (has) {
							RapidoBubbleOverlayService.start(this, RapidoBubbleOverlayService.ACTION_SHOW)
						}
						result.success(has)
					}

					"hideBackgroundButton" -> {
						RapidoBubbleOverlayService.start(this, RapidoBubbleOverlayService.ACTION_HIDE)
						result.success(null)
					}

					else -> result.notImplemented()
				}
			}
	}

	@UiThread
	override fun onNewIntent(intent: Intent) {
		super.onNewIntent(intent)
		setIntent(intent)

		val route = consumeRouteFromIntent(intent) ?: return
		try {
			channel?.invokeMethod("navigateTo", route)
		} catch (t: Throwable) {
			Log.w(tag, "Failed to invoke navigateTo($route)", t)
		}
	}

	private fun consumeRouteFromIntent(intent: Intent?): String? {
		if (intent == null) return null
		val route = intent.getStringExtra(RapidoIncomingOrderOverlayService.EXTRA_NAV_ROUTE)
		if (route.isNullOrBlank()) return null
		// Avoid re-navigation on config changes.
		intent.removeExtra(RapidoIncomingOrderOverlayService.EXTRA_NAV_ROUTE)
		return route
	}

	override fun onPause() {
		super.onPause()

		Log.d(tag, "onPause: canDrawOverlays=${Settings.canDrawOverlays(this)}")

		// If overlay permission is missing, do nothing here.
		// Permission request should be user-driven (via in-app dialog -> requestPermissions).
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) return

		// Respect Flutter ONLINE/OFFLINE.
		if (!isOnlineFromFlutter) return

		// App is going to background: show the bubble.
		Log.d(tag, "Starting overlay service: SHOW")
		RapidoBubbleOverlayService.start(this, RapidoBubbleOverlayService.ACTION_SHOW)
	}

	override fun onResume() {
		super.onResume()
		// App is in foreground: hide bubble.
		Log.d(tag, "onResume: Starting overlay service: HIDE")
		RapidoBubbleOverlayService.start(this, RapidoBubbleOverlayService.ACTION_HIDE)
		RapidoIncomingOrderOverlayService.start(this, RapidoIncomingOrderOverlayService.ACTION_HIDE)
	}
}
```

---

### 3) android/app/src/main/kotlin/com/fc/rapido_style/RapidoBubbleOverlayService.kt

```kotlin
package com.fc.rapido_style

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.graphics.Point
import android.graphics.PixelFormat
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.IBinder
import android.provider.Settings
import android.util.Log
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.ImageView
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

class RapidoBubbleOverlayService : Service() {
	private var windowManager: WindowManager? = null
	private var overlayView: View? = null
	private var layoutParams: WindowManager.LayoutParams? = null
	private val tag = "RapidoBubbleOverlay"

	override fun onBind(intent: Intent?): IBinder? = null

	override fun onCreate() {
		super.onCreate()
		windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
	}

	override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
		Log.d(tag, "onStartCommand action=${intent?.action}")
		when (intent?.action) {
			ACTION_SHOW -> show()
			ACTION_HIDE -> {
				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
					try {
						startForegroundCompat()
					} catch (_: Throwable) {
					}
				}
				hideAndStop()
			}
			else -> {}
		}
		return START_NOT_STICKY
	}

	override fun onDestroy() {
		removeOverlayIfPresent()
		super.onDestroy()
	}

	private fun show() {
		val canDraw = Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(this)
		if (!canDraw) {
			Log.d(tag, "show: missing overlay permission")
			hideAndStop()
			return
		}

		if (overlayView != null) return

		startForegroundCompat()

		val root = FrameLayout(this).apply {
			val size = dp(70)
			layoutParams = FrameLayout.LayoutParams(size, size)
			foregroundGravity = Gravity.CENTER
			isClickable = true
			isFocusable = false

			background = GradientDrawable().apply {
				shape = GradientDrawable.OVAL
				setColor(0xFFFFFFFF.toInt())
			}
			elevation = dp(6).toFloat()
		}

		val icon = ImageView(this).apply {
			setImageResource(R.mipmap.ic_launcher)
			layoutParams = FrameLayout.LayoutParams(dp(36), dp(36), Gravity.CENTER)
		}
		root.addView(icon)

		val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
			WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
		} else {
			@Suppress("DEPRECATION")
			WindowManager.LayoutParams.TYPE_PHONE
		}

		layoutParams = WindowManager.LayoutParams(
			dp(70),
			dp(70),
			type,
			WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
			PixelFormat.TRANSLUCENT
		).apply {
			gravity = Gravity.TOP or Gravity.START
			x = dp(12)
			y = getStatusBarHeightPx() + dp(120)
		}

		root.setOnTouchListener(DragToMoveTouchListener())
		root.setOnClickListener { openApp() }

		overlayView = root
		windowManager?.addView(overlayView, layoutParams)
		Log.d(tag, "show: overlay added")
	}

	private fun hideAndStop() {
		removeOverlayIfPresent()
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
			stopForeground(STOP_FOREGROUND_REMOVE)
		} else {
			@Suppress("DEPRECATION")
			stopForeground(true)
		}
		stopSelf()
	}

	private fun removeOverlayIfPresent() {
		val view = overlayView ?: return
		try {
			windowManager?.removeView(view)
		} catch (_: Throwable) {
		}
		overlayView = null
		layoutParams = null
	}

	private fun openApp() {
		val intent = Intent(this, MainActivity::class.java).apply {
			addFlags(
				Intent.FLAG_ACTIVITY_NEW_TASK or
					Intent.FLAG_ACTIVITY_CLEAR_TOP or
					Intent.FLAG_ACTIVITY_SINGLE_TOP
			)
		}
		startActivity(intent)
	}

	private fun buildNotification(): Notification {
		val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
			val channel = NotificationChannel(
				NOTIFICATION_CHANNEL_ID,
				"Background bubble",
				NotificationManager.IMPORTANCE_MIN
			)
			manager.createNotificationChannel(channel)
		}

		return NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
			.setSmallIcon(R.mipmap.ic_launcher)
			.setContentTitle("Rapido")
			.setContentText("Background bubble is active")
			.setPriority(NotificationCompat.PRIORITY_MIN)
			.setOngoing(true)
			.setCategory(NotificationCompat.CATEGORY_SERVICE)
			.build()
	}

	private fun startForegroundCompat() {
		val notification = buildNotification()
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
			startForeground(
				NOTIFICATION_ID,
				notification,
				ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
			)
		} else {
			@Suppress("DEPRECATION")
			startForeground(NOTIFICATION_ID, notification)
		}
	}

	private fun dp(value: Int): Int {
		return (value * resources.displayMetrics.density).toInt()
	}

	private fun getStatusBarHeightPx(): Int {
		val resId = resources.getIdentifier("status_bar_height", "dimen", "android")
		return if (resId > 0) resources.getDimensionPixelSize(resId) else 0
	}

	private fun getScreenSizePx(): Pair<Int, Int> {
		val wm = windowManager ?: return Pair(0, 0)
		return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
			val bounds = wm.currentWindowMetrics.bounds
			Pair(bounds.width(), bounds.height())
		} else {
			@Suppress("DEPRECATION")
			val display = wm.defaultDisplay
			val point = Point()
			@Suppress("DEPRECATION")
			display.getRealSize(point)
			Pair(point.x, point.y)
		}
	}

	private inner class DragToMoveTouchListener : View.OnTouchListener {
		private var initialX = 0
		private var initialY = 0
		private var initialTouchX = 0f
		private var initialTouchY = 0f
		private var isDragging = false

		override fun onTouch(v: View, event: MotionEvent): Boolean {
			val params = layoutParams ?: return false

			when (event.action) {
				MotionEvent.ACTION_DOWN -> {
					initialX = params.x
					initialY = params.y
					initialTouchX = event.rawX
					initialTouchY = event.rawY
					isDragging = false
					return true
				}

				MotionEvent.ACTION_MOVE -> {
					val dx = (event.rawX - initialTouchX).toInt()
					val dy = (event.rawY - initialTouchY).toInt()
					if (kotlin.math.abs(dx) > dp(3) || kotlin.math.abs(dy) > dp(3)) {
						isDragging = true
					}

					val (screenW, screenH) = getScreenSizePx()
					val viewW = params.width
					val viewH = params.height
					val margin = dp(4)

					val minX = margin
					val minY = margin
					val maxX = (screenW - viewW - margin).coerceAtLeast(minX)
					val maxY = (screenH - viewH - margin).coerceAtLeast(minY)

					params.x = (initialX + dx).coerceIn(minX, maxX)
					params.y = (initialY + dy).coerceIn(minY, maxY)
					windowManager?.updateViewLayout(overlayView, params)
					return true
				}

				MotionEvent.ACTION_UP -> {
					if (!isDragging) v.performClick()
					return true
				}
			}

			return false
		}
	}

	companion object {
		const val ACTION_SHOW = "com.fc.rapido_style.action.SHOW_BUBBLE_OVERLAY"
		const val ACTION_HIDE = "com.fc.rapido_style.action.HIDE_BUBBLE_OVERLAY"

		private const val NOTIFICATION_CHANNEL_ID = "rapido_bubble_overlay"
		private const val NOTIFICATION_ID = 9101

		fun start(context: Context, action: String) {
			val intent = Intent(context, RapidoBubbleOverlayService::class.java).apply {
				this.action = action
			}

			if (action == ACTION_SHOW && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
				ContextCompat.startForegroundService(context, intent)
			} else {
				context.startService(intent)
			}
		}
	}
}
```

---

### 4) android/app/src/main/kotlin/com/fc/rapido_style/RapidoIncomingOrderOverlayService.kt

```kotlin
package com.fc.rapido_style

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.graphics.Point
import android.graphics.PixelFormat
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
import android.widget.Button
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

class RapidoIncomingOrderOverlayService : Service() {
	private var windowManager: WindowManager? = null
	private var overlayView: View? = null
	private var layoutParams: WindowManager.LayoutParams? = null
	private val tag = "RapidoIncomingOrder"

	private var isMinimized: Boolean = false
	private val mainHandler = Handler(Looper.getMainLooper())
	private var scheduledShow: Runnable? = null

	override fun onBind(intent: Intent?): IBinder? = null

	override fun onCreate() {
		super.onCreate()
		windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
	}

	override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
		Log.d(tag, "onStartCommand action=${intent?.action}")
		when (intent?.action) {
			ACTION_SCHEDULE_SHOW -> scheduleShow(intent.getLongExtra(EXTRA_DELAY_MS, DEFAULT_DELAY_MS))
			ACTION_SHOW_NOW -> showNow()
			ACTION_HIDE -> {
				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
					try {
						startForegroundCompat()
					} catch (_: Throwable) {
					}
				}
				hideAndStop()
			}
			else -> {}
		}
		return START_NOT_STICKY
	}

	override fun onDestroy() {
		cancelScheduledShow()
		removeOverlayIfPresent()
		super.onDestroy()
	}

	private fun scheduleShow(delayMs: Long) {
		val canDraw = Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(this)
		if (!canDraw) {
			Log.d(tag, "scheduleShow: missing overlay permission")
			hideAndStop()
			return
		}

		startForegroundCompat()
		cancelScheduledShow()

		val runnable = Runnable {
			showNow()
		}
		scheduledShow = runnable
		mainHandler.postDelayed(runnable, delayMs.coerceAtLeast(0))
		Log.d(tag, "scheduleShow: scheduled in ${delayMs}ms")
	}

	private fun cancelScheduledShow() {
		val r = scheduledShow ?: return
		mainHandler.removeCallbacks(r)
		scheduledShow = null
	}

	private fun showNow() {
		cancelScheduledShow()

		val canDraw = Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.canDrawOverlays(this)
		if (!canDraw) {
			Log.d(tag, "showNow: missing overlay permission")
			hideAndStop()
			return
		}

		if (overlayView != null) {
			Log.d(tag, "showNow: overlay already visible")
			return
		}

		// Ensure bubble overlay is not stacked under this card.
		RapidoBubbleOverlayService.start(this, RapidoBubbleOverlayService.ACTION_HIDE)

		startForegroundCompat()

		val root = FrameLayout(this).apply {
			isClickable = false
			isFocusable = false
		}

		val expandedCard = buildExpandedCardView(
			onAccept = {
				openAppWithRoute(ROUTE_LIVE_RIDE)
				hideAndStop()
			},
			onMinimize = { setMinimized(true) }
		)

		val bubble = buildBubbleView(
			onClick = {
				openApp()
				hideAndStop()
			}
		)

		root.addView(expandedCard)
		root.addView(bubble)

		val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
			WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
		} else {
			@Suppress("DEPRECATION")
			WindowManager.LayoutParams.TYPE_PHONE
		}

		val (screenW, _) = getScreenSizePx()
		val topInset = getStatusBarHeightPx()
		layoutParams = WindowManager.LayoutParams(
			screenW.coerceAtLeast(WindowManager.LayoutParams.WRAP_CONTENT),
			WindowManager.LayoutParams.WRAP_CONTENT,
			type,
			WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
			PixelFormat.TRANSLUCENT
		).apply {
			gravity = Gravity.TOP or Gravity.START
			x = 0
			y = topInset + dp(8)
		}

		overlayView = root
		windowManager?.addView(overlayView, layoutParams)
		Log.d(tag, "showNow: overlay added")

		isMinimized = false
		expandedCard.visibility = View.VISIBLE
		bubble.visibility = View.GONE
	}

	private fun setMinimized(minimized: Boolean) {
		val root = overlayView as? FrameLayout ?: return
		if (isMinimized == minimized) return
		isMinimized = minimized

		val expandedCard = root.getChildAt(0)
		val bubble = root.getChildAt(1)
		expandedCard.visibility = if (minimized) View.GONE else View.VISIBLE
		bubble.visibility = if (minimized) View.VISIBLE else View.GONE

		val params = layoutParams ?: return
		if (minimized) {
			params.width = dp(70)
			params.height = dp(70)
			params.x = dp(12)
		} else {
			val (screenW, _) = getScreenSizePx()
			params.width = screenW.coerceAtLeast(WindowManager.LayoutParams.WRAP_CONTENT)
			params.height = WindowManager.LayoutParams.WRAP_CONTENT
			params.x = 0
		}
		try {
			windowManager?.updateViewLayout(overlayView, params)
		} catch (_: Throwable) {
		}
	}

	private fun buildExpandedCardView(
		onAccept: () -> Unit,
		onMinimize: () -> Unit
	): View {
		val card = LinearLayout(this).apply {
			orientation = LinearLayout.VERTICAL
			// Do not open the app when user taps the card background.
			isClickable = false
			isFocusable = false

			val marginH = dp(12)
			setPadding(dp(12), dp(12), dp(12), dp(12))
			layoutParams = FrameLayout.LayoutParams(
				FrameLayout.LayoutParams.MATCH_PARENT,
				FrameLayout.LayoutParams.WRAP_CONTENT
			).apply {
				leftMargin = marginH
				rightMargin = marginH
			}

			background = GradientDrawable().apply {
				shape = GradientDrawable.RECTANGLE
				cornerRadius = dp(16).toFloat()
				setColor(0xFFFFFFFF.toInt())
			}
			elevation = dp(8).toFloat()
		}

		val header = LinearLayout(this).apply {
			orientation = LinearLayout.HORIZONTAL
			gravity = Gravity.CENTER_VERTICAL
		}
		val icon = ImageView(this).apply {
			setImageResource(R.mipmap.ic_launcher)
			layoutParams = LinearLayout.LayoutParams(dp(22), dp(22)).apply {
				rightMargin = dp(8)
			}
		}
		val title = TextView(this).apply {
			text = "Bike"
			setTextColor(0xFF111111.toInt())
			textSize = 16f
		}
		header.addView(icon)
		header.addView(title)
		card.addView(header)

		card.addView(spacer(dp(10)))
		card.addView(buildTwoLineBlock("0.7 Km", "Pickup address"))
		card.addView(spacer(dp(10)))
		card.addView(buildTwoLineBlock("6.5 Km", "Drop address"))

		card.addView(spacer(dp(14)))

		val bottom = LinearLayout(this).apply {
			orientation = LinearLayout.HORIZONTAL
			gravity = Gravity.CENTER_VERTICAL
		}

		val minimize = Button(this).apply {
			text = "-"
			isAllCaps = false
			setOnClickListener { onMinimize() }
			layoutParams = LinearLayout.LayoutParams(dp(52), dp(52)).apply {
				rightMargin = dp(12)
			}
			background = GradientDrawable().apply {
				shape = GradientDrawable.OVAL
				setColor(0xFFEDEFF2.toInt())
			}
		}

		val accept = Button(this).apply {
			text = "Accept"
			isAllCaps = false
			setTextColor(0xFF111111.toInt())
			textSize = 18f
			setOnClickListener { onAccept() }
			layoutParams = LinearLayout.LayoutParams(0, dp(52), 1f)
			background = GradientDrawable().apply {
				shape = GradientDrawable.RECTANGLE
				cornerRadius = dp(26).toFloat()
				setColor(0xFFFFD54F.toInt())
			}
		}

		bottom.addView(minimize)
		bottom.addView(accept)
		card.addView(bottom)

		return card
	}

	private fun buildTwoLineBlock(distance: String, address: String): View {
		val box = LinearLayout(this).apply {
			orientation = LinearLayout.VERTICAL
		}
		val distanceTv = TextView(this).apply {
			text = distance
			setTextColor(0xFF111111.toInt())
			textSize = 28f
		}
		val addressTv = TextView(this).apply {
			text = address
			setTextColor(0xFF111111.toInt())
			textSize = 16f
		}
		box.addView(distanceTv)
		box.addView(addressTv)
		return box
	}

	private fun spacer(heightPx: Int): View {
		return View(this).apply {
			layoutParams = LinearLayout.LayoutParams(
				LinearLayout.LayoutParams.MATCH_PARENT,
				heightPx
			)
		}
	}

	private fun buildBubbleView(onClick: () -> Unit): View {
		val bubble = FrameLayout(this).apply {
			val size = dp(70)
			layoutParams = FrameLayout.LayoutParams(size, size)
			foregroundGravity = Gravity.CENTER
			isClickable = true
			isFocusable = false

			background = GradientDrawable().apply {
				shape = GradientDrawable.OVAL
				setColor(0xFFFFFFFF.toInt())
			}
			elevation = dp(6).toFloat()
		}

		val icon = ImageView(this).apply {
			setImageResource(R.mipmap.ic_launcher)
			layoutParams = FrameLayout.LayoutParams(dp(36), dp(36), Gravity.CENTER)
		}
		bubble.addView(icon)

		bubble.setOnTouchListener(DragToMoveTouchListener())
		bubble.setOnClickListener { onClick() }
		return bubble
	}

	private fun hideAndStop() {
		cancelScheduledShow()
		removeOverlayIfPresent()
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
			stopForeground(STOP_FOREGROUND_REMOVE)
		} else {
			@Suppress("DEPRECATION")
			stopForeground(true)
		}
		stopSelf()
	}

	private fun removeOverlayIfPresent() {
		val view = overlayView ?: return
		try {
			windowManager?.removeView(view)
		} catch (_: Throwable) {
		}
		overlayView = null
		layoutParams = null
	}

	private fun openApp() {
		val intent = Intent(this, MainActivity::class.java).apply {
			addFlags(
				Intent.FLAG_ACTIVITY_NEW_TASK or
					Intent.FLAG_ACTIVITY_CLEAR_TOP or
					Intent.FLAG_ACTIVITY_SINGLE_TOP
			)
		}
		startActivity(intent)
	}

	private fun openAppWithRoute(routeName: String) {
		val intent = Intent(this, MainActivity::class.java).apply {
			addFlags(
				Intent.FLAG_ACTIVITY_NEW_TASK or
					Intent.FLAG_ACTIVITY_CLEAR_TOP or
					Intent.FLAG_ACTIVITY_SINGLE_TOP
			)
			putExtra(EXTRA_NAV_ROUTE, routeName)
		}
		startActivity(intent)
	}

	private fun buildNotification(): Notification {
		val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
			val channel = NotificationChannel(
				NOTIFICATION_CHANNEL_ID,
				"Incoming order overlay",
				NotificationManager.IMPORTANCE_MIN
			)
			manager.createNotificationChannel(channel)
		}

		return NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
			.setSmallIcon(R.mipmap.ic_launcher)
			.setContentTitle("Rapido")
			.setContentText("Incoming order overlay active")
			.setPriority(NotificationCompat.PRIORITY_MIN)
			.setOngoing(true)
			.setCategory(NotificationCompat.CATEGORY_SERVICE)
			.build()
	}

	private fun startForegroundCompat() {
		val notification = buildNotification()
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
			startForeground(
				NOTIFICATION_ID,
				notification,
				ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
			)
		} else {
			@Suppress("DEPRECATION")
			startForeground(NOTIFICATION_ID, notification)
		}
	}

	private fun dp(value: Int): Int {
		return (value * resources.displayMetrics.density).toInt()
	}

	private fun getStatusBarHeightPx(): Int {
		val resId = resources.getIdentifier("status_bar_height", "dimen", "android")
		return if (resId > 0) resources.getDimensionPixelSize(resId) else 0
	}

	private fun getScreenSizePx(): Pair<Int, Int> {
		val wm = windowManager ?: return Pair(0, 0)
		return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
			val bounds = wm.currentWindowMetrics.bounds
			Pair(bounds.width(), bounds.height())
		} else {
			@Suppress("DEPRECATION")
			val display = wm.defaultDisplay
			val point = Point()
			@Suppress("DEPRECATION")
			display.getRealSize(point)
			Pair(point.x, point.y)
		}
	}

	private inner class DragToMoveTouchListener : View.OnTouchListener {
		private var initialX = 0
		private var initialY = 0
		private var initialTouchX = 0f
		private var initialTouchY = 0f
		private var isDragging = false

		override fun onTouch(v: View, event: MotionEvent): Boolean {
			val params = layoutParams ?: return false
			if (!isMinimized) return false

			when (event.action) {
				MotionEvent.ACTION_DOWN -> {
					initialX = params.x
					initialY = params.y
					initialTouchX = event.rawX
					initialTouchY = event.rawY
					isDragging = false
					return true
				}

				MotionEvent.ACTION_MOVE -> {
					val dx = (event.rawX - initialTouchX).toInt()
					val dy = (event.rawY - initialTouchY).toInt()
					if (kotlin.math.abs(dx) > dp(3) || kotlin.math.abs(dy) > dp(3)) {
						isDragging = true
					}

					val (screenW, screenH) = getScreenSizePx()
					val viewW = params.width
					val viewH = params.height
					val margin = dp(4)

					val minX = margin
					val minY = margin
					val maxX = (screenW - viewW - margin).coerceAtLeast(minX)
					val maxY = (screenH - viewH - margin).coerceAtLeast(minY)

					params.x = (initialX + dx).coerceIn(minX, maxX)
					params.y = (initialY + dy).coerceIn(minY, maxY)
					windowManager?.updateViewLayout(overlayView, params)
					return true
				}

				MotionEvent.ACTION_UP -> {
					if (!isDragging) v.performClick()
					return true
				}
			}

			return false
		}
	}

	companion object {
		const val ACTION_SCHEDULE_SHOW = "com.fc.rapido_style.action.SCHEDULE_INCOMING_ORDER_OVERLAY"
		const val ACTION_SHOW_NOW = "com.fc.rapido_style.action.SHOW_INCOMING_ORDER_OVERLAY"
		const val ACTION_HIDE = "com.fc.rapido_style.action.HIDE_INCOMING_ORDER_OVERLAY"

		const val EXTRA_NAV_ROUTE = "com.fc.rapido_style.extra.NAV_ROUTE"
		const val EXTRA_DELAY_MS = "com.fc.rapido_style.extra.DELAY_MS"

		const val ROUTE_LIVE_RIDE = "live_ride_screen"
		const val DEFAULT_DELAY_MS = 60_000L

		private const val NOTIFICATION_CHANNEL_ID = "rapido_incoming_order_overlay"
		private const val NOTIFICATION_ID = 9201

		fun schedule(context: Context, delayMs: Long = DEFAULT_DELAY_MS) {
			val intent = Intent(context, RapidoIncomingOrderOverlayService::class.java).apply {
				action = ACTION_SCHEDULE_SHOW
				putExtra(EXTRA_DELAY_MS, delayMs)
			}

			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
				ContextCompat.startForegroundService(context, intent)
			} else {
				context.startService(intent)
			}
		}

		fun start(context: Context, action: String) {
			val intent = Intent(context, RapidoIncomingOrderOverlayService::class.java).apply {
				this.action = action
			}

			if ((action == ACTION_SCHEDULE_SHOW || action == ACTION_SHOW_NOW) && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
				ContextCompat.startForegroundService(context, intent)
			} else {
				context.startService(intent)
			}
		}
	}
}
```

---

### 5) lib/main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static const _channel = MethodChannel('rapido_background_button');
  bool _isOnline = false;
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'navigateTo') {
        final route = call.arguments as String?;
        if (route == null || route.isEmpty) return;
        _navKey.currentState?.pushNamed(route);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryHandleLaunchRoute();
    });
  }

  Future<void> _tryHandleLaunchRoute() async {
    try {
      final String? route =
          await _channel.invokeMethod<String>('getLaunchRoute');
      if (route != null && route.isNotEmpty) {
        _navKey.currentState?.pushNamed(route);
      }
    } catch (_) {
      // Ignore if not supported on platform.
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Show the native “background button” only when:
    // 1) the app is backgrounded AND
    // 2) user is ONLINE
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      if (_isOnline) {
        _safeInvoke('showBackgroundButton');

        // Incoming order overlay: show after 1 minute in background.
        _safeInvokeIncomingOrderSchedule();
      } else {
        _safeInvoke('hideBackgroundButton');
        _safeInvoke('cancelIncomingOrderOverlay');
      }
    } else if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive) {
      _safeInvoke('hideBackgroundButton');
      _safeInvoke('cancelIncomingOrderOverlay');
    }
  }

  Future<void> _safeInvokeIncomingOrderSchedule() async {
    try {
      await _channel.invokeMethod<bool>(
        'scheduleIncomingOrderOverlay',
        {'delayMs': 60000},
      );
    } catch (_) {
      // Ignore on unsupported platforms.
    }
  }

  Future<void> _safeInvoke(String method) async {
    try {
      await _channel.invokeMethod<void>(method);
    } catch (_) {
      // Keep quiet in release; but don't crash debug either.
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rapido Style',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      navigatorKey: _navKey,
      routes: {
        '/': (_) => MyHomePage(
              isOnline: _isOnline,
              onOnlineChanged: (value) {
                setState(() {
                  _isOnline = value;
                });

                // Let Android native lifecycle respect ONLINE/OFFLINE.
                try {
                  _channel.invokeMethod<void>('setOnline', {'online': value});
                } catch (_) {}

                // If user turns OFFLINE while the overlay service is running
                // (e.g. after returning to the app), explicitly hide it.
                if (!value) {
                  _safeInvoke('hideBackgroundButton');
                }
              },
            ),
        'live_ride_screen': (_) => const LiveRideScreen(),
      },
    );
  }
}

class LiveRideScreen extends StatelessWidget {
  const LiveRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Ride')),
      body: const Center(
        child: Text('live_ride_screen'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.isOnline, required this.onOnlineChanged});

  final bool isOnline;
  final ValueChanged<bool> onOnlineChanged;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  static const _channel = MethodChannel('rapido_background_button');

  bool _pendingEnableOnline = false;
  bool _dialogShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _pendingEnableOnline) {
      _finishPendingOnlineEnable();
    }
  }

  Future<bool> _hasOverlayPermission() async {
    try {
      final bool? platformValue =
          await _channel.invokeMethod<bool>('hasOverlayPermission');
      return platformValue ?? true;
    } catch (_) {
      // If platform doesn't support it, don't block UI.
      return true;
    }
  }

  Future<void> _showOverlayPermissionRequiredDialog() async {
    if (_dialogShowing || !mounted) return;
    _dialogShowing = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('Overlay permission required'),
            content: const Text(
              'To go ONLINE and show the floating button in background, enable "Display over other apps" for this app.',
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('latter'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _pendingEnableOnline = true;
                  _channel.invokeMethod<void>('requestPermissions');
                },
                child: const Text('Allow'),
              ),
            ],
          ),
        );
      },
    );

    _dialogShowing = false;
  }

  Future<void> _attemptGoOnline() async {
    final hasPermission = await _hasOverlayPermission();
    if (!mounted) return;

    if (hasPermission) {
      widget.onOnlineChanged(true);
      return;
    }

    await _showOverlayPermissionRequiredDialog();
  }

  Future<void> _finishPendingOnlineEnable() async {
    final hasPermission = await _hasOverlayPermission();
    if (!mounted) return;

    if (hasPermission) {
      _pendingEnableOnline = false;
      widget.onOnlineChanged(true);
    } else {
      await _showOverlayPermissionRequiredDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rapido Style"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// 🔥 Toggle Button
            GestureDetector(
              onTap: () async {
                if (widget.isOnline) {
                  widget.onOnlineChanged(false);
                  _channel.invokeMethod<void>('hideBackgroundButton');
                } else {
                  await _attemptGoOnline();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 120,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: widget.isOnline ? Colors.green : Colors.grey,
                ),
                child: Stack(
                  children: [

                    /// Text
                    Align(
                      alignment: widget.isOnline
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          widget.isOnline ? "ONLINE" : "OFFLINE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    /// Circle Button
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      alignment: widget.isOnline
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Status Text
            Text(
              widget.isOnline ? "You are Online" : "You are Offline",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
```

