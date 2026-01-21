import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/cab_cancel_reason_model.dart';
import 'package:rainbow_partner/repo/cabdriver/cab_cancel_reason_repo.dart';

class CabCancelReasonViewModel with ChangeNotifier {
  final _cabCancelReasonRepo = CabCancelReasonRepo();

  bool _loading = false;
  bool get loading => _loading;

  CabCancelReasonModel? _cabCancelReasonModel;
  CabCancelReasonModel? get cabCancelReasonModel => _cabCancelReasonModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setCabCancelModelData(CabCancelReasonModel value) {
    _cabCancelReasonModel = value;
    notifyListeners();
  }

  Future<void> cabCancelReasonApi(String type) async {
    setLoading(true);

    try {
      final response = await _cabCancelReasonRepo.cabCancelReasonApi(type);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = CabCancelReasonModel.fromJson(body);
        setCabCancelModelData(model);
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
