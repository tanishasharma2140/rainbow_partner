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

  void clearEarningData() {
    _cabEarningModel = null;
    notifyListeners();
  }

  Future<void> cabEarningApi(dynamic type, context) async {
    setLoading(true);

    UserViewModel userViewModel = UserViewModel();
    String? driverId = await userViewModel.getUser();

    if (driverId == null || driverId.isEmpty) {
      setLoading(false);
      Utils.showErrorMessage(context, "Driver not logged in");
      return;
    }

    Map<String, dynamic> data = {
      "driver_id": driverId,
      "type": type.toString(),
    };

    try {
      final response = await _cabEarningRepo.cabEarningApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = CabEarningModel.fromJson(body);
        setCabDriverModelData(model);
      } else {
        Utils.showErrorMessage(context, body["message"] ?? "Something went wrong");
      }
    } catch (e) {
      print("error: ${e.toString()}");
    } finally {
      setLoading(false);
    }
  }

}
