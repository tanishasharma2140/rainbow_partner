import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/city_model.dart';
import 'package:rainbow_partner/repo/serviceman/city_repo.dart';

class CitiesViewModel with ChangeNotifier {
  final _cityRepo = CityRepo();

  bool _loading = false;
  bool get loading => _loading;

  CityModel? _cityModel;
  CityModel? get cityModel => _cityModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setCityModelData(CityModel value) {
    _cityModel = value;
    notifyListeners();
  }

  Future<void> cityApi() async {
    setLoading(true);

    try {
      final response = await _cityRepo.cityApi();

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = CityModel.fromJson(body);
        setCityModelData(model);
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
