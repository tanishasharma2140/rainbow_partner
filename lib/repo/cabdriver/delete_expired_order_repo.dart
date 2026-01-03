import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/helper/network/network_api_services.dart';
import 'package:rainbow_partner/res/api_url.dart';

class DeleteExpiredOrderRepo {

  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<dynamic> deleteExpiredOrderApi() async {
    try {
      final response = await _apiServices.getGetApiResponse(
        ApiUrl.deleteExpiredUrl,
      );
      return response;

    } catch (e) {
      if (kDebugMode) {
        print("Repo Error in deleteExpiredOrderApi → $e");
      }
      rethrow;
    }
  }
}
