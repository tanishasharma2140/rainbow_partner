import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/categories_model.dart';
import 'package:rainbow_partner/repo/serviceman/categories_repo.dart';

class CategoriesViewModel with ChangeNotifier {
  final _categoriesRepo = CategoriesRepo();

  bool _loading = false;
  bool get loading => _loading;

  CategoriesModel? _categoriesModel;
  CategoriesModel? get categoriesModel => _categoriesModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setCategoriesModelData(CategoriesModel value) {
    _categoriesModel = value;
    notifyListeners();
  }

  Future<void> categoriesApi() async {
    setLoading(true);

    try {
      final response = await _categoriesRepo.categoriesApi();

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = CategoriesModel.fromJson(body);
        setCategoriesModelData(model);
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
