import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/service_withdraw_history_model.dart';
import 'package:rainbow_partner/repo/serviceman/service_withdraw_history_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class ServiceWithdrawHistoryViewModel with ChangeNotifier {
  final ServiceWithdrawHistoryRepo _serviceWithdrawHistoryRepo = ServiceWithdrawHistoryRepo();

  bool _loading = false;
  bool get loading => _loading;

  ServiceWithdrawHistoryModel? _serviceWithdrawHistoryModel;
  ServiceWithdrawHistoryModel? get serviceWithdrawHistoryModel => _serviceWithdrawHistoryModel;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setWithdrawHistoryModelData(ServiceWithdrawHistoryModel value) {
    _serviceWithdrawHistoryModel = value;
    notifyListeners();
  }

  Future<void> serviceWithdrawHistoryApi(dynamic status,context) async {
    _setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? userId = await userViewModel.getUser();

      final Map<String, dynamic> data = {
        "serviceman_id": userId,
        "status": status // 0 pending 1 success 2 reject
      };

      if (kDebugMode) {
        debugPrint("🚀 WALLET HISTORY API DATA → $data");
      }

      final response = await _serviceWithdrawHistoryRepo.serviceWithdrawHistoryApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        _setWithdrawHistoryModelData(ServiceWithdrawHistoryModel.fromJson(body));
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
