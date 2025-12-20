import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/vehicle_brand_model.dart';
import 'package:rainbow_partner/repo/cabdriver/vehicle_brand_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';

class VehicleBrandViewModel with ChangeNotifier {
  final _vehicleBrandRepo = VehicleBrandRepo();
  bool _loading = false;
  bool get loading => _loading;

  VehicleBrandModel? _vehicleBrandModel;
  VehicleBrandModel? get vehicleBrandModel => _vehicleBrandModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setVehicleBrandModelData(VehicleBrandModel value) {
    _vehicleBrandModel = value;
    notifyListeners();
  }

  Future<void> vehicleBrandApi(dynamic vehicleId,context) async {
    setLoading(true);
    Map data = {"vehicle_id": vehicleId};
    try {
      final response = await _vehicleBrandRepo.vehicleBrandApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = VehicleBrandModel.fromJson(body);
        setVehicleBrandModelData(model);
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
