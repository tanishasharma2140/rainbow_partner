import 'package:flutter/cupertino.dart';
import 'package:rainbow_partner/repo/cabdriver/change_pay_mode_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class ChangeCabPayModeViewModel with ChangeNotifier {
  final _changeCabPayModeRepo = ChangeCabPayModeRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> changeCabPayModeApi(
      dynamic orderId,
      dynamic payMode,
      BuildContext context,
      ) async {
    setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? driverId = await userViewModel.getUser();

      Map data = {
        "order_id": orderId,
        "driver_id": driverId,
        "pay_mode": payMode
      };
      print("😒😒😍😍");
      print(data);


      final response = await _changeCabPayModeRepo.changeCabPayModeApi(data);

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
