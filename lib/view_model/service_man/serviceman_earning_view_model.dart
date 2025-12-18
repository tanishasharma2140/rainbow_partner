import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/serviceman_earning_model.dart';
import 'package:rainbow_partner/repo/serviceman/serviceman_earning_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class ServicemanEarningViewModel with ChangeNotifier {
  final ServicemanEarningRepo _servicemanEarningRepo = ServicemanEarningRepo();

  bool _loading = false;
  bool get loading => _loading;

  ServicemanEarningModel? _servicemanEarningModel;
  ServicemanEarningModel? get servicemanEarningModel => _servicemanEarningModel;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setEarningModelData(ServicemanEarningModel value) {
    _servicemanEarningModel = value;
    notifyListeners();
  }

  Future<void> servicemanEarningApi(context) async {
    _setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? userId = await userViewModel.getUser();

      final Map<String, dynamic> data = {
        "serviceman_id": userId,
      };

      final response = await _servicemanEarningRepo.servicemanEarningApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        _setEarningModelData(ServicemanEarningModel.fromJson(body));
      } else {
        if (kDebugMode) {
          debugPrint("❌ Error Status: $statusCode → $body");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("❌ ServicemanEarningViewModel Error → $e");
      }
      Utils.showErrorMessage(context, e.toString());
    } finally {
      _setLoading(false); // ✅ MOST IMPORTANT
    }
  }
}
