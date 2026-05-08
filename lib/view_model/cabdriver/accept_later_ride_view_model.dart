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

  int safeInt(dynamic value) {
    try {
      return int.parse(value.toString());
    } catch (e) {
      if (kDebugMode) print("❌ safeInt parse failed for: $value → $e");
      return 0;
    }
  }

  Future<bool> acceptLaterRideApiSilent(dynamic orderId) async {
    setLoading(true);
    try {
      UserViewModel userViewModel = UserViewModel();
      String? driverId = await userViewModel.getUser();
      final data = {
        "order_id": safeInt(orderId),
        "driver_id": safeInt(driverId),
      };
      final response = await _acceptLaterRideRepo.acceptLaterRideApi(data);
      final int statusCode = response['statusCode'] ?? 0;
      return statusCode == 200 || statusCode == 201;
    } catch (e) {
      if (kDebugMode) print("❌ acceptLaterRideApiSilent → $e");
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> acceptLaterRideApi(
      dynamic orderId,
      double driverLat,
      double driverLng,
      BuildContext context,
      ) async {
    setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? driverId = await userViewModel.getUser();

      /// DEBUG PRINTS 👇
      if (kDebugMode) {
        print("----- DEBUG ACCEPT RIDE INPUT -----");
        print("orderId → $orderId | type: ${orderId.runtimeType}");
        print("driverId → $driverId | type: ${driverId.runtimeType}");
        print("----------------------------------");
      }

      final Map<String, dynamic> data = {
        "order_id": safeInt(orderId),
        "driver_id": safeInt(driverId),
      };

      if (kDebugMode) print("📦 Sending API DATA → $data");

      final response = await _acceptLaterRideRepo.acceptLaterRideApi(data);

      /// Print Full Response
      if (kDebugMode) print("📥 API RAW RESPONSE → $response");

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(context, body["message"]);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DriverRideAcceptedScreen(
              orderId: safeInt(orderId) ,
              driverLat: driverLat,
              driverLng: driverLng,
            ),
          ),
        );
      } else {
        Utils.showErrorMessage(context, body["message"] ?? "Something went wrong");
      }
    } catch (e) {
      if (kDebugMode) print("❌ acceptLaterRideApi Error → $e");
      Utils.showErrorMessage(context, "Something went wrong");
    } finally {
      setLoading(false);
    }
  }
}
