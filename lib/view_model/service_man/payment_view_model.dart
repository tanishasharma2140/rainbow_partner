import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paytmpayments_allinonesdk/paytmpayments_allinonesdk.dart';
import 'package:rainbow_partner/model/PaytmGatewayModel.dart';
import 'package:rainbow_partner/repo/serviceman/payment_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/driver_home_page.dart';
import 'package:rainbow_partner/view/Service%20Man/home/handyman_dashboard.dart';
import 'package:rainbow_partner/view/Service%20Man/service_qr_screen.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class PaymentViewModel with ChangeNotifier {
  PaymentViewModel() {
    debugPrint("PaymentViewModel instance CREATED");
  }

  final _paymentRepo = PaymentRepo();
  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  /// Paytm config (default)
  bool isStaging = false;
  bool restrictAppInvoke = false;
  bool enableAssist = true;

  String result = '';

  PaytmGatewayModel? _paytmGatewayModel;

  PaytmGatewayModel? get paytmGatewayModel => _paytmGatewayModel;

  void setModelData(PaytmGatewayModel value) {
    _paytmGatewayModel = value;
    notifyListeners();
  }

  Future<void> paymentApi(
      dynamic userId,
      dynamic amount,
      dynamic qrStatus,
      dynamic paymentType,
      dynamic serviceOrderId,
      BuildContext context,
      ) async {

    setLoading(true);

    try {


      final Map data = {
        "user_id": userId,
        "amount": amount,
        "qr_status" : qrStatus,
        "payment_type": paymentType,
        "service_order_id": serviceOrderId,
      };
      print("🎉🍬");
      print(data);

      final response = await _paymentRepo.paymentApi(data);

      if (!context.mounted) return;

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
        
        // FIX: API response doesn't have 'amount', so use the parameter 'amount'
        final amountValue = body["data"]["amount"] ?? amount;
        final qrStatusResponse = body["data"]["qr_status"];
        final qrImage = body["data"]["qrImage"];
        final price = body["data"]["amount"];
        final qrOrderId = body["data"]["order_id"];


        print("✅ QR STATUS = $qrStatusResponse");

        if (qrStatusResponse == 1 && qrImage != null) {

          print("✅ NAVIGATE TO QR SCREEN");
          print("📦 QR IMAGE = $qrImage");
          print("💰 AMOUNT = $price");
          print("🆔 ORDER ID = $qrOrderId");
          print("🚕 SERVICE ORDER ID = $serviceOrderId");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ServiceQrScreen(
                  qrImage: qrImage,
                  amount : price,
                  orderId :qrOrderId,
                  serviceOrderId : serviceOrderId
              ),
            ),
          );

          return;
        }

        if (orderId == null || txnToken == null || amountValue == null) {
          Utils.showErrorMessage(context, "Payment details missing from server");
          return;
        }

        await _startPaytmTransaction(
          mid: "RAINBO51441000273277",
          orderId: orderId.toString(),
          txnToken: txnToken.toString(),
          amount: amountValue.toString(),
          paymentType: paymentType,
          serviceOrderId: serviceOrderId,
          callbackUrl: "https://admin.rainbowsenterprises.com/api/callback_paytm",
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
      // FIX: double.parse("null") throws FormatException, use tryParse instead
      double? parsedAmount = double.tryParse(amount);
      if (parsedAmount == null) {
        Utils.showErrorMessage(context, "Invalid amount format: $amount");
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

      if (!context.mounted) return;

      debugPrint("PAYTM RESPONSE => $response");

      if (response != null && response["STATUS"] == "TXN_SUCCESS") {
        Utils.showSuccessMessage(context, "Payment Successful");

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HandymanDashboard()),
              (route) => false,
        );
      } else {
        /// ❌ FAILED
        Utils.showErrorMessage(
          context,
          response?["RESPMSG"] ?? "Payment Failed",
        );
      }
    } on PlatformException catch (e) {
      if (context.mounted) {
        Utils.showErrorMessage(context, e.message ?? "Payment Error");
      }
    } catch (e) {
      if (context.mounted) {
        Utils.showErrorMessage(context, e.toString());
      }
    }
  }
}
