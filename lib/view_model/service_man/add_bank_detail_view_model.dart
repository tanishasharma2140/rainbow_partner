import 'dart:convert';
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
      BuildContext context,
      ) async {
    setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? userId = await userViewModel.getUser();

      Map data = {
        "user_id": userId,
        "type": type,
        "bank_name": bankName,
        "account_number": accountNumber,
        "re_account_number": reAccountNumber,
        "account_holder_name": accountHolderName,
        "ifsc_code": ifscCode,
      };

      final response = await _addBankDetailRepo.addBankDetailApi(data);

      final int statusCode = response['statusCode'] ?? 0;

      /// ✅ FIX: Proper body parsing
      final body = response['body'] is String
          ? jsonDecode(response['body'])
          : response['body'] ?? {};

      final message = body["message"]?.toString() ?? "Something went wrong";

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(context, message);

        /// ✅ tumhara type logic same rakha
        if (type == 1) {
          Navigator.pop(context);
        } else if (type == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CabBankDetailView()),
          );
        }
      } else {
        /// ✅ API ka exact message show hoga
        Utils.showErrorMessage(context, message);

        if (kDebugMode) {
          print("❌ Error Status: $statusCode → $body");
        }
      }
    } catch (e) {
      if (kDebugMode) print("❌ Exception: $e");

      String errorMessage = e.toString();

      if (errorMessage.contains("Exception:")) {
        errorMessage = errorMessage.replaceAll("Exception: ", "");
      }

      Utils.showErrorMessage(
        context,
        errorMessage.isNotEmpty ? errorMessage : "Something went wrong",
      );
    } finally {
      setLoading(false);
    }
  }
}