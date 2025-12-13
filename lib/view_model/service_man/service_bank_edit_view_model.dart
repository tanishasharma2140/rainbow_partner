import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/repo/serviceman/service_bank_edit_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Service%20Man/home/handyman_dashboard.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class ServiceBankEditViewModel with ChangeNotifier {
  final _serviceBankEditRepo = ServiceBankEditRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> serviceBankEditApi(
    dynamic bankName,
    dynamic accountNumber,
    dynamic reAccountNumber,
    dynamic accountHolderName,
    dynamic ifscCode,
    context,
  ) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {
      "user_id": userId,
      "type": 1,
      "bank_name": bankName,
      "account_number": accountNumber,
      "re_account_number": reAccountNumber,
      "account_holder_name": accountHolderName,
      "ifsc_code": ifscCode,
    };
    try {
      final response = await _serviceBankEditRepo.serviceBankEditApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(context, body["message"]);
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => HandymanDashboard()),
              (route) => false,
        );
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
