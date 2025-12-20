import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/vehicle_same_model.dart';
import 'package:rainbow_partner/repo/cabdriver/vehicle_model_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';

class VehicleModelViewModel with ChangeNotifier {
  final _vehicleModelRepo = VehicleModelRepo();
  bool _loading = false;
  bool get loading => _loading;

  VehicleSameModel? _vehicleSameModel;
  VehicleSameModel? get vehicleSameModel => _vehicleSameModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setVehicleSameModelData(VehicleSameModel value) {
    _vehicleSameModel = value;
    notifyListeners();
  }

  Future<void> vehicleModelApi(dynamic brandId,context) async {
    setLoading(true);
    Map data = {"brand_id": brandId};
    try {
      final response = await _vehicleModelRepo.vehicleModelApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = VehicleSameModel.fromJson(body);
        setVehicleSameModelData(model);
        Utils.showSuccessMessage(context, body["message"]);
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
