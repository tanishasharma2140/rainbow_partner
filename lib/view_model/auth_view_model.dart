import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/auth/onboarding_screen.dart';
import 'package:rainbow_partner/auth/otp_screen.dart';
import 'package:rainbow_partner/repo/auth_repo.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/utils/routes/routes_name.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/document_verified.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/aadhaar_info.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/driving_license.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/personal_information.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/required_certificate.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/vehicle_document.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/vehicle_information.dart';
import 'package:rainbow_partner/view/Service%20Man/home/handyman_dashboard.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';
import '../model/auth_model.dart' show AuthModel;

class AuthViewModel with ChangeNotifier {
  final _authRepo = AuthRepo();

  final TextEditingController phoneController = TextEditingController();

  /// ---------------- LOADING ----------------
  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _loginLoading = false;
  bool get loginLoading => _loginLoading;

  void setLoginLoading(bool value) {
    _loginLoading = value;
    notifyListeners();
  }

  /// ---------------- AUTH MODEL ----------------
  AuthModel? _loginResponse;
  AuthModel? get loginResponse => _loginResponse;

  void setDataInModel(AuthModel loginData) {
    _loginResponse = loginData;
    notifyListeners();
  }

  /// ---------------- OTP ----------------
  Future<void> otpSentApi(String mobile, BuildContext context) async {
    setLoading(true);
    try {
      final response = await _authRepo.sendOtpApi(mobile.toString());

      setLoading(false);
      Map<String, dynamic> body = response['body'] ?? {};
      if (body['error'] == "200") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(phoneNumber: mobile),
          ),
        );
        Utils.showSuccessMessage(context,  body['msg'] ?? 'OTP sent successfully');
      } else {
        Utils.showErrorMessage(context, body['msg'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      setLoading(false);
      if (kDebugMode) print('otpSentApi error: $e');
      Utils.showErrorMessage(context, 'Something went wrong');
    }
  }

  Future<void> otpReSentApi(String phoneNumber, BuildContext context) async {
    setLoading(true);
    try {
      final response = await _authRepo.sendOtpApi(phoneNumber);

      setLoading(false);
      Map<String, dynamic> body = response['body'] ?? {};

      if (body['error'] == "200") {
        Utils.showSuccessMessage(context,  body['msg'] ?? 'OTP sent successfully');
      } else {
        Utils.showErrorMessage(context, body['msg'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      setLoading(false);
      if (kDebugMode) print('otpReSentApi error: $e');
      Utils.showErrorMessage(context, 'Something went wrong');
    }
  }

  Future<void> verifySentApi(String phone, String otp, BuildContext context) async {
    setLoading(true);
    try {
      final response = await _authRepo.verifyOtpApi(phone, otp);

      setLoading(false);
      Map<String, dynamic> body = response['body'] ?? {};

      if (body['error'] == "200") {
        Utils.showSuccessMessage(context,  body['msg'] ?? 'OTP verified');
        loginApi(context);
      } else {
        Utils.showErrorMessage(context, body['msg'] ?? 'OTP verification failed');
      }
    } catch (e) {
      setLoading(false);
      if (kDebugMode) print('verifySentApi error: $e');
      Utils.showErrorMessage(context, 'Something went wrong');
    }
  }

  Future<void> loginApi(BuildContext context) async {
    setLoginLoading(true);

  final fcmToken = await FirebaseMessaging.instance.getToken();

    final data = {
      "phone": phoneController.text.trim(),
      "device_id": "fvgbhnj",
      "fcm_token": fcmToken ?? "",
    };

    final response = await _authRepo.loginApi(data);

    setLoginLoading(false);

    final int statusCode = response['statusCode'] ?? 0;
    final Map<String, dynamic> body =
    Map<String, dynamic>.from(response['body'] ?? {});

    // ---------------- SUCCESS ----------------
    if (statusCode == 200 || statusCode == 201) {
      final authModel = AuthModel.fromJson(body);

      final userPref =
      Provider.of<UserViewModel>(context, listen: false);

      /// 🔥 ALWAYS await
      await userPref.saveRole(authModel.platformType);

      /// 🔥 ROLE BASED ID SAVE
      if (authModel.platformType == 2) {
        // 🚕 CAB DRIVER
        await userPref.saveUser(authModel.driverId.toString());
      } else if (authModel.platformType == 1) {
        // 🛠 SERVICE MAN
        await userPref.saveUser(authModel.servicemanId.toString());
      }


      Utils.showSuccessMessage(
        context,
        body['message'] ?? "Login successful",
      );

      // 🔥 ROLE BASED NAVIGATION
      switch (authModel.platformType) {

        case 1:
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => HandymanDashboard()));
          break;

        case 2:
          await handleDriverFlow(context);
          break;

        case 3:
        // Navigator.pushReplacement(context,
        // MaterialPageRoute(builder: (_) => CustomerHomeScreen()));
          break;

        default:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OnboardingScreen(phone: phoneController.text.trim(),)),
          );
      }
      return;
    }



    // ---------------- USER NOT FOUND ----------------
    if (statusCode == 404) {
      Utils.showErrorMessage(
        context,
        body['message'] ?? "User not found",
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnboardingScreen(phone:phoneController.text.trim())),
      );
      return;
    }

    // ---------------- NO INTERNET ----------------
    if (statusCode == 0) {
      Utils.showErrorMessage(
        context,
        "Please check your internet connection",
      );
      return;
    }

    // ---------------- OTHER ERRORS ----------------
    Utils.showErrorMessage(
      context,
      body['message'] ?? "Login failed",
    );
  }

  Future<void> handleDriverFlow(BuildContext context) async {
    try {
      final driverProfileVm =
      Provider.of<DriverProfileViewModel>(context, listen: false);

      final position = await LocationUtils.getLocation();

      await driverProfileVm.driverProfileApi(
        position.latitude.toString(),
        position.longitude.toString(),
        context,
      );

      if (!context.mounted) return;

      final data = driverProfileVm.driverProfileModel?.data;

      if (data == null) {
        Navigator.pushReplacementNamed(context, RoutesName.login);
        return;
      }

      // ✅ Personal Info
      if (data.personalInformationStatus == 0) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (_) => PersonalInformation(
              vehicleId: data.vehicleType?.toString() ?? "",
              vehicleName: data.vehicleName?.toString() ?? "",
              mobileNumber: data.mobile?.toString() ?? "", profileId: 1,
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
          CupertinoPageRoute(builder: (_) => const VehicleDocument()),
        );
        return;
      }

      /// ✅ ALL DONE → DOCUMENT VERIFIED
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (_) => const DocumentVerified(),
        ),
      );
    } catch (e) {
      if (kDebugMode) print('handleDriverFlow error: $e');
      if (e.toString().contains("Location services are disabled")) {
        Utils.showErrorMessage(context, "Please enable your GPS/Location services");
        // Optionally redirect back to PermissionScreen or show settings
        await Geolocator.openLocationSettings();
      } else {
        Utils.showErrorMessage(context, "An error occurred: $e");
      }
    }
  }

  @override
  void dispose() {
    phoneController.clear();
    super.dispose();
  }
}

