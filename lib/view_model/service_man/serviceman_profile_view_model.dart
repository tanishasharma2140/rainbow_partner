import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/serviceman_profile_model.dart';
import 'package:rainbow_partner/repo/serviceman/serviceman_profile_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class ServicemanProfileViewModel with ChangeNotifier {
  final _servicemanProfileRepo = ServicemanProfileRepo();
  bool _loading = false;
  bool get loading => _loading;

  ServicemanProfileModel? _servicemanProfileModel;
  ServicemanProfileModel? get servicemanProfileModel => _servicemanProfileModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setProfileModelData(ServicemanProfileModel value) {
    _servicemanProfileModel = value;
    notifyListeners();
  }

  Future<void> servicemanProfileApi(dynamic currentLatitude,dynamic currentLongitude, context) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {
      "serviceman_id": userId,
      "current_latitude": currentLatitude,
      "current_longitude": currentLongitude
    };
    try {
      final response = await _servicemanProfileRepo.servicemanProfileApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = ServicemanProfileModel.fromJson(body);
        setProfileModelData(model);
        Utils.showSuccessMessage(context, body["message"]);
      } else {
        if (kDebugMode) print("❌ Error Status: $statusCode → $body");
        Utils.showErrorMessage(context, body["message"]);
      }

    } catch (e) {
      if (kDebugMode) print("ViewModel Error → $e");
      Utils.showErrorMessage(context,"$e");
    } finally {
      setLoading(false);
    }
  }
}
