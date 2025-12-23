import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_can_discount_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';

class DriverCanDiscountViewModel with ChangeNotifier {
  final _driverCanDiscountRepo = DriverCanDiscountRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> driverDiscountApi(
      dynamic vehicleId,
      dynamic amount,
      BuildContext context,
      ) async {
    setLoading(true);

    try {

      final Map data = {
        "vehicle_id": vehicleId,
        "amount": amount
      }
      ;

      if (kDebugMode) {
        print("🚀 SAVE ADDRESS API DATA → $data");
      }

      final response = await _driverCanDiscountRepo.driverDiscountApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(context, body["message"]);
      } else {
        Utils.showErrorMessage(context, body["message"]);
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ SaveAddressViewModel Error → $e");
      }
      Utils.showErrorMessage(context, e.toString());
    } finally {
      setLoading(false);
    }
  }
}

