import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/cab_earning_model.dart';
import 'package:rainbow_partner/repo/cabdriver/cab_earning_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class CabEarningViewModel with ChangeNotifier {
  final _cabEarningRepo = CabEarningRepo();
  bool _loading = false;
  bool get loading => _loading;

  CabEarningModel? _cabEarningModel;
  CabEarningModel? get cabEarningModel => _cabEarningModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setCabDriverModelData(CabEarningModel value) {
    _cabEarningModel = value;
    notifyListeners();
  }

  Future<void> cabEarningApi(
    dynamic type,
    context,
  ) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? driverId = await userViewModel.getUser();
    Map data = {
      "driver_id": driverId,
      "type": type
    };
    try {
      final response = await _cabEarningRepo.cabEarningApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = CabEarningModel.fromJson(body);
        setCabDriverModelData(model);
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
