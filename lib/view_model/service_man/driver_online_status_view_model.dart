import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_online_status_repo.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class DriverOnlineStatusViewModel with ChangeNotifier {
  final _driverOnlineStatusRepo = DriverOnlineStatusRepo();
  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> driverOnlineStatusApi(
      dynamic onlineStatus,
      dynamic currentLatitude,
      dynamic currentLongitude,
      context,
      ) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {
      "driver_id": userId,
      "online_status": onlineStatus,
      "current_latitude": currentLatitude,
      "current_longitude": currentLongitude
    };
    print("dfedfvfebgrgrefg");
    print(data);
    try {
      final response = await _driverOnlineStatusRepo.driverOnlineStatusApi(
        data,
      );

      final position = await LocationUtils.getLocation();

      final lat = position.latitude.toString();
      final lng = position.longitude.toString();
      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(context, body["message"]);
        Provider.of<DriverProfileViewModel>(context,listen: false).driverProfileApi(lat,lng,context);
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
