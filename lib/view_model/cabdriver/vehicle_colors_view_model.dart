import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/vehicle_colors_model.dart';
import 'package:rainbow_partner/repo/cabdriver/vehicle_colors_repo.dart';

class VehicleColorsViewModel with ChangeNotifier {
  final _vehicleColorsRepo = VehicleColorsRepo();

  bool _loading = false;
  bool get loading => _loading;

  VehicleColorsModel? _vehicleColorsModel;
  VehicleColorsModel? get vehicleColorsModel => _vehicleColorsModel;


  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setVehicleColorsModelData(VehicleColorsModel value) {
    _vehicleColorsModel = value;
    notifyListeners();
  }

  // ---------------- API CALL ----------------
  Future<void> vehicleColorsApi(dynamic data) async {
    setLoading(true);

    try {
      final response = await _vehicleColorsRepo.vehicleColorsApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = VehicleColorsModel.fromJson(body);
        setVehicleColorsModelData(model);
      } else {
        if (kDebugMode) {
          print("❌ Error Status: $statusCode → $body");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ ViewModel Error → $e");
      }
    } finally {
      setLoading(false);
    }
  }
}
