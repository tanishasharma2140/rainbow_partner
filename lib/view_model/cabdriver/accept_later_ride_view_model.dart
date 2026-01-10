import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/repo/cabdriver/accept_later_ride_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab Driver/home/driver_accepted_scree.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class AcceptLaterRideViewModel with ChangeNotifier {
  final _acceptLaterRideRepo = AcceptLaterRideRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> acceptLaterRideApi(
      dynamic orderId,
      dynamic userId,
      double driverLat,
      double driverLng,
      BuildContext context,
      ) async {
    setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? driverId = await userViewModel.getUser();

      final Map data = {
        "order_id": int.tryParse(orderId.toString()) ?? orderId,
        "driver_id": int.tryParse(driverId ?? "") ?? driverId,
        "user_id": int.tryParse(userId.toString()) ?? userId,
      };

      if (kDebugMode) print("🚀 ACCEPT RIDE API DATA → $data");

      final response = await _acceptLaterRideRepo.acceptLaterRideApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(context, body["message"]);

        /// 👇 DRIVER LOCATION SEND HERE
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DriverRideAcceptedScreen(
              orderId: orderId,
              driverLat: driverLat,
              driverLng: driverLng,
            ),
          ),
        );
      } else {
        Utils.showErrorMessage(context, body["message"]);
      }
    } catch (e) {
      if (kDebugMode) print("❌ acceptCabRideApi Error → $e");
      Utils.showErrorMessage(context, "Something went wrong");
    } finally {
      setLoading(false);
    }
  }
}
