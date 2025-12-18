import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  static Future<void> openGoogleMapDirections({
    required double destLat,
    required double destLng,
  }) async {
    // 1️⃣ Preferred (Google Maps App)
    final Uri googleMapsAppUrl =
    Uri.parse("google.navigation:q=$destLat,$destLng");

    // 2️⃣ Fallback (Browser Google Maps)
    final Uri googleMapsWebUrl = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$destLat,$destLng&travelmode=driving",
    );

    try {
      if (Platform.isAndroid && await canLaunchUrl(googleMapsAppUrl)) {
        await launchUrl(
          googleMapsAppUrl,
          mode: LaunchMode.externalApplication,
        );
      } else if (await canLaunchUrl(googleMapsWebUrl)) {
        await launchUrl(
          googleMapsWebUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw "No map application available";
      }
    } catch (e) {
      print("MAP ERROR: $e");
    }
  }
}
