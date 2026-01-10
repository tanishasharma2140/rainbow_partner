import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/driver_withdraw_history_model.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_withdraw_history_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class DriverWithdrawHistoryViewModel with ChangeNotifier {
  final DriverWithdrawHistoryRepo _driverWithdrawHistoryRepo = DriverWithdrawHistoryRepo();

  bool _loading = false;
  bool get loading => _loading;

  DriverWithdrawHistoryModel? _driverWithdrawHistoryModel;
  DriverWithdrawHistoryModel? get driverWithdrawHistoryModel => _driverWithdrawHistoryModel;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setDriverWithdrawHistoryModelData(DriverWithdrawHistoryModel value) {
    _driverWithdrawHistoryModel = value;
    notifyListeners();
  }

  Future<void> driverWithdrawHistoryApi(dynamic status,context) async {
    _setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? driverId = await userViewModel.getUser();

      final Map<String, dynamic> data = {
        "driver_id": driverId,
        "status": status // 0 pending 1 success 2 reject
      };

      if (kDebugMode) {
        debugPrint("🚀 WALLET HISTORY API DATA → $data");
      }

      final response = await _driverWithdrawHistoryRepo.driverWithdrawHistoryApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        _setDriverWithdrawHistoryModelData(DriverWithdrawHistoryModel.fromJson(body));
      } else {
        if (kDebugMode) {
          debugPrint("❌ Error Status: $statusCode → $body");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("❌ WithdrawHistoryViewModel Error → $e");
      }
      Utils.showErrorMessage(context, e.toString());
    } finally {
      _setLoading(false); // ✅ MOST IMPORTANT
    }
  }
}
