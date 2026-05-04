import 'package:rainbow_partner/helper/network/network_api_services.dart';
import 'package:rainbow_partner/res/api_url.dart';

class CabPaymentRepo {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<dynamic> cabPaymentApi(dynamic data) async {
    try {
      final response =
      await _apiServices.getPostApiResponse(ApiUrl.paymentUrl, data);

      return response;
    } catch (e) {
      rethrow;
    }
  }
}