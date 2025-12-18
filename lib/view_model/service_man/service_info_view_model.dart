import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/service_info_model.dart';
import 'package:rainbow_partner/repo/serviceman/service_info_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class ServiceInfoViewModel with ChangeNotifier {
  final ServiceInfoRepo _serviceInfoRepo = ServiceInfoRepo();

  bool _loading = false;
  bool get loading => _loading;

  ServiceInfoModel? _serviceInfoModel;
  ServiceInfoModel? get serviceInfoModel => _serviceInfoModel;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setServiceInfoModelData(ServiceInfoModel value) {
    _serviceInfoModel = value;
    notifyListeners();
  }

  Future<void> serviceInfoApi(context) async {
    _setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? userId = await userViewModel.getUser();

      final Map<String, dynamic> data = {
        "serviceman_id": userId,
      };

      final response = await _serviceInfoRepo.serviceInfoApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        _setServiceInfoModelData(ServiceInfoModel.fromJson(body));
      } else {
        if (kDebugMode) {
          debugPrint("❌ Error Status: $statusCode → $body");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("❌ ServiceInfoViewModel Error → $e");
      }
      Utils.showErrorMessage(context, e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
