import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:rainbow_partner/service/driver_socket_service.dart';
import 'package:rainbow_partner/service/ride_notification_helper.dart';
import 'package:rainbow_partner/service/ringtone_helper.dart';
import 'package:rainbow_partner/service/serviceman_notification_helper.dart';
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

@pragma('vm:entry-point')
void servicemanBackgroundOnStart(ServiceInstance service) async {
  print("🚀🚀🚀 Serviceman BACKGROUND SERVICE STARTED");

  await ServicemanNotificationHelper.init();
  print("✅ ServicemanNotificationHelper initialized");

  service.on('STOP_RINGTONE').listen((_) {
    print("🛑 BG: STOP_RINGTONE received");
    RingtoneHelper().stop();
  });

  final prefs = await SharedPreferences.getInstance();
  final int servicemanId =
      int.tryParse(prefs.getString('serviceman_id') ?? '') ?? 0;

  print("🆔 BG: servicemanId from prefs = $servicemanId");

  if (servicemanId == 0) {
    print("❌ BG: Serviceman ID missing → stopping service");
    service.stopSelf();
    return;
  }

  ServicemanSocketService().connect(
    baseUrl: "https://admin.rainbowsenterprises.com",
    servicemanId: servicemanId,

    onNewOrder: (orderData) async {
      print("🎯 BG CALLBACK: onNewOrder");
      print("📦 BG ORDER DATA = $orderData");

      if (!RingtoneHelper().isPlaying) {
        print("🔊 BG: Starting ringtone");
        RingtoneHelper().start();
      }

      print("📢 BG: Showing ServicemanNotification");
      await ServicemanNotificationHelper
          .showIncomingServiceOrder(orderData);
    },

    onOrderRemoved: () async {
      print("🗑 BG CALLBACK: onOrderRemoved");
      RingtoneHelper().stop();
      await ServicemanNotificationHelper.clear(fromBackground: true);
    },
  );

  service.on("stopService").listen((event) {
    print("🛑 BG: stopService received");

    // 🔌 Disconnect socket
    ServicemanSocketService().disconnect();

    // 🔕 Stop ringtone
    RingtoneHelper().stop();

    service.stopSelf();
  });

}





Future<void> stopBackgroundService() async {
  final service = FlutterBackgroundService();

  final isRunning = await service.isRunning();
  if (!isRunning) {
    debugPrint("⚪ Background service already stopped");
    return;
  }

  debugPrint("🛑 Sending stopService command");

  // 🔥 send command to background isolate
  service.invoke("stopService");
}

Future<void> stopServicemanBackgroundService() async {
  final service = FlutterBackgroundService();

  if (!await service.isRunning()) return;

  service.invoke("STOP_RINGTONE");
  service.invoke("stopService"); // 🔥 this triggers disconnect now
}





/// 🔥 Service initializer
void initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  final isRunning = await service.isRunning();
  if (isRunning) {
    debugPrint("🟢 Background service already running");
    return;
  }



  await service.configure(
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      isForegroundMode: true,
      onStart: backgroundServiceOnStart,

      notificationChannelId: 'SERVICE_CHANNEL',
      // initialNotificationTitle: 'Rainbow Driver Online',
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

Future<void> startServicemanBackgroundService() async {
  final service = FlutterBackgroundService();

  if (await service.isRunning()) {
    debugPrint("🟢 BG service already running");
    return;
  }

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      isForegroundMode: true,
      onStart: servicemanBackgroundOnStart,
      notificationChannelId: 'SERVICE_CHANNEL',
      initialNotificationTitle: 'Service Online',
      initialNotificationContent: 'Waiting for service requests',
      foregroundServiceNotificationId: 777,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: servicemanBackgroundOnStart,
    ),
  );

  service.startService();
}



