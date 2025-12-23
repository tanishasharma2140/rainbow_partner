import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rainbow_partner/helper/network/network_api_services.dart';
import 'package:rainbow_partner/res/api_url.dart';
class AuthRepo {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<Map<String, dynamic>> loginApi(
      Map<String, dynamic> data) async {

    try {
      final response = await http.post(
        Uri.parse(ApiUrl.servicemanLoginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      return {
        'statusCode': response.statusCode,
        'body': response.body.isNotEmpty
            ? jsonDecode(response.body)
            : {},
      };
    } catch (e) {
      // ONLY real network issues come here
      return {
        'statusCode': 0,
        'body': {
          'message': 'No Internet Connection',
        },
      };
    }
  }
  Future<dynamic> sendOtpApi(dynamic mobile) async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse('${ApiUrl.sendOtpUrl}$mobile');
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during sendOtp: $e');
      }
      rethrow;
    }
  }
  Future<dynamic> verifyOtpApi(dynamic phone , dynamic otp) async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse('${ApiUrl.verifyOtpUrl}$phone&otp=$otp');
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during verifyOtp: $e');
      }
      rethrow;
    }
  }


}