import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_register_one_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/driving_license.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class DriverRegisterOneViewModel with ChangeNotifier {
  final DriverRegisterOneRepo _driverRegisterOneRepo = DriverRegisterOneRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> driverRegisterOneApi({
    required File profilePhoto,
    required String personalInfoStatus,
    required String mobile,
    required String firstName,
    required String platformType,
    required String vehicleType,
    required String vehicleName,
    required String lastName,
    required String dob,
    required String deviceId,
    required String fcm,
    required BuildContext context,
  }) async {
    setLoading(true);


    Map<String, String> fields = {
      "personal_information_status": personalInfoStatus,
      "mobile": mobile,
      "first_name": firstName,
      "last_name": lastName,
      "date_of_birth": dob,
      "platform_type": platformType,
      "vehicle_type": vehicleType,
      "vehicle_name": vehicleName,
      "id": "",      // ✅ safer
      "device_id": "kmjnhbg",
      "fcm_token": "kjhgjnh",
    };

    Map<String, dynamic> files = {
      "profile_photo": profilePhoto,
    };

    try {
      final response =
      await _driverRegisterOneRepo.driverRegisterOneApi(fields, files);

      final int statusCode = response["statusCode"] ?? 0;
      final Map<String, dynamic> body = response["body"] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final String userId = body["id"].toString();

        // Save userId locally
        final userVm = UserViewModel();
        int role = await userVm.getRole() ?? 0;
        await userVm.saveUser(userId.toString(),role);
        Utils.showSuccessMessage(
          context,
          body["message"] ?? "Submitted successfully",
        );
        Navigator.push(context, CupertinoPageRoute(builder: (context)=> DrivingLicense()));
      } else {
        Utils.showErrorMessage(
          context,
          body["message"] ?? "Something went wrong!",
        );
      }
    } catch (e) {
      if (kDebugMode) print("❌ ViewModel Error → $e");
      Utils.showErrorMessage(context, "Request failed!");
    } finally {
      setLoading(false);
    }
  }
}
