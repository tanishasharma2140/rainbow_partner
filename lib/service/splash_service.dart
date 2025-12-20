import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/utils/routes/routes_name.dart';
import 'package:rainbow_partner/view/Cab Driver/home/document_verified.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/aadhaar_info.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/driving_license.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/personal_information.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/required_certificate.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/vehicle_document.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/vehicle_information.dart';
import 'package:rainbow_partner/view/Service Man/home/handyman_dashboard.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class SplashServices {

  Future<void> checkAuthentication(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final userVm = UserViewModel();
      final String? userId = await userVm.getUser();
      final int? role = await userVm.getRole();

      if (kDebugMode) {
        print("User ID: $userId");
        print("Role: $role");
      }

      /// 🔴 NOT LOGGED IN
      if (userId == null || userId.isEmpty) {
        Navigator.pushReplacementNamed(context, RoutesName.login);
        return;
      }

      /// 🟢 ROLE BASED NAVIGATION
      switch (role) {

      // ================= CASE 0 & 1 : CAB DRIVER =================
        case 0:
        case 1:
          await _handleCabDriverFlow(context);
          break;

      // ================= CASE 2 : SERVICE PROVIDER =================
        case 2:
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (_) => const HandymanDashboard(),
            ),
          );
          break;

      // ================= OTHER =================
        default:
          Navigator.pushReplacementNamed(context, RoutesName.login);
      }


    } catch (e) {
      if (kDebugMode) {
        print("Splash Error: $e");
      }
      Navigator.pushReplacementNamed(context, RoutesName.login);
    }
  }

  // ================= CAB DRIVER FLOW =================

  Future<void> _handleCabDriverFlow(BuildContext context) async {
    final driverProfileVm =
    Provider.of<DriverProfileViewModel>(context, listen: false);

    final position = await LocationUtils.getLocation();

    // 🔥 await MANDATORY
    await driverProfileVm.driverProfileApi(
      position.latitude.toString(),
      position.longitude.toString(),
      context,
    );

    if (!context.mounted) return; // 🛑 SAFETY

    final data = driverProfileVm.driverProfileModel?.data;

    if (data == null) {
      Navigator.pushReplacementNamed(context, RoutesName.login);
      return;
    }

    if (data.personalInformationStatus == 0) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (_) => const PersonalInformation(
            vehicleId: "",
            vehicleName: "",
            mobileNumber: "",
            profileId: 2,
          ),
        ),
      );
      return;
    }

    if (data.driverLicenceStatus == 0) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (_) => const DrivingLicense(),
        ),
      );
      return;
    }

    if (data.aadhaarPanStatus == 0) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (_) => const AadhaarInfo(),
        ),
      );
      return;
    }

    if (data.requiredCertificatesStatus == 0) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (_) => const RequiredCertificates(),
        ),
      );
      return;
    }

    if (data.vehicleInfoStatus == 0) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (_) => const VehicleInformation(),
        ),
      );
      return;
    }

    if (data.vehicleDocumentsStatus == 0) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (_) => const VehicleDocument(),
        ),
      );      return;
    }

    /// ✅ ALL DONE → DOCUMENT VERIFIED
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (_) => const DocumentVerified(),
      ),
    );
  }
}
