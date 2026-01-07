import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/cab_history_model.dart';
import 'package:rainbow_partner/repo/cabdriver/cab_history_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class CabHistoryViewModel with ChangeNotifier {
  final _cabHistoryRepo = CabHistoryRepo();

  bool _loading = false;
  bool get loading => _loading;

  CabHistoryModel? _cabHistoryModel;
  CabHistoryModel? get cabHistoryModel => _cabHistoryModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setCabHistoryModelData(CabHistoryModel value) {
    _cabHistoryModel = value;
    notifyListeners();
  }

  Future<void> cabHistoryApi(dynamic orderType,context) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? driverId = await userViewModel.getUser();
    Map data = {
      "user_type": 2, // 1 pe user 2 pe driver
      "driver_id": driverId,
      "order_type": orderType, // 1 pe now 2 pe later
      "order_status": [5, 6, 8]
    };
    try {
      final response = await _cabHistoryRepo.cabHistoryApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = CabHistoryModel.fromJson(body);
        setCabHistoryModelData(model);
        debugPrint(body["message"]);
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
