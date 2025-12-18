import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/repo/serviceman/withdraw_request_repo.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/service_man/service_withdraw_history_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_profile_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class WithdrawRequestViewModel with ChangeNotifier {
  final _withdrawRequestRepo = WithdrawRequestRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> withdrawRequestApi(
      dynamic amount,
      BuildContext context,
      ) async {
    setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? userId = await userViewModel.getUser();

      Map<String, dynamic> data = {
        "serviceman_id": userId,
        "amount": amount,
      };

      if (kDebugMode) {
        print("🚀 WITHDRAW API DATA → $data");
      }

      final response = await _withdrawRequestRepo.withdrawRequestApi(data);
      final position = await LocationUtils.getLocation();

      final lat = position.latitude.toString();
      final lng = position.longitude.toString();
      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(context, body["message"]);
        if (context.mounted) {
          Provider.of<ServiceWithdrawHistoryViewModel>(
            context,
            listen: false,
          ).serviceWithdrawHistoryApi("", context);

          Provider.of<ServicemanProfileViewModel>(
            context,
            listen: false,
          ).servicemanProfileApi(lat , lng,context);
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
