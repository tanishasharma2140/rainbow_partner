import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_withdraw_request_repo.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class DriverWithdrawRequestViewModel with ChangeNotifier {
  final _driverWithdrawRequestRepo = DriverWithdrawRequestRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> driverWithdrawRequestApi(
      dynamic amount,
      BuildContext context,
      ) async {
    setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? driverId = await userViewModel.getUser();

      Map<String, dynamic> data = {
        "driver_id": driverId,
        "amount": amount
      };

      if (kDebugMode) {
        print("🚀 WITHDRAW API DATA → $data");
      }

      final response = await _driverWithdrawRequestRepo.driverWithdrawRequestApi(data);
      final position = await LocationUtils.getLocation();

      final lat = position.latitude.toString();
      final lng = position.longitude.toString();
      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        debugPrint(body["message"]);
        if (context.mounted) {
          Provider.of<DriverProfileViewModel>(
            context,
            listen: false,
          ).driverProfileApi(lat , lng,context);
        }

        Navigator.pop(context);
      } else {
        Utils.showErrorMessage(context, body["message"]);
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Withdraw Error → $e");
      }
      Utils.showErrorMessage(context, e.toString());
    } finally {
      setLoading(false);
    }
  }
}
