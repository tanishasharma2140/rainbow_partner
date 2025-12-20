import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_register_five_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/vehicle_document.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class DriverRegisterFiveViewModel with ChangeNotifier {
  final DriverRegisterFiveRepo _driverRegisterFiveRepo =
  DriverRegisterFiveRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> driverRegisterFiveApi({
    required File vehiclePhoto,
    required String vehicleInfoStatus,
    required dynamic brandId,
    required dynamic brandName,
    required dynamic modelId,
    required dynamic modelName,
    required dynamic vehicleColor,
    required dynamic vehiclePlateNumber,
    required dynamic vehicleProductionYear,
    required BuildContext context,
  }) async {
    setLoading(true);

    /// 🔹 GET USER ID
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();

    /// 🔥 DEBUG PRINTS
    if (kDebugMode) {
      print("🚗 DRIVER REGISTER STEP 5");
      print("🆔 User ID: $userId");
      print("Brand ID: $brandId | Brand Name: $brandName");
      print("Model ID: $modelId | Model Name: $modelName");
      print("Vehicle Color: $vehicleColor");
      print("Plate Number: $vehiclePlateNumber");
      print("Production Year: $vehicleProductionYear");
      print("Vehicle Photo Path: ${vehiclePhoto.path}");
    }

    Map<String, String> fields = {
      "vehicle_info_status": vehicleInfoStatus,
      "id": userId.toString(),
      "brand_id": brandId.toString(),
      "brand_name": brandName.toString(),
      "model_id": modelId.toString(),
      "model_name": modelName.toString(),
      "vehicle_color": vehicleColor.toString(),
      "vehicle_plate_number": vehiclePlateNumber.toString(),
      "vehicle_production_year": vehicleProductionYear.toString(),
    };

    Map<String, dynamic> files = {
      "vehicle_photo": vehiclePhoto,
    };

    if (kDebugMode) {
      print("📤 FIELDS SENT TO API:");
      fields.forEach((key, value) {
        print("$key : $value");
      });
    }

    try {
      final response =
      await _driverRegisterFiveRepo.driverRegisterFiveApi(fields, files);

      final int statusCode = response["statusCode"] ?? 0;
      final Map<String, dynamic> body = response["body"] ?? {};

      if (kDebugMode) {
        print("📥 API STATUS CODE: $statusCode");
        print("📦 API RESPONSE BODY: $body");
      }

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(
          context,
          body["message"] ?? "Submitted successfully",
        );

        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => const VehicleDocument()),
        );
      } else {
        Utils.showErrorMessage(
          context,
          body["message"] ?? "Something went wrong!",
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ DriverRegisterFive Error → $e");
      }
      Utils.showErrorMessage(context, "Request failed!");
    } finally {
      setLoading(false);
    }
  }
}
