import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/transaction_history_model.dart';
import 'package:rainbow_partner/repo/serviceman/transaction_history_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class TransactionHistoryViewModel with ChangeNotifier {
  final TransactionHistoryRepo _transactionHistoryRepo = TransactionHistoryRepo();

  bool _loading = false;
  bool get loading => _loading;

  TransactionHistoryModel? _transactionHistoryModel;
  TransactionHistoryModel? get transactionHistoryModel => _transactionHistoryModel;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setTransactionModelData(TransactionHistoryModel value) {
    _transactionHistoryModel = value;
    notifyListeners();
  }

  Future<void> transactionApi(dynamic type,context) async {
    _setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? userId = await userViewModel.getUser();

      final Map<String, dynamic> data = {
        "serviceman_id": userId,
        "type": type
      };

      if (kDebugMode) {
        debugPrint("🚀 WALLET HISTORY API DATA → $data");
      }

      final response = await _transactionHistoryRepo.transactionApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        _setTransactionModelData(TransactionHistoryModel.fromJson(body));
      } else {
        if (kDebugMode) {
          debugPrint("❌ Error Status: $statusCode → $body");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("❌ WalletHistoryViewModel Error → $e");
      }
      Utils.showErrorMessage(context, e.toString());
    } finally {
      _setLoading(false); // ✅ MOST IMPORTANT
    }
  }
}
