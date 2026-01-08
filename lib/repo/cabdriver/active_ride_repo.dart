import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/helper/network/network_api_services.dart';
import 'package:rainbow_partner/res/api_url.dart';


class ActiveRideRepo {
  final NetworkApiServices _apiServices = NetworkApiServices();


  Future<dynamic> activeRideApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse(ApiUrl.activeRideUrl, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during activeRideApi: $e');
      }
      rethrow;
    }
  }
}