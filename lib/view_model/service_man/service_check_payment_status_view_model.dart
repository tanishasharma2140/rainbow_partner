import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:rainbow_partner/repo/cabdriver/check_payment_status_repo.dart';
import 'package:rainbow_partner/repo/serviceman/service_check_payment_status_repo.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/cabdriver/change_cab_order_status_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/change_order_status_view_model.dart';

import 'complete_booking_view_model.dart';

class ServiceCheckPaymentStatusViewModel with ChangeNotifier {
  final _checkPaymentStatusRepo = ServiceCheckPaymentStatusRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> serviceCheckPaymentStatusApi(
      dynamic orderId,
      dynamic serviceOrderId,
      BuildContext context,
      ) async {
    setLoading(true);

    try {

      Map data = {
        "order_id": orderId,
        "service_order_id" : serviceOrderId,
      };
      print("😒😒😍😍");
      print(data);


      final response = await _checkPaymentStatusRepo.serviceCheckPaymentStatusApi(data);

      if (!context.mounted) return;

      final changeOrderVm =
      Provider.of<ChangeOrderStatusViewModel>(
        context,
        listen: false,
      );

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};
      final serviceOrder = body["service_order_id"];

      if ((statusCode == 200 || statusCode == 201)) {
        changeOrderVm.changeOrderStatusApi(serviceOrder, 3, "", "", context);
        Navigator.pop(context);

        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) {
            showPaymentReceivedDialog(context);
          }
        });
        // Utils.showSuccessMessage(context, body["message"]);
      } else {
        // if (context.mounted) {
        //   Utils.showErrorMessage(context, body["message"]);
        // }
      }
    } catch (e) {
      if (context.mounted) {
        Utils.showErrorMessage(context, e.toString());
      }
    } finally {
      setLoading(false);
    }
  }

}

void showPaymentReceivedDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 25,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade300,
                        Colors.green.shade600,
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  "Payment Received",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Customer payment has been received successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 24),

                GestureDetector(
                  onTap: () async {
                    Navigator.of(dialogContext).pop(); // only OK closes

                    await Future.delayed(
                      const Duration(milliseconds: 200),
                    );

                    Provider.of<CompleteBookingViewModel>(
                      context,
                      listen: false,
                    ).completeBookingApi([1, 2, 3], context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade400,
                          Colors.green.shade700,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}