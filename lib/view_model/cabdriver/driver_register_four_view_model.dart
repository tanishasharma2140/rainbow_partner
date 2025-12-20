import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_register_four_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/vehicle_information.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class DriverRegisterFourViewModel with ChangeNotifier {
  final DriverRegisterFourRepo _driverRegisterFourRepo = DriverRegisterFourRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> driverRegisterFourApi({
    required File fitnessCertificate,
    required File pollutionCertificate,
    required File insuranceCertificate,
    required File policeCertificate,
    required String requiresCertificateStatus,
    required BuildContext context,
  }) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();

    Map<String, String> fields = {
      "required_certificates_status": requiresCertificateStatus,
      "id": userId.toString(),
    };

    Map<String, dynamic> files = {
      "fitness_certificate": fitnessCertificate,
      "pollution_certificate": pollutionCertificate,
      "insurance_certificate": insuranceCertificate,
      "police_certificate": policeCertificate,
    };

    try {
      final response =
      await _driverRegisterFourRepo.driverRegisterFourApi(fields, files);

      final int statusCode = response["statusCode"] ?? 0;
      final Map<String, dynamic> body = response["body"] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(
          context,
          body["message"] ?? "Submitted successfully",
        );
        Navigator.push(context, CupertinoPageRoute(builder: (context)=> VehicleInformation()));
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
