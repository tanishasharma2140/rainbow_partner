import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/helper/network/network_api_services.dart';
import 'package:rainbow_partner/res/api_url.dart';

class PartnerNotificationRepo {

  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<Map<String, dynamic>> partnerNotificationApi(dynamic data,dynamic entityId) async {
    try {
      final response = await _apiServices.getGetApiResponse(
        "${ApiUrl.partnerNotificationUrl}$data?entity_id=$entityId",
      );
      return response;

    } catch (e) {
      if (kDebugMode) {
        print("Repo Error in userNotificationApi → $e");
      }
      rethrow;
    }
  }
}