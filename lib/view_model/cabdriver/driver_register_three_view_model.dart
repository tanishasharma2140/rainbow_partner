import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_register_three_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/required_certificate.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class DriverRegisterThreeViewModel with ChangeNotifier {
  final DriverRegisterThreeRepo _driverRegisterThreeRepo = DriverRegisterThreeRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> driverRegisterThreeApi({
    required File aadhaarFront,
    required File aadhaarBack,
    required File panCardFront,
    required File panCardBack,
    required String aadhaarPanStatus,
    required String aadhaarNumber,
    required String panCardNumber,
    required BuildContext context,
  }) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();

    Map<String, String> fields = {
      "aadhaar_pan_status": aadhaarPanStatus,
      "id": userId.toString(),
      "aadhaar_number": aadhaarNumber,
      "pan_card_number": panCardNumber,
    };

    Map<String, dynamic> files = {
      "aadhaar_front": aadhaarFront,
      "aadhaar_back": aadhaarBack,
      "pan_card_front": panCardFront,
      "pan_card_back": panCardBack,
    };

    try {
      final response =
      await _driverRegisterThreeRepo.driverRegisterThreeApi(fields, files);

      final int statusCode = response["statusCode"] ?? 0;
      final Map<String, dynamic> body = response["body"] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(
          context,
          body["message"] ?? "Submitted successfully",
        );
        Navigator.push(context, CupertinoPageRoute(builder: (context)=> RequiredCertificates()));
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
