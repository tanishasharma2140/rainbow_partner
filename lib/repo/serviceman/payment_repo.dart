import 'package:rainbow_partner/helper/network/network_api_services.dart';
import 'package:rainbow_partner/res/api_url.dart';

class PaymentRepo {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<dynamic> paymentApi(dynamic data) async {
    try {
      final response =
      await _apiServices.getPostApiResponse(ApiUrl.paymentUrl, data);

      return response;
    } catch (e) {
      rethrow;
    }
  }
}