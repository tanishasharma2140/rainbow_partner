import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_register_six_repo.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/vehicle_document.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/document_verified.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/aadhaar_info.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/driving_license.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/personal_information.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/required_certificate.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/vehicle_information.dart';

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
        final position = await LocationUtils.getLocation();
        // 🔹 REFRESH PROFILE
        final profileVm =
        Provider.of<DriverProfileViewModel>(context, listen: false);

        await profileVm.driverProfileApi(position.latitude.toString(),
            position.longitude.toString(), context);
        final profile = profileVm.driverProfileModel?.data;

        if (profile == null) {
          Utils.showErrorMessage(
              context, "Profile not loaded. Try again.");
          return;
        }

        bool isPendingOrRejected(int? status) {
          return status == 0 || status == 3;
        }

        // 🔥 STATUS-BASED NAVIGATION (SEQUENCE)
        if (isPendingOrRejected(profile.personalInformationStatus)) {
          Navigator.push(context, CupertinoPageRoute(builder: (context) =>
              PersonalInformation(vehicleId: "",
                  vehicleName: "",
                  mobileNumber: "",
                  profileId: 1)));
        } else if (isPendingOrRejected(profile.driverLicenceStatus)) {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => DrivingLicense()));
        } else if (isPendingOrRejected(profile.aadhaarPanStatus)) {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => AadhaarInfo()));
        } else if (isPendingOrRejected(profile.requiredCertificatesStatus)) {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => RequiredCertificates()));
        } else if (isPendingOrRejected(profile.vehicleInfoStatus)) {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => VehicleInformation()));
        } else if (isPendingOrRejected(profile.vehicleDocumentsStatus)) {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => VehicleDocument()));
        } else {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => DocumentVerified()));
        }
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
