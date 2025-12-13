import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/auth/otp_screen.dart';
import 'package:rainbow_partner/repo/serviceman/serviceman_register_repo.dart';
import 'package:rainbow_partner/utils/routes/routes_name.dart';
import 'package:rainbow_partner/utils/utils.dart';

class ServicemanRegisterViewModel with ChangeNotifier {
  final ServicemanRegisterRepo _servicemanRegisterRepo = ServicemanRegisterRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> servicemanRegisterApi({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String address,
    required String serviceCategory,
    required String deviceId,
    required String fcmTokenI,
    required String skillStatus,
    required String currentLatitude,
    required String currentLongitude,
    required String gender,
    required File aadhaarFront,
    required File aadhaarBack,
     File? experienceCertificate,
    required File profilePhoto,
    required BuildContext context,
  }) async {

    setLoading(true);

    // -------------------- TEXT FIELDS --------------------
    Map<String, String> fields = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "mobile": mobile,
      "address": address,
      "service_category": serviceCategory,
      "device_id": deviceId,
      "fcm_token": fcmTokenI,
      "skill_status": skillStatus,
      "current_latitude": currentLatitude,
      "current_longitude": currentLongitude,
      "gender": gender
    };

    // -------------------- FILE FIELDS --------------------
    Map<String, dynamic> files = {
      "aadhaar_front": aadhaarFront,
      "aadhaar_back": aadhaarBack,
      "profile_photo" : profilePhoto
    };

    files["experience_certificate"] = experienceCertificate;

    // -------------------- DEBUG PRINT --------------------
    print("=================== 📤 SERVICEMAN REGISTER DEBUG ===================");

    print("\n📌 TEXT FIELDS:");
    fields.forEach((key, value) => print("  $key : $value"));

    print("\n📌 FILES:");
    print("  aadhaar_front → ${aadhaarFront.path}");
    print("  aadhaar_back → ${aadhaarBack.path}");
    print("  profile_photo → ${profilePhoto.path}");

    if (experienceCertificate != null) {
      print("  experience_certificate → ${experienceCertificate!.path}");
    } else {
      print("  experience_certificate → NULL (No Skill Selected)");
    }

    print("===========================================================\n");

    try {
      final response = await _servicemanRegisterRepo.serviceManRegisterApi(fields, files);

      final int statusCode = response["statusCode"] ?? 0;
      final Map<String, dynamic> body = response["body"] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(context, body["message"] ?? "Submitted successfully");
        Navigator.pushNamed(context, RoutesName.otpScreen,arguments: {"mobileNumber": mobile,"userId":body["serviceman_id"].toString(),});
      } else {
        Utils.showErrorMessage(context, body["message"] ?? "Something went wrong!");
      }

    } catch (e) {
      if (kDebugMode) print("❌ Serviceman Register ERROR → $e");
      Utils.showErrorMessage(context, "Request failed!");
    } finally {
      setLoading(false);
    }
  }
}
