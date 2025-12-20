import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/driver_profile_model.dart';
import 'package:rainbow_partner/model/vehicle_brand_model.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_profile_repo.dart';
import 'package:rainbow_partner/repo/cabdriver/vehicle_brand_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class DriverProfileViewModel with ChangeNotifier {
  final _driverProfileRepo = DriverProfileRepo();
  bool _loading = false;
  bool get loading => _loading;

  DriverProfileModel? _driverProfileModel;
  DriverProfileModel? get driverProfileModel => _driverProfileModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setDriverProfileModelData(DriverProfileModel value) {
    _driverProfileModel = value;
    notifyListeners();
  }

  Future<void> driverProfileApi(dynamic currentLatitude,dynamic currentLongitude,context) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {
      "id": userId,
      "current_latitude": currentLatitude,
      "current_longitude": currentLongitude
    };
    try {
      final response = await _driverProfileRepo.driverProfileApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = DriverProfileModel.fromJson(body);
        setDriverProfileModelData(model);
        Utils.showSuccessMessage(context, body["message"]);
      } else {
        if (kDebugMode) print("❌ Error Status: $statusCode → $body");
        Utils.showErrorMessage(context, body["message"]);
      }
    } catch (e) {
      if (kDebugMode) print("ViewModel Error → $e");
      Utils.showErrorMessage(context, "$e");
    } finally {
      setLoading(false);
    }
  }
}
