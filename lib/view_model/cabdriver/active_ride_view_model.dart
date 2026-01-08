import 'package:flutter/cupertino.dart';
import 'package:rainbow_partner/repo/cabdriver/active_ride_repo.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class ActiveRideViewModel with ChangeNotifier {
  final _activeRideRepo = ActiveRideRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  /// Returns ride data if active, else null
  Future<Map<String, dynamic>?> activeRideApi() async {
    setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? driverId = await userViewModel.getUser();

      if (driverId == null || driverId.isEmpty) {
        setLoading(false);
        return null;
      }

      Map<String, dynamic> data = {
        "type": 2,
        "driver_id": driverId.toString(),
      };

      final response = await _activeRideRepo.activeRideApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        if (body["active_ride_count"] == 1) {
          return body["data"]; // e.g {order_id: 81, order_status: 1}
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setLoading(false);
    }

    return null;
  }
}
