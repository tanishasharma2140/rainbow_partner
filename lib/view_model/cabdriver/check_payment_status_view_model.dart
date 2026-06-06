  import 'package:flutter/cupertino.dart';
  import 'package:provider/provider.dart' show Provider;
  import 'package:rainbow_partner/repo/cabdriver/check_payment_status_repo.dart';
  import 'package:rainbow_partner/utils/utils.dart';
  import 'package:rainbow_partner/view_model/cabdriver/change_cab_order_status_view_model.dart';

  class CheckPaymentStatusViewModel with ChangeNotifier {
    final _checkPaymentStatusRepo = CheckPaymentStatusRepo();

    bool _loading = false;
    bool get loading => _loading;

    void setLoading(bool value) {
      _loading = value;
      notifyListeners();
    }

    Future<void> checkPaymentStatusApi(
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


        final response = await _checkPaymentStatusRepo.checkPaymentStatusApi(data);

        if (!context.mounted) return;

        final cabOrderStatusVm =
        Provider.of<ChangeCabOrderStatusViewModel>(
          context,
          listen: false,
        );

        final int statusCode = response['statusCode'] ?? 0;
        final Map<String, dynamic> body = response['body'] ?? {};
        final serviceOrder = body["service_order_id"];

        if ((statusCode == 200 || statusCode == 201)) {
          cabOrderStatusVm.changeCabOrderApi(serviceOrder, 3, "", "", context) ;
          Navigator.pop(context);
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
