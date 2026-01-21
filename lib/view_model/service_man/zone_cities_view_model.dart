import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/zone_cities_model.dart';
import 'package:rainbow_partner/repo/serviceman/zone_cities_repo.dart';

class ZoneCitiesViewModel with ChangeNotifier {
  final _zoneCitiesRepo = ZoneCitiesRepo();

  bool _loading = false;
  bool get loading => _loading;

  ZoneCitiesModel? _zoneCitiesModel;
  ZoneCitiesModel? get zoneCitiesModel => _zoneCitiesModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setZoneCitiesModelData(ZoneCitiesModel value) {
    _zoneCitiesModel = value;
    notifyListeners();
  }

  Future<void> zoneCitiesApi() async {
    setLoading(true);

    try {
      final response = await _zoneCitiesRepo.zoneCitiesApi();

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = ZoneCitiesModel.fromJson(body);
        setZoneCitiesModelData(model);
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
