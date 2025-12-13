import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/service_bank_detail_model.dart';
import 'package:rainbow_partner/repo/serviceman/service_bank_detail_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class ServiceGetBankDetailViewModel with ChangeNotifier {
  final _serviceBankDetailRepo = ServiceBankDetailRepo();
  bool _loading = false;
  bool get loading => _loading;

  ServiceBankDetailModel? _serviceBankDetailModel;
  ServiceBankDetailModel? get serviceBankDetailModel => _serviceBankDetailModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setBankDetailModelData(ServiceBankDetailModel value) {
    _serviceBankDetailModel = value;
    notifyListeners();
  }

  Future<void> serviceBankDetailApi(context) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {"user_id": userId, "type": 1};
    try {
      final response = await _serviceBankDetailRepo.serviceBankDetailApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = ServiceBankDetailModel.fromJson(body);
        setBankDetailModelData(model);
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
