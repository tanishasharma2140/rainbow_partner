import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/repo/serviceman/add_bank_detail_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/wallet/cab_bank_detail_view.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class AddBankDetailViewModel with ChangeNotifier {
  final _addBankDetailRepo = AddBankDetailRepo();
  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> addBankDetailApi(
      dynamic type,
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
      "type": type,
      "bank_name": bankName,
      "account_number": accountNumber,
      "re_account_number": reAccountNumber,
      "account_holder_name": accountHolderName,
      "ifsc_code": ifscCode
    };
    try {
      final response = await _addBankDetailRepo.addBankDetailApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(context, body["message"]);
        print("lolololo");
        print(type);

        if (type == 1) {
          // 🔙 Type 1 → just pop
          Navigator.pop(context);
        } else if (type == 2) {
          // 🚀 Type 2 → go to BankDetailView
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const CabBankDetailView(),
            ),
          );
        }
      } else {
        if (kDebugMode) {
          print("❌ Error Status: $statusCode → $body");
        }
        Utils.showErrorMessage(context, body["message"]);
      }
    } catch (e) {
      if (kDebugMode) print("❌ Exception: $e");
      Utils.showErrorMessage(context, "Something went wrong");
    }
  }
}
