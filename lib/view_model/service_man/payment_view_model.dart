import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/model/cash_free_gateway_model.dart';
import 'package:rainbow_partner/repo/serviceman/payment_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/cashfree_payment_screen.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';


class PaymentViewModel with ChangeNotifier {
  final _paymentRepo = PaymentRepo();
  bool _loading = false;
  bool get loading => _loading;

  CashFreeGatewayModel? _cashFreeGatewayModel;
  CashFreeGatewayModel? get cashFreeGatewayModel => _cashFreeGatewayModel;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setModelData(CashFreeGatewayModel value) {
    _cashFreeGatewayModel = value;
    notifyListeners();
  }

  Future<void> paymentApi(
      dynamic amount,
      dynamic paymentType,
      dynamic serviceOrderId,
      context,
      ) async {
    setLoading(true);
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {
      "user_id": userId,
      "amount": amount,
      "payment_type": paymentType,
      "service_order_id": serviceOrderId,
      "gateway_type": 1,
    };
    try {
      final response = await _paymentRepo.paymentApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        final model = CashFreeGatewayModel.fromJson(body);
        setModelData(model);
        Utils.showSuccessMessage(context, body["message"]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CashFreePaymentScreen(data: model, amount: amount.toString(),
                  // paymentType: paymentType.toString(),
                ),
          ),
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
