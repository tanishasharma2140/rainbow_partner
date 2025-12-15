import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/helper/network/network_api_services.dart';
import 'package:rainbow_partner/res/api_url.dart';

class CityRepo {

  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<Map<String, dynamic>> cityApi() async {
    try {
      final response = await _apiServices.getGetApiResponse(
        ApiUrl.citiesUrl,
      );
      return response;

    } catch (e) {
      if (kDebugMode) {
        print("Repo Error in citiesApi → $e");
      }
      rethrow;
    }
  }
}
