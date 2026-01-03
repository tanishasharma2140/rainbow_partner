import 'package:flutter/cupertino.dart';
import 'package:rainbow_partner/repo/cabdriver/change_cab_order_status_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class ChangeCabOrderStatusViewModel with ChangeNotifier {
  final _changeCabOrderStatusRepo = ChangeCabOrderStatusRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> changeCabOrderApi(
      dynamic orderId,
      dynamic orderStatus,
      dynamic orderOtp,
      dynamic cancelReason,
      BuildContext context,
      ) async {
    setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? driverId = await userViewModel.getUser();

      Map data = {
        "order_id": orderId,
        "order_status": orderStatus,
        "orderOtp": orderOtp,
        "type": 2,
        "driver_id": driverId,
        "cancel_reason": cancelReason
      };

      final response = await _changeCabOrderStatusRepo.changeCabOrderApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if ((statusCode == 200 || statusCode == 201)) {
        if (context.mounted) {
          Utils.showSuccessMessage(context, body["message"]);
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
