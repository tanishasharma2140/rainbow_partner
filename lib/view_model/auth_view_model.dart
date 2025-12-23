// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rainbow_partner/main.dart';
// import 'package:rainbow_partner/model/auth_model.dart';
// import 'package:rainbow_partner/repo/auth_repo.dart';
// import 'package:rainbow_partner/utils/utils.dart';
// import 'package:rainbow_partner/view/Cab%20Driver/home/document_verified.dart';
// import 'package:rainbow_partner/view/Service%20Man/home/handyman_dashboard.dart';
// import 'package:rainbow_partner/view_model/device_view_model.dart';
// import 'package:rainbow_partner/view_model/user_view_model.dart';
//
// import '../utils/routes/routes_name.dart' show RoutesName;
//
// class AuthViewModel with ChangeNotifier {
//   final _authRepo = AuthRepo();
//
//   // ---------------- LOADING STATES ----------------
//   bool _loading = false;
//   bool get loading => _loading;
//
//   bool _sendingOtp = false;
//   bool get sendingOtp => _sendingOtp;
//
//   bool _verifyingOtp = false;
//   bool get verifyingOtp => _verifyingOtp;
//
//   // ---------------- SETTERS ----------------
//   void setLoginLoading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }
//
//   void setSendingOtp(bool value) {
//     _sendingOtp = value;
//     notifyListeners();
//   }
//
//   void setVerifyingOtp(bool value) {
//     _verifyingOtp = value;
//     notifyListeners();
//   }
//
//   // =======================================================================
//   //                           LOGIN API
//   // =======================================================================
//
//   Future<void> loginApi(dynamic phone, BuildContext context) async {
//     setLoginLoading(true);
//
//     final deviceVm = Provider.of<DeviceViewModel>(context, listen: false);
//     await deviceVm.fetchDeviceId();
//     final deviceId = deviceVm.deviceId ??"unknown";
//
//     Map<String, dynamic> data = {
//       "phone": phone,
//       "device_id": deviceId,
//       "fcm_token": fcmToken,
//     };
//
//     try {
//       final response = await _authRepo.loginApi(data);
//
//       setLoginLoading(false);
//
//       final int statusCode = response['statusCode'] ?? 0;
//       final Map<String, dynamic> body = response['body'] ?? {};
//
//       // ---------------- SUCCESS ----------------
//       if (statusCode == 200 || statusCode == 201) {
//         final authModel = AuthModel.fromJson(body);
//         UserViewModel userViewModel = UserViewModel();
//         int role = await userViewModel.getRole() ?? 0;
//          // int platformType = await userViewModel.getPlatformType();
//
//         final userPref = Provider.of<UserViewModel>(context, listen: false);
//         userPref.saveUser(authModel.servicemanId.toString(),role);
//
//         Utils.showSuccessMessage(context, authModel.message ?? 'Login Successful');
//
//         Navigator.pushNamed(
//           context,
//           RoutesName.otpScreen,
//           arguments: {
//             "mobileNumber": phone,
//             "userId": authModel.servicemanId,
//           },
//         );
//       }
//
//       else {
//         Navigator.pushNamed(
//           context,
//           RoutesName.onboardingScreen,
//           arguments: {'mobileNumber': phone},
//         );
//
//         Utils.showErrorMessage(
//           context,
//           body["message"] ?? "User not found",
//         );
//       }
//     }
//
//     // =======================================================================
//     //                           CATCH BLOCK (404 ALSO)
//     // =======================================================================
//     catch (e) {
//       setLoginLoading(false);
//
//       if (kDebugMode) print("❌ Login API Error → $e");
//
//       // 404 or any exception → REDIRECT TO REGISTER
//       Navigator.pushNamed(
//         context,
//         RoutesName.onboardingScreen,
//         arguments: {'mobileNumber': phone},
//       );
//
//       Utils.showErrorMessage(
//         context,
//         "User not found. Please register.",
//       );
//     }
//   }
//
//   // =======================================================================
//   //                           SEND OTP API
//   // =======================================================================
//
//   // Future<void> sendOtpApi(dynamic mobile, BuildContext context) async {
//   //   setSendingOtp(true);
//   //
//   //   try {
//   //     final response = await _authRepo.sendOtpApi(mobile.toString());
//   //     setSendingOtp(false);
//   //
//   //     // FIX: Read from body (NOT response)
//   //     final Map<String, dynamic> body = response["body"] ?? {};
//   //
//   //     final String errorCode = body['error']?.toString() ?? "";
//   //     final String msg = body['msg'] ?? "Something went wrong";
//   //
//   //     if (errorCode == "200") {
//   //       Utils.showSuccessMessage(context, msg);
//   //     } else {
//   //       Utils.showErrorMessage(context, msg);
//   //     }
//   //   } catch (e) {
//   //     setSendingOtp(false);
//   //     if (kDebugMode) print("❌ Send OTP Error → $e");
//   //     Utils.showErrorMessage(context, "OTP sending failed. Try again.");
//   //   }
//   // }
//
//
//   // =======================================================================
//   //                           VERIFY OTP API
//   // =======================================================================
//
//   // Future<void> verifyOtpApi(
//   //     dynamic phone,
//   //     dynamic otp,
//   //     dynamic userId,
//   //     BuildContext context,
//   //     ) async {
//   //   setVerifyingOtp(true);
//   //
//   //   try {
//   //     final response = await _authRepo.verifyOtpApi(phone, otp);
//   //     setVerifyingOtp(false);
//   //
//   //     final Map<String, dynamic> body = response["body"] ?? {};
//   //
//   //     final String errorCode = body['error']?.toString() ?? "";
//   //     final String msg = body['msg'] ?? "Error verifying OTP";
//   //
//   //     if (errorCode == "200") {
//   //
//   //       // ✅ AuthModel se data lo
//   //       final authModel = AuthModel.fromJson(body);
//   //       final int platformType = authModel.platformType ?? 0;
//   //
//   //       print("platformType = $platformType");
//   //
//   //       final userVM = Provider.of<UserViewModel>(context, listen: false);
//   //
//   //       // ================= PLATFORM BASED NAVIGATION =================
//   //
//   //       if (platformType == 1) {
//   //         // 🧑‍🔧 HANDYMAN
//   //         userVM.saveUser(userId.toString(), 2);
//   //
//   //         Utils.showSuccessMessage(context, msg);
//   //
//   //         Navigator.pushAndRemoveUntil(
//   //           context,
//   //           MaterialPageRoute(builder: (_) => const HandymanDashboard()),
//   //               (route) => false,
//   //         );
//   //       }
//   //       else if (platformType == 0) {
//   //         // 🚕 CAB DRIVER
//   //         userVM.saveUser(userId.toString(), 1);
//   //
//   //         Utils.showSuccessMessage(context, msg);
//   //
//   //         Navigator.pushAndRemoveUntil(
//   //           context,
//   //           MaterialPageRoute(builder: (_) => const DocumentVerified()),
//   //               (route) => false,
//   //         );
//   //       }
//   //       else {
//   //         Utils.showErrorMessage(context, "Invalid platform type");
//   //       }
//   //     }
//   //     else {
//   //       Utils.showErrorMessage(context, msg);
//   //     }
//   //   } catch (e) {
//   //     setVerifyingOtp(false);
//   //     if (kDebugMode) print("❌ Verify OTP Error → $e");
//   //     Utils.showErrorMessage(context, "OTP verification failed. Try again.");
//   //   }
//   // }
//
//
//
//
// }


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/auth/onboarding_screen.dart';
import 'package:rainbow_partner/auth/otp_screen.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/repo/auth_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/document_verified.dart';
import 'package:rainbow_partner/view/Service%20Man/home/handyman_dashboard.dart';
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

  // Future<void> otpReSentApi(String phoneNumber, BuildContext context) async {
  //   setLoading(true);
  //   try {
  //     final response = await _authRepo.otpSent(phoneNumber);
  //
  //     setLoading(false);
  //     Map<String, dynamic> body = response['body'] ?? {};
  //
  //     if (body['error'] == "200") {
  //       UtilsMessage.show(
  //         context,
  //         message: body['msg'] ?? 'OTP resent successfully',
  //         type: MessageType.success,
  //       );
  //     } else {
  //       UtilsMessage.show(
  //         context,
  //         message: body['msg'] ?? 'Failed to resend OTP',
  //         type: MessageType.error,
  //       );
  //     }
  //   } catch (e) {
  //     setLoading(false);
  //     if (kDebugMode) print('otpReSentApi error: $e');
  //     UtilsMessage.show(context, message: 'Something went wrong', type: MessageType.error);
  //   }
  // }

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

  /// ---------------- LOGIN ----------------
  // Future<void> loginApi(BuildContext context,) async {
  //   setLoginLoading(true);
  //   // final deviceId = await getDeviceId();
  //
  //   Map<String, dynamic> data = {
  //     "phone": phoneController.text,
  //     "device_id": "fvgbhnj",
  //     "fcm_token": fcmToken,
  //   };
  //
  //   print({
  //     "phone": phoneController.text,
  //     "device_id": "fvgbhnj",
  //     "fcm_token": fcmToken,
  //   });
  //   print("fjyrgfjr");
  //
  //   try {
  //     final response = await _authRepo.loginApi(data);
  //
  //     setLoginLoading(false);
  //     int statusCode = response['statusCode'] ?? 0;
  //     Map<String, dynamic> body = response['body'] ?? {};
  //
  //     if (statusCode == 200 || statusCode == 201) {
  //       final authModel = AuthModel.fromJson(body);
  //       setDataInModel(authModel);
  //
  //       final userPref = Provider.of<UserViewModel>(context, listen: false);
  //       userPref.saveRole(authModel.platformType);
  //       userPref.saveUser(authModel.servicemanId.toString());
  //       // 🔥 ROLE BASED NAVIGATION
  //       if (authModel.platformType == 1) {
  //         // Navigator.pushReplacement(
  //         //   context,
  //         //   MaterialPageRoute(builder: (_) => ServicemanHomeScreen()),
  //         // );
  //       }
  //       else if (authModel.platformType == 2) {
  //         // Navigator.pushReplacement(
  //         //   context,
  //         //   MaterialPageRoute(builder: (_) => DriverHomeScreen()),
  //         // );
  //       }
  //       else if (authModel.platformType == 3) {
  //         // Navigator.pushReplacement(
  //         //   context,
  //         //   MaterialPageRoute(builder: (_) => CustomerHomeScreen()),
  //         // );
  //       }
  //       else {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (_) => OnboardingScreen()),
  //         );
  //       }
  //
  //       Utils.showSuccessMessage(context, body['message']);
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (_) => OnboardingScreen()),
  //       );
  //     } else if(statusCode == 404) {
  //       Utils.showErrorMessage(context, body['message'] ?? 'Login Failed' );
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (_) => OnboardingScreen()),
  //       );
  //     }
  //   } catch (e) {
  //     setLoginLoading(false);
  //     if (kDebugMode) print('loginApi error: $e');
  //     Utils.showErrorMessage(context, "Something went wrong");
  //   }
  // }
  Future<void> loginApi(BuildContext context) async {
    setLoginLoading(true);

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

      userPref.saveRole(authModel.platformType);
      userPref.saveUser(authModel.servicemanId.toString());
      print("jhuyjhu");
      print(authModel.platformType);

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
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => DocumentVerified()));
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

}
