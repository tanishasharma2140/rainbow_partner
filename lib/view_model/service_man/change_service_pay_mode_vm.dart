import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/repo/serviceman/change_service_pay_mode_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';

class ChangeServicePayModeVm with ChangeNotifier {
  final _changePayModeRepo = ChangeServicePayModeRepo();

  final Set<int> _loadingOrders = {};

  bool isLoading(int orderId) => _loadingOrders.contains(orderId);

  Future<void> changePayModeApi(
      dynamic serviceOrderId,
      dynamic payMode,
      context,
      ) async {
    /// ✅ add current order to loading
    _loadingOrders.add(serviceOrderId);
    notifyListeners();



    final Map<String, dynamic> data = {
      "service_order_id": serviceOrderId,
      "pay_mode": payMode
    }
    ;

    if (kDebugMode) {
      print("🚀 CHANGE STATUS API DATA → $data");
    }

    try {
      final response =
      await _changePayModeRepo.changePayModeApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(context, body["message"]);
        Navigator.pop(context);
      } else {
        Utils.showErrorMessage(context, body["message"]);
      }
    } catch (e) {
      if (kDebugMode) print("❌ ViewModel Error → $e");
      Utils.showErrorMessage(context, "$e");
    } finally {
      /// ✅ remove order from loading
      _loadingOrders.remove(serviceOrderId);
      notifyListeners();
    }
  }
}

