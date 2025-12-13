import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/model/service_bank_update_model.dart';
import 'package:rainbow_partner/repo/serviceman/service_bank_update_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class ServiceBankUpdateViewModel with ChangeNotifier {
  final _serviceBankUpdateRepo = ServiceBankUpdateRepo();
  bool _loading = false;
  bool get loading => _loading;

  ServiceBankUpdateModel? _serviceBankUpdateModel;
  ServiceBankUpdateModel? get serviceBankUpdateModel => _serviceBankUpdateModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setBankBankUpdateModelData(ServiceBankUpdateModel value) {
    _serviceBankUpdateModel = value;
    notifyListeners();
  }

  Future<void> serviceBankUpdateApi(context) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {"user_id": userId, "type": 1};
    try {
      final response = await _serviceBankUpdateRepo.serviceBankUpdateApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = ServiceBankUpdateModel.fromJson(body);
        setBankBankUpdateModelData(model);
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
