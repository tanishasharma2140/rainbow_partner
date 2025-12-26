import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_offer_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class DriverOfferViewModel with ChangeNotifier {
  final _driverOfferRepo = DriverOfferRepo();
  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> driverOfferApi(
      dynamic userIdOrder,
      dynamic orderId,
      dynamic offerAmount,
      dynamic estimatedAmount,
      BuildContext context,
      ) async {
    setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? userId = await userViewModel.getUser();

      Map data = {
        "user_id": userIdOrder,
        "driver_id": userId,
        "order_id": orderId,
        "offer_amount": offerAmount,
        "estimated_amount": estimatedAmount,
      };

      final response = await _driverOfferRepo.driverOfferApi(data);

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
