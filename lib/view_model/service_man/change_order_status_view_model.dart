import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/repo/serviceman/change_order_status_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/service_man/complete_booking_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class ChangeOrderStatusViewModel with ChangeNotifier {
  final _changeOrderStatusRepo = ChangeOrderStatusRepo();

  final Set<int> _loadingOrders = {};

  bool isLoading(int orderId) => _loadingOrders.contains(orderId);

  Future<void> changeOrderStatusApi(
      int orderId,
      int status,
      String otp,
      String cancelReason,
      context,
      ) async {
    /// ✅ add current order to loading
    _loadingOrders.add(orderId);
    notifyListeners();

    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();

    final Map<String, dynamic> data = {
      "user_id": userId,
      "order_id": orderId,
      "status": status,
      "type": 2,
      "otp": otp,
      "cancel_reason": cancelReason,
    };

    if (kDebugMode) {
      print("🚀 CHANGE STATUS API DATA → $data");
    }

    try {
      final response =
      await _changeOrderStatusRepo.changeOrderStatusApi(data);

      if (!context.mounted) return;

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(context, body["message"]);
        Provider.of<CompleteBookingViewModel>(context, listen: false)
            .completeBookingApi([1, 2, 3], context);
      } else {
        Utils.showErrorMessage(context, body["message"]);
      }
    } catch (e) {
      if (kDebugMode) print("❌ ViewModel Error → $e");
      if (context.mounted) {
        Utils.showErrorMessage(context, "$e");
      }
    } finally {
      /// ✅ remove order from loading
      _loadingOrders.remove(orderId);
      notifyListeners();
    }
  }
}
