import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:rainbow_partner/service/driver_socket_service.dart';
import 'package:rainbow_partner/service/ride_notification_helper.dart';
import 'package:rainbow_partner/service/ringtone_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'socket_service.dart';

/// 🔥 TOP-LEVEL FUNCTION (MANDATORY)
@pragma('vm:entry-point')
void backgroundServiceOnStart(ServiceInstance service) async {
  /// VERY IMPORTANT
  await RideNotificationHelper.init();

  /// 🔥 Listen commands from main isolate
  service.on('STOP_RINGTONE').listen((event) {
    RingtoneHelper().stop();
  });

  service.on('START_RINGTONE').listen((event) {
    if (!RingtoneHelper().isPlaying) {
      RingtoneHelper().start();
    }
  });

  /// 🔥 Fetch driverId dynamically
  final prefs = await SharedPreferences.getInstance();

// 👇 String read karo
  final String? token = prefs.getString('token');

  if (token == null) {
    print('❌ Driver ID not found, stopping service');
    return;
  }

// 👇 Convert to int
  final int driverId = int.tryParse(token) ?? 0;

  if (driverId == 0) {
    print('❌ Invalid Driver ID');
    return;
  }

  /// 🔥 Socket connection
  DriverSocketService().connect(
    baseUrl: "https://admin.rainbowsenterprises.com",
    driverId: driverId,

    onSyncRides: (rides) {
      if (rides.isNotEmpty) {
        RingtoneHelper().start();
        RideNotificationHelper.showIncomingRide(rides.first);
      } else {
        RingtoneHelper().stop();
        RideNotificationHelper.clear(fromBackground: true);
      }
    },

    onNewRide: () {
      if (!RingtoneHelper().isPlaying) {
        RingtoneHelper().start();
      }
    },

    onEmptyRide: () {
      RingtoneHelper().stop();
      RideNotificationHelper.clear(fromBackground: true);
    },

  );
}

/// 🔥 Service initializer
void initializeBackgroundService() {
  final service = FlutterBackgroundService();

  service.configure(
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      isForegroundMode: true,
      onStart: backgroundServiceOnStart,

      notificationChannelId: 'SERVICE_CHANNEL',
      initialNotificationTitle: 'Rainbow Driver Online',
      initialNotificationContent: 'Waiting for rides',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: backgroundServiceOnStart,
    ),
  );

  service.startService();
}
