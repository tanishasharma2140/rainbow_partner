import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/helper/network/network_api_services.dart';
import 'package:rainbow_partner/res/api_url.dart';


class ChangeServicePayModeRepo {
  final NetworkApiServices _apiServices = NetworkApiServices();


  Future<dynamic> changePayModeApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse(ApiUrl.changeServicePayModeUrl, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during changeServicePayModeApi: $e');
      }
      rethrow;
    }
  }
}