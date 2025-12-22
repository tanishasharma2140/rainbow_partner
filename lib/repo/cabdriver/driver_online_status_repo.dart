import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/helper/network/network_api_services.dart';
import 'package:rainbow_partner/res/api_url.dart';


class DriverOnlineStatusRepo {
  final NetworkApiServices _apiServices = NetworkApiServices();


  Future<dynamic> driverOnlineStatusApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse(ApiUrl.driverOnlineUrl, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during driverOnlineStatusApi: $e');
      }
      rethrow;
    }
  }
}