import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/categories_model.dart';
import 'package:rainbow_partner/repo/cabdriver/delete_expired_order_repo.dart';
import 'package:rainbow_partner/repo/serviceman/categories_repo.dart';

class DeleteExpiredOrderViewModel with ChangeNotifier {
  final _deleteExpiredOrderRepo = DeleteExpiredOrderRepo();

  bool _loading = false;
  bool get loading => _loading;



  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> deleteExpiredOrderApi() async {
    setLoading(true);

    try {
      final response = await _deleteExpiredOrderRepo.deleteExpiredOrderApi();

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        debugPrint("Old Order deleted successfully");
      } else {
        if (kDebugMode) print("❌ Error Status: $statusCode → $body");
      }
    } catch (e) {
      if (kDebugMode) print("ViewModel Error → $e");
    } finally {
      setLoading(false);
    }
  }
}
