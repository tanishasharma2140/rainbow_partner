import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_register_six_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/popper_screen.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/vehicle_document.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class DriverRegisterSixViewModel with ChangeNotifier {
  final DriverRegisterSixRepo _driverRegisterSixRepo = DriverRegisterSixRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> driverRegisterSixApi({
    required File vehiclePermitA,
    required File vehiclePermitB,
    required File vehicleRegistrationFront,
    required File vehicleRegistrationBack,
    required String vehicleInfoStatus,
    required BuildContext context,
  }) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();

    Map<String, String> fields = {
      "vehicle_documents_status": vehicleInfoStatus,
      "id": userId.toString(),
    };

    Map<String, dynamic> files = {
      "vehicle_permit_part_a": vehiclePermitA,
      "vehicle_permit_part_b": vehiclePermitB,
      "vehicle_registration_front": vehicleRegistrationFront,
      "vehicle_registration_back": vehicleRegistrationBack,
    };

    try {
      final response =
      await _driverRegisterSixRepo.driverRegisterSixApi(fields, files);

      final int statusCode = response["statusCode"] ?? 0;
      final Map<String, dynamic> body = response["body"] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(
          context,
          body["message"] ?? "Submitted successfully",
        );
        Navigator.push(context, CupertinoPageRoute(builder: (context)=> PopperScreen()));
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
