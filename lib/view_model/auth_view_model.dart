import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/model/auth_model.dart';
import 'package:rainbow_partner/repo/auth_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/document_verified.dart';
import 'package:rainbow_partner/view/Service%20Man/home/handyman_dashboard.dart';
import 'package:rainbow_partner/view_model/device_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

import '../utils/routes/routes_name.dart' show RoutesName;

class AuthViewModel with ChangeNotifier {
  final _authRepo = AuthRepo();

  // ---------------- LOADING STATES ----------------
  bool _loading = false;
  bool get loading => _loading;

  bool _sendingOtp = false;
  bool get sendingOtp => _sendingOtp;

  bool _verifyingOtp = false;
  bool get verifyingOtp => _verifyingOtp;

  // ---------------- SETTERS ----------------
  void setLoginLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setSendingOtp(bool value) {
    _sendingOtp = value;
    notifyListeners();
  }

  void setVerifyingOtp(bool value) {
    _verifyingOtp = value;
    notifyListeners();
  }

  // =======================================================================
  //                           LOGIN API
  // =======================================================================

  Future<void> loginApi(dynamic phone, BuildContext context) async {
    setLoginLoading(true);

    final deviceVm = Provider.of<DeviceViewModel>(context, listen: false);
    await deviceVm.fetchDeviceId();
    final deviceId = deviceVm.deviceId ??"unknown";

    Map<String, dynamic> data = {
      "phone": phone,
      "device_id": deviceId,
      "fcm_token": fcmToken,
    };

    try {
      final response = await _authRepo.loginApi(data);

      setLoginLoading(false);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      // ---------------- SUCCESS ----------------
      if (statusCode == 200 || statusCode == 201) {
        final authModel = AuthModel.fromJson(body);
        UserViewModel userViewModel = UserViewModel();
        int role = await userViewModel.getRole() ?? 0;
         // int platformType = await userViewModel.getPlatformType();

        final userPref = Provider.of<UserViewModel>(context, listen: false);
        userPref.saveUser(authModel.servicemanId.toString(),role);

        Utils.showSuccessMessage(context, authModel.message ?? 'Login Successful');

        Navigator.pushNamed(
          context,
          RoutesName.otpScreen,
          arguments: {
            "mobileNumber": phone,
            "userId": authModel.servicemanId,
          },
        );
      }

      else {
        Navigator.pushNamed(
          context,
          RoutesName.onboardingScreen,
          arguments: {'mobileNumber': phone},
        );

        Utils.showErrorMessage(
          context,
          body["message"] ?? "User not found",
        );
      }
    }

    // =======================================================================
    //                           CATCH BLOCK (404 ALSO)
    // =======================================================================
    catch (e) {
      setLoginLoading(false);

      if (kDebugMode) print("❌ Login API Error → $e");

      // 404 or any exception → REDIRECT TO REGISTER
      Navigator.pushNamed(
        context,
        RoutesName.onboardingScreen,
        arguments: {'mobileNumber': phone},
      );

      Utils.showErrorMessage(
        context,
        "User not found. Please register.",
      );
    }
  }

  // =======================================================================
  //                           SEND OTP API
  // =======================================================================

  Future<void> sendOtpApi(dynamic mobile, BuildContext context) async {
    setSendingOtp(true);

    try {
      final response = await _authRepo.sendOtpApi(mobile.toString());
      setSendingOtp(false);

      // FIX: Read from body (NOT response)
      final Map<String, dynamic> body = response["body"] ?? {};

      final String errorCode = body['error']?.toString() ?? "";
      final String msg = body['msg'] ?? "Something went wrong";

      if (errorCode == "200") {
        Utils.showSuccessMessage(context, msg);
      } else {
        Utils.showErrorMessage(context, msg);
      }
    } catch (e) {
      setSendingOtp(false);
      if (kDebugMode) print("❌ Send OTP Error → $e");
      Utils.showErrorMessage(context, "OTP sending failed. Try again.");
    }
  }


  // =======================================================================
  //                           VERIFY OTP API
  // =======================================================================

  Future<void> verifyOtpApi(
      dynamic phone,
      dynamic otp,
      dynamic userId,
      BuildContext context,
      ) async {
    setVerifyingOtp(true);

    try {
      final response = await _authRepo.verifyOtpApi(phone, otp);
      setVerifyingOtp(false);

      final Map<String, dynamic> body = response["body"] ?? {};

      final String errorCode = body['error']?.toString() ?? "";
      final String msg = body['msg'] ?? "Error verifying OTP";

      if (errorCode == "200") {

        // ✅ AuthModel se data lo
        final authModel = AuthModel.fromJson(body);
        final int platformType = authModel.platformType ?? 0;

        print("platformType = $platformType");

        final userVM = Provider.of<UserViewModel>(context, listen: false);

        // ================= PLATFORM BASED NAVIGATION =================

        if (platformType == 1) {
          // 🧑‍🔧 HANDYMAN
          userVM.saveUser(userId.toString(), 2);

          Utils.showSuccessMessage(context, msg);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HandymanDashboard()),
                (route) => false,
          );
        }
        else if (platformType == 0) {
          // 🚕 CAB DRIVER
          userVM.saveUser(userId.toString(), 1);

          Utils.showSuccessMessage(context, msg);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DocumentVerified()),
                (route) => false,
          );
        }
        else {
          Utils.showErrorMessage(context, "Invalid platform type");
        }
      }
      else {
        Utils.showErrorMessage(context, msg);
      }
    } catch (e) {
      setVerifyingOtp(false);
      if (kDebugMode) print("❌ Verify OTP Error → $e");
      Utils.showErrorMessage(context, "OTP verification failed. Try again.");
    }
  }




}

