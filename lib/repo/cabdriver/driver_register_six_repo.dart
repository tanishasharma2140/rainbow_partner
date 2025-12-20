import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/helper/network/network_api_services.dart';
import 'package:rainbow_partner/res/api_url.dart';

class DriverRegisterSixRepo {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<dynamic> driverRegisterSixApi( Map<String, String> fields,
      Map<String, dynamic> files,) async {
    try {
      dynamic response = await _apiServices.getPostApiFormData(
          ApiUrl.driverRegisterUrl,
          fields,
          files
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error in driverRegisterSixApi→ $e");
      }
      rethrow;
    }
  }
}
