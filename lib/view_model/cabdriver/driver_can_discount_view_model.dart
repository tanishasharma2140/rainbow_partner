import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/repo/cabdriver/driver_can_discount_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';

class DriverCanDiscountViewModel with ChangeNotifier {
  final _driverCanDiscountRepo = DriverCanDiscountRepo();

  bool _loading = false;
  bool get loading => _loading;

  /// 🔥 IMPORTANT: discount value
  String? _driverDiscount;
  String? get driverDiscount => _driverDiscount;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  /// 🔹 DRIVER CAN DISCOUNT API
  Future<void> driverDiscountApi(
      dynamic vehicleId,
      dynamic amount,
      BuildContext context,
      ) async {
    setLoading(true);

    try {
      final Map<String, dynamic> data = {
        "vehicle_id": vehicleId,

        "amount": amount,
      };

      if (kDebugMode) {
        print("🚀 DRIVER CAN DISCOUNT API DATA → $data");
      }

      final response =
      await _driverCanDiscountRepo.driverDiscountApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body =
      Map<String, dynamic>.from(response['body'] ?? {});

      if (statusCode == 200 || statusCode == 201) {
        /// ✅ STORE DISCOUNT VALUE
        _driverDiscount = body['driver_can_discount'];

        if (kDebugMode) {
          print("✅ DRIVER CAN DISCOUNT → $_driverDiscount");
        }

        notifyListeners();
      } else {
        Utils.showErrorMessage(
          context,
          body['message'] ?? "Unable to fetch discount",
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ DriverCanDiscountViewModel Error → $e");
      }
      Utils.showErrorMessage(context, e.toString());
    } finally {
      setLoading(false);
    }
  }

  /// OPTIONAL: reset when new ride comes
  void clearDiscount() {
    _driverDiscount = null;
    notifyListeners();
  }
}

