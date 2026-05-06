import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/model/PaytmGatewayModel.dart';
import 'package:rainbow_partner/repo/cabdriver/cab_payment_repo.dart';
import 'package:rainbow_partner/repo/serviceman/payment_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/driver_home_page.dart';
import 'package:rainbow_partner/view/Service%20Man/home/handyman_dashboard.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class CabPaymentViewmodel with ChangeNotifier {
  CabPaymentViewmodel() {
    debugPrint("PaymentViewModel instance CREATED");
  }

  final _paymentRepo = CabPaymentRepo();
  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  /// Paytm config (default)
  bool isStaging = true;
  bool restrictAppInvoke = true;
  bool enableAssist = true;

  String result = '';

  PaytmGatewayModel? _paytmGatewayModel;

  PaytmGatewayModel? get paytmGatewayModel => _paytmGatewayModel;

  void setModelData(PaytmGatewayModel value) {
    _paytmGatewayModel = value;
    notifyListeners();
  }

  Future<void> cabPaymentApi(
      dynamic amount,
      dynamic paymentType,
      dynamic serviceOrderId,
      BuildContext context,
      ) async {

    setLoading(true);

    try {
      UserViewModel userViewModel = UserViewModel();
      String? userId = await userViewModel.getUser();

      final Map data = {
        "user_id": userId,
        "amount": amount,
        "payment_type": paymentType,
        "service_order_id": serviceOrderId,
      };
      print("🎉🍬");
      print(data);

      final response = await _paymentRepo.cabPaymentApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {

        if (body["status"] != true || body["data"] == null) {
          Utils.showErrorMessage(context, body["message"] ?? "Payment failed");
          return;
        }

        Utils.showSuccessMessage(context, body["message"]);

        final orderId = body["data"]["order_id"];
        final txnToken = body["data"]["txnToken"];
        // API response doesn't have amount, so use the amount passed to this function
        final amountValue = body["data"]["amount"] ?? amount;

        if (orderId == null || txnToken == null || amountValue == null) {
          Utils.showErrorMessage(context, "Payment details missing from server");
          return;
        }

        await _startPaytmTransaction(
          mid: "FAEClA31908078249088",
          orderId: orderId.toString(),
          txnToken: txnToken.toString(),
          amount: amountValue.toString(),
          paymentType: paymentType,
          serviceOrderId: serviceOrderId,
          callbackUrl: "https://dev.rainbowsenterprises.com/api/callback_paytm",
          context: context,
        );

      } else {
        Utils.showErrorMessage(context, body["message"] ?? "Server Error");
      }
    } catch (e) {
      Utils.showErrorMessage(context, e.toString());
    } finally {
      setLoading(false);
    }
  }

  /// ================= PAYTM SDK =================
  Future<void> _startPaytmTransaction({
    required String mid,
    required String orderId,
    required String txnToken,
    required String amount,
    required String callbackUrl,
    required BuildContext context,
    required dynamic paymentType,
    required dynamic serviceOrderId,
  }) async {
    try {
      // Use tryParse to avoid FormatException if amount is still not a valid number
      double? parsedAmount = double.tryParse(amount);
      if (parsedAmount == null) {
        Utils.showErrorMessage(context, "Invalid amount: $amount");
        return;
      }

      final formattedAmount = parsedAmount.toStringAsFixed(2);
      debugPrint("MID => $mid");
      debugPrint("ORDERID => $orderId");
      debugPrint("TXNTOKEN => $txnToken");
      debugPrint("AMOUNT => $formattedAmount");
      debugPrint("CALLBACK => $callbackUrl");
      debugPrint("IS STAGING => $isStaging");
      debugPrint("RESTRICT => $restrictAppInvoke");

      final response = await PaytmPaymentsAllinonesdk().startTransaction(
        mid,
        orderId,
        formattedAmount,
        txnToken,
        callbackUrl,
        isStaging,
        restrictAppInvoke,
        enableAssist,
      );

      debugPrint("PAYTM RESPONSE => $response");

      if (response != null &&
          response["STATUS"] == "TXN_SUCCESS") {

        Utils.showSuccessMessage(context, "Payment Successful");

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const DriverHomePage(),
          ),
              (route) => false,
        );

      } else {
        Utils.showErrorMessage(
          context,
          response?["RESPMSG"] ?? "Payment Failed",
        );
      }
    } on PlatformException catch (e) {
      Utils.showErrorMessage(context, e.message ?? "Payment Error");
    } catch (e) {
      Utils.showErrorMessage(context, e.toString());
    }
  }
}
