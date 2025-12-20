import 'package:flutter/foundation.dart';
import 'package:rainbow_partner/helper/network/network_api_services.dart';
import 'package:rainbow_partner/res/api_url.dart';

class VehicleColorsRepo {

  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<Map<String, dynamic>> vehicleColorsApi(dynamic data) async {
    try {
      final response = await _apiServices.getGetApiResponse(
        ApiUrl.vehicleColorsUrl,
      );
      return response;

    } catch (e) {
      if (kDebugMode) {
        print("Repo Error in vehicleColorsApi → $e");
      }
      rethrow;
    }
  }
}
