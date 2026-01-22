import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/repo/serviceman/call_back_repo.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/driver_home_page.dart';
import 'package:rainbow_partner/view/Service%20Man/home/handyman_dashboard.dart';

class CallBackViewModel with ChangeNotifier {
  final _callbackRepo = CallbackRepo();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> callBackApi(
      dynamic orderID,
      dynamic status,
      dynamic moduleType,
      BuildContext context,
      ) async {
    setLoading(true);

    Map data = {
      "order_id": orderID, // gateway order_id
      "status": status,
    };

    try {
      final response = await _callbackRepo.callBackApi(data);

      final int statusCode = response['statusCode'] ?? 0;
      final Map<String, dynamic> body = response['body'] ?? {};

      if (statusCode == 200 || statusCode == 201) {
        Utils.showSuccessMessage(context, body["message"]);
        print("moduleType");
        print(moduleType);

        if (moduleType == 2) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => DriverHomePage()),
                (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HandymanDashboard()),
                (route) => false,
          );
        }
      }
      else {
        Utils.showErrorMessage(context, body["message"]);
      }
    } catch (e) {
      Utils.showErrorMessage(context, "$e");
    } finally {
      setLoading(false);
    }
  }
}
