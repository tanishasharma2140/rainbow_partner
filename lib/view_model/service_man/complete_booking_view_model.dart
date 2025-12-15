import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/complete_booking_model.dart';
import 'package:rainbow_partner/repo/serviceman/complete_booking_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class CompleteBookingViewModel with ChangeNotifier {
  final _completeBookingRepo = CompleteBookingRepo();
  bool _loading = false;
  bool get loading => _loading;

  CompleteBookingModel? _completeBookingModel;
  CompleteBookingModel? get completeBookingModel => _completeBookingModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setCompleteBookingModelData(CompleteBookingModel value) {
    _completeBookingModel = value;
    notifyListeners();
  }

  Future<void> completeBookingApi(dynamic serviceStatus, context) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {
      "serviceman_id": userId,
      "type": 2,
      "service_status": serviceStatus
    };
    try {
      final response = await _completeBookingRepo.completeBookingApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = CompleteBookingModel.fromJson(body);
        setCompleteBookingModelData(model);
        Utils.showSuccessMessage(context, body["message"]);
      } else {
        if (kDebugMode) print("❌ Error Status: $statusCode → $body");
        Utils.showErrorMessage(context, body["message"]);
      }

    } catch (e) {
      if (kDebugMode) print("ViewModel Error → $e");
      Utils.showErrorMessage(context,"$e");
    } finally {
      setLoading(false);
    }
  }
}
