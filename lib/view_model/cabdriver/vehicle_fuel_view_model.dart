import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/vehicle_fuel_model.dart';
import 'package:rainbow_partner/repo/cabdriver/vehicle_fuel_repo.dart';

class VehicleFuelViewModel with ChangeNotifier {
  final _vehicleFuelRepo = VehicleFuelRepo();

  bool _loading = false;
  bool get loading => _loading;

  VehicleFuelModel? _vehicleFuelModel;
  VehicleFuelModel? get vehicleFuelModel => _vehicleFuelModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setVehicleFuelModelData(VehicleFuelModel value) {
    _vehicleFuelModel = value;
    notifyListeners();
  }

  Future<void> vehicleFuelApi(dynamic data) async {
    setLoading(true);

    try {
      final response = await _vehicleFuelRepo.vehicleFuelApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = VehicleFuelModel.fromJson(body);
        setVehicleFuelModelData(model);
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
