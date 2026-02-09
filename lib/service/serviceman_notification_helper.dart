import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rainbow_partner/main.dart';

class ServicemanNotificationHelper {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static const int _notificationId = 1999;

  static final _actionController =
  StreamController<ServicemanNotificationAction>.broadcast();

  static Stream<ServicemanNotificationAction> get actionStream =>
      _actionController.stream;

  static Map<String, dynamic>? _currentOrder;

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    await _plugin.initialize(
      const InitializationSettings(android: android),

      /// 🔥 FOREGROUND
      onDidReceiveNotificationResponse: handleAction,

      /// 🔥 BACKGROUND / KILLED (THIS WAS MISSING ❌)
      onDidReceiveBackgroundNotificationResponse:
      servicemanNotificationBackgroundTap,
    );
  }

  /// 🔥 CENTRAL HANDLER (foreground + background)
  static void handleAction(NotificationResponse response) {
    if (response.payload == null) {
      debugPrint("❌ Service payload NULL");
      return;
    }

    final Map<String, dynamic> orderData =
    jsonDecode(response.payload!);

    debugPrint("🔥 SERVICE NOTIFICATION ACTION");
    debugPrint("👉 ACTION: ${response.actionId}");
    debugPrint("📦 DATA: $orderData");

    switch (response.actionId) {
      case 'ACCEPT_SERVICE':
        _actionController.add(
          ServicemanNotificationAction(
            type: ServiceActionType.accept,
            orderData: orderData,
          ),
        );
        break;

      case 'REJECT_SERVICE':
        _actionController.add(
          ServicemanNotificationAction(
            type: ServiceActionType.reject,
            orderData: orderData,
          ),
        );
        clear(fromBackground: true);
        break;
    }
  }

  static Future<void> showIncomingServiceOrder(
      Map<String, dynamic> orderData) async {
    _currentOrder = orderData;

    const androidDetails = AndroidNotificationDetails(
      'SERVICE_ORDER_CHANNEL',
      'Service Orders',
      channelDescription: 'Incoming service requests',
      importance: Importance.max,
      priority: Priority.high,
      category: AndroidNotificationCategory.call,
      fullScreenIntent: true,
      ongoing: true,
      autoCancel: false,
      visibility: NotificationVisibility.public,
      color: Color(0xFF4CAF50),
      colorized: true,

      actions: [
        AndroidNotificationAction(
          'REJECT_SERVICE',
          '❌ Reject',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'ACCEPT_SERVICE',
          '✅ View Job',
          showsUserInterface: true,
        ),
      ],
    );

    await _plugin.show(
      _notificationId,
      '🛠 New Service Request',
      'Service: ${orderData['service_name'] ?? "New Job"}',
      NotificationDetails(android: androidDetails),
      payload: jsonEncode(orderData),
    );
  }

  static Future<void> clear({bool fromBackground = false}) async {
    _currentOrder = null;

    if (!fromBackground) {
      FlutterBackgroundService().invoke('STOP_RINGTONE');
    }

    await _plugin.cancel(_notificationId);
  }

  static void dispose() {
    _actionController.close();
  }
}

/// 🔥 Action types
enum ServiceActionType { accept, reject }

/// 🔥 Action model
class ServicemanNotificationAction {
  final ServiceActionType type;
  final Map<String, dynamic> orderData;

  ServicemanNotificationAction({
    required this.type,
    required this.orderData,
  });
}
