import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/repo/serviceman/accept_order_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Service%20Man/home/accepted_booking.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class AcceptOrderViewModel with ChangeNotifier {
  final _acceptOrderRepo = AcceptOrderRepo();

  /// 🔥 Per-order loading tracker
  final Set<int> _loadingOrders = {};

  /// Check if specific order is loading
  bool isLoading(int orderId) => _loadingOrders.contains(orderId);

  Future<void> acceptOrderApi(
      int orderId,
      dynamic distance,
      context,
      ) async {
    /// ✅ Add order to loading set
    _loadingOrders.add(orderId);
    notifyListeners();

    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();

    Map<String, dynamic> data = {
      "order_id": orderId,
      "serviceman_id": userId,
      "distance" : distance
    };

    if (kDebugMode) {
      print("🚀 ACCEPT ORDER API DATA → $data");
    }

    try {
      final response = await _acceptOrderRepo.acceptOrderApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(context, body["message"]);
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> AcceptedBooking()));
      } else {
        if (kDebugMode) {
          print("❌ Error Status: $statusCode → $body");
        }
        Utils.showErrorMessage(context, body["message"]);
      }
    } catch (e) {
      if (kDebugMode) print("❌ ViewModel Error → $e");
      Utils.showErrorMessage(context, "$e");
    } finally {
      /// ✅ Remove order from loading set
      _loadingOrders.remove(orderId);
      notifyListeners();
    }
  }
}
