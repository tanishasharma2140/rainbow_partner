import 'package:url_launcher/url_launcher.dart';

class CallUtils {
  static Future<void> makePhoneCall(String number) async {
    if (number.isEmpty) return;

    final Uri uri = Uri.parse("tel:$number");

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception("Could not launch call");
    }
  }
}
