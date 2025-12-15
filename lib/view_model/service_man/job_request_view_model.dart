import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/repo/serviceman/job_request_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/job_request_success_page.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class JobRequestViewModel with ChangeNotifier {
  final JobRequestRepo _jobRequestRepo = JobRequestRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> jobRequestApi({
    required File profilePhoto,
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String designation,
    required String skillType,
    required String city,
    required File policeVerificationFile,
    required List<File> designationFiles,
    required BuildContext context,
  }) async {

    setLoading(true);

    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    print("lkjuijki");
    print(userId);

    Map<String, String> fields = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "mobile": mobile,
      "designation": designation,
      "skill_type": skillType,
      "user_id": userId ?? "",
      "city": city,
      "usertype": "2",
    };

    Map<String, dynamic> files = {
      "police_verification_certificate": policeVerificationFile,
      "profile_photo": profilePhoto,
      "designation_file": designationFiles,
    };

    // 🔥 PRINT REQUEST DATA (DEBUG)
    debugPrint("=================== 📤 JOB REQUEST DEBUG ===================");
    debugPrint("➡ URL: https://yoyomiles.codescarts.com/api/job_request");

    debugPrint("\n📌 TEXT FIELDS:");
    fields.forEach((key, value) {
      debugPrint("  $key : $value");
    });

    debugPrint("\n📌 FILE FIELDS:");
    debugPrint("  profile_photo → ${profilePhoto.path}");
    debugPrint("  police_verification_certificate → ${policeVerificationFile.path}");

    debugPrint("\n📌 DESIGNATION FILES (${designationFiles.length} files):");
    for (int i = 0; i < designationFiles.length; i++) {
      debugPrint("  designation_file[$i] → ${designationFiles[i].path}");
    }

    try {
      final response = await _jobRequestRepo.jobRequestApi(fields, files);

      final int statusCode = response["statusCode"] ?? 0;
      final Map<String, dynamic> body = response["body"] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(context, body["message"] ?? "Submitted successfully");

        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => JobRequestSuccessPage()),
        );
      } else {
        Utils.showErrorMessage(context, body["message"] ?? "Something went wrong!");
      }

    } catch (e) {
      if (kDebugMode) print("❌ ViewModel Error → $e");
      Utils.showErrorMessage(context, "Request failed!");
    } finally {
      setLoading(false);
    }
  }
}
