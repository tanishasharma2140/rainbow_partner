import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/helper/network/network_api_services.dart';
import 'package:rainbow_partner/res/api_url.dart';


class CabHistoryRepo {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<dynamic> cabHistoryApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse(ApiUrl.cabHistoryUrl, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during cabHistoryApi: $e');
      }
      rethrow;
    }
  }
}