// import 'package:flutter/foundation.dart';
// import 'package:rainbow_partner/repo/cabdriver/delete_expired_order_repo.dart';
//
// class DeleteExpiredOrderViewModel with ChangeNotifier {
//   final _deleteExpiredOrderRepo = DeleteExpiredOrderRepo();
//
//   bool _loading = false;
//   bool get loading => _loading;
//
//   bool deleteSuccess = false; // 👈 NEW FLAG
//
//   void setLoading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }
//
//   Future<bool> deleteExpiredOrderApi() async {
//     setLoading(true);
//     deleteSuccess = false;
//
//     try {
//       final response = await _deleteExpiredOrderRepo.deleteExpiredOrderApi();
//
//       final int statusCode = response['statusCode'] ?? 0;
//
//       if (statusCode == 200 || statusCode == 201) {
//         deleteSuccess = true;
//         debugPrint("Old Order deleted successfully");
//       } else {
//         debugPrint("❌ Delete Error Status: $statusCode");
//       }
//     } catch (e) {
//       debugPrint("ViewModel Error → $e");
//     } finally {
//       setLoading(false);
//     }
//
//     notifyListeners();
//     return deleteSuccess;
//   }
// }
