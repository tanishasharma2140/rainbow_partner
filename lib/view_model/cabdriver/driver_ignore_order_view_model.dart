import 'package:flutter/cupertino.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_ignore_order_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class DriverIgnoreOrderViewModel with ChangeNotifier {
  final _driverIgnoreOrderRepo = DriverIgnoreOrderRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> driverIgnoreOrderApi(
      dynamic orderId,

      BuildContext context,
      ) async {
    setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? driverId = await userViewModel.getUser();

      Map data = {
        "order_id": orderId,
        "driver_id": driverId
      }
      ;

      final response = await _driverIgnoreOrderRepo.driverIgnoreOrderApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if ((statusCode == 200 || statusCode == 201)) {
        if (context.mounted) {
          // Utils.showSuccessMessage(context, body["message"]);
          debugPrint( body["message"]);
        }
      } else {
        if (context.mounted) {
          Utils.showErrorMessage(context, body["message"]);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Utils.showErrorMessage(context, e.toString());
      }
    } finally {
      setLoading(false);
    }
  }

}
