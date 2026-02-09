import 'package:flutter/cupertino.dart';
import 'package:rainbow_partner/repo/serviceman/ignore_service_order_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class IgnoreServiceOrderViewModel with ChangeNotifier {
  final _ignoreServiceOrderRepo = IgnoreServiceOrderRepo();

  /// 🔥 per-order loading tracker
  final Set<int> _loadingOrderIds = {};

  bool loading(int orderId) => _loadingOrderIds.contains(orderId);

  Future<void> ignoreServiceOrderApi(
      int orderId,
      BuildContext context,
      ) async {
    if (_loadingOrderIds.contains(orderId)) return;

    _loadingOrderIds.add(orderId);
    notifyListeners();

    try {
      UserViewModel userViewModel = UserViewModel();
      String? servicemanId = await userViewModel.getUser();

      if (servicemanId == null || servicemanId.isEmpty) {
        throw Exception("Serviceman ID not found");
      }

      final Map<String, dynamic> data = {
        "order_id": orderId,
        "serviceman_id": servicemanId,
      };

      final response =
      await _ignoreServiceOrderRepo.ignoreServiceOrderApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body =
      Map<String, dynamic>.from(response['body'] ?? {});

      if (statusCode == 200 || statusCode == 201) {
        if (context.mounted) {
          debugPrint("❌ IGNORE SUCCESS → ${body["message"]}");
          // Utils.showSuccessMessage(context, body["message"]);
        }
      } else {
        if (context.mounted) {
          Utils.showErrorMessage(context, body["message"] ?? "Something went wrong");
        }
      }
    } catch (e) {
      if (context.mounted) {
        Utils.showErrorMessage(context, e.toString());
      }
    } finally {
      _loadingOrderIds.remove(orderId);
      notifyListeners();
    }
  }
}
