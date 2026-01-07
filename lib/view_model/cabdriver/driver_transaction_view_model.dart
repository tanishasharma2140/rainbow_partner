import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/driver_transaction_model.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_transaction_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class DriverTransactionViewModel with ChangeNotifier {
  final _driverTransactionRepo = DriverTransactionRepo();
  bool _loading = false;
  bool get loading => _loading;

  DriverTransactionsModel? _driverTransactionsModel;
  DriverTransactionsModel? get driverTransactionsModel => _driverTransactionsModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setDriverTransactionModelData(DriverTransactionsModel value) {
    _driverTransactionsModel = value;
    notifyListeners();
  }

  Future<void> driverTransactionApi(context) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? driverId = await userViewModel.getUser();
    Map data = {
      "driver_id": driverId
    };
    try {
      final response = await _driverTransactionRepo.driverTransactionApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = DriverTransactionsModel.fromJson(body);
        setDriverTransactionModelData(model);
        debugPrint(body["message"]);
      } else {
        if (kDebugMode) print("❌ Error Status: $statusCode → $body");
        Utils.showErrorMessage(context, body["message"]);
      }
    } catch (e) {
      if (kDebugMode) print("ViewModel Error → $e");
      Utils.showErrorMessage(context, "$e");
    } finally {
      setLoading(false);
    }
  }
}
