import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetChecker {

  /// CHECK INTERNET NOW
  static Future<bool> hasInternet() async {
    try {
      // Check device connectivity (WiFi/Mobile/Data)
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        return false;
      }

      /// Final Internet check using a real server
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  /// LIVE INTERNET STATUS LISTENER STREAM
  static Stream<bool> get internetStream async* {
    yield await hasInternet();

    yield* Connectivity().onConnectivityChanged.asyncMap((_) async {
      return await hasInternet();
    });
  }
}
