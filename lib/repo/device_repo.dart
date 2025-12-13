import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceRepo {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<String> getDeviceId() async {
    try {
      // ANDROID
      final android = await deviceInfo.androidInfo;
      return android.id; // Unique Android Device ID
    } catch (e) {
      debugPrint("Device ID Error → $e");
      return "";
    }
  }
}
