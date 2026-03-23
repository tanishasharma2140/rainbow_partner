import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/vehicle_model.dart';
import 'package:rainbow_partner/repo/cabdriver/vehicle_repo.dart';

class VehicleViewModel with ChangeNotifier {
  final _vehicleRepo = VehicleRepo();

  bool _loading = false;
  bool get loading => _loading;

  VehicleModel? _vehicleModel;
  VehicleModel? get vehicleModel => _vehicleModel;

  int? _selectedVehicleId;
  String? _selectedVehicleName;
  dynamic _selectedVehicleCategory;

  int? get selectedVehicleId => _selectedVehicleId;
  String? get selectedVehicleName => _selectedVehicleName;
  dynamic get selectedVehicleCategory => _selectedVehicleCategory;


  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setVehicleModelData(VehicleModel value) {
    _vehicleModel = value;
    notifyListeners();
  }

  /// 🔥 SET SELECTED VEHICLE
  void setSelectedVehicle({
    required int vehicleId,
    required String vehicleName,
    required dynamic vehicleCategory,
  }) {
    _selectedVehicleId = vehicleId;
    _selectedVehicleName = vehicleName;
    _selectedVehicleCategory = vehicleCategory;
    notifyListeners();

    if (kDebugMode) {
      print("✅ Selected Vehicle ID: $_selectedVehicleId");
      print("✅ Selected Vehicle Name: $_selectedVehicleName");
      print("✅ Selected Vehicle Category: $_selectedVehicleCategory");
    }
  }

  // ---------------- API CALL ----------------
  Future<void> vehicleApi(dynamic data) async {
    setLoading(true);

    try {
      final response = await _vehicleRepo.vehicleApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = VehicleModel.fromJson(body);
        setVehicleModelData(model);
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
