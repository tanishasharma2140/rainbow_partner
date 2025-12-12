import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rainbow_partner/helper/app_exception.dart';
import 'package:rainbow_partner/helper/network/base_api_services.dart';
import 'package:rainbow_partner/service/internet_checker.dart';

class NetworkApiServices extends BaseApiServices {

  // ----------------------------- HEADERS -----------------------------
  Map<String, String> _jsonHeaders() {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      "Cache-Control": "no-cache, no-store, must-revalidate",
      "Pragma": "no-cache",
      "Expires": "0",
    };
  }

  Map<String, String> _formHeaders() {
    return {
      "Cache-Control": "no-cache, no-store, must-revalidate",
      "Pragma": "no-cache",
      "Expires": "0",
    };
  }

  // ----------------------------- GET -----------------------------
  @override
  Future getGetApiResponse(String url) async {
    try {
      final isInternetConnected=await InternetChecker.hasInternet();
      if(isInternetConnected == false){
        print('No internet connection found please ty again later or try switching internet connection');
        throw FetchDataException('No internet connection found please ty again later or try switching internet connection');
      }
      final response = await http.get(Uri.parse(url), headers: _jsonHeaders());
      return _returnResponse(response, url);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  // ----------------------------- POST JSON -----------------------------
  @override
  Future getPostApiResponse(String url, data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _jsonHeaders(),
        body: jsonEncode(data),
      );
      return _returnResponse(response, url);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }



  // ----------------------------- POST FORM DATA -----------------------------
  @override
  Future getPostApiFormData(
      String url, Map<String, String> fields, Map<String, dynamic> files) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(_formHeaders());
      request.fields.addAll(fields);

      await _addFilesToRequest(request, files);

      var streamed = await request.send();
      var response = await http.Response.fromStream(streamed);

      return _returnResponse(response, url);

    } catch (e) {
      if (kDebugMode) print("POST FormData Error: $e");
      rethrow;
    }
  }

  // ----------------------------- PATCH JSON -----------------------------
  @override
  Future getPatchApiResponse(String url, data) async {
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: _jsonHeaders(),
        body: jsonEncode(data),
      );
      return _returnResponse(response, url);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  // ----------------------------- PATCH FORM DATA -----------------------------
  Future getPatchApiFormData(
      String url, Map<String, String> fields, Map<String, dynamic> files) async {
    try {
      var request = http.MultipartRequest('PATCH', Uri.parse(url));
      request.headers.addAll(_formHeaders());
      request.fields.addAll(fields);

      await _addFilesToRequest(request, files);

      var streamed = await request.send();
      var response = await http.Response.fromStream(streamed);

      return _returnResponse(response, url);
    } catch (e) {
      if (kDebugMode) print("PATCH FormData Error: $e");
      rethrow;
    }
  }

  // ----------------------------- PUT JSON -----------------------------
  Future getPutApiResponse(String url, data) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: _jsonHeaders(),
        body: jsonEncode(data),
      );
      return _returnResponse(response, url);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  // ----------------------------- PUT FORM DATA -----------------------------
  Future getPutApiFormData(
      String url, Map<String, String> fields, Map<String, dynamic> files) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(url));
      request.headers.addAll(_formHeaders());
      request.fields.addAll(fields);

      await _addFilesToRequest(request, files);

      var streamed = await request.send();
      var response = await http.Response.fromStream(streamed);

      return _returnResponse(response, url);
    } catch (e) {
      if (kDebugMode) print("PUT FormData Error: $e");
      rethrow;
    }
  }

  // ----------------------------- DELETE -----------------------------
  Future getDeleteApiResponse(String url) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: _jsonHeaders(),
      );
      return _returnResponse(response, url);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  // ----------------------------- DELETE + BODY -----------------------------
  Future getDeleteApiWithBody(String url, data) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: _jsonHeaders(),
        body: jsonEncode(data),
      );
      return _returnResponse(response, url);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  // ----------------------------- FILE HANDLER -----------------------------
  Future<void> _addFilesToRequest(
      http.MultipartRequest request, Map<String, dynamic> files) async {
    for (var entry in files.entries) {
      final key = entry.key;
      final value = entry.value;

      // 1️⃣ Single file
      if (value is File) {
        request.files.add(
          await http.MultipartFile.fromPath(key, value.path),
        );
      }

      // 2️⃣ Multiple files  → SAME KEY again & again
      else if (value is List<File>) {
        for (File f in value) {
          request.files.add(
            await http.MultipartFile.fromPath(key, f.path),
          );
        }
      }
    }
  }


  // ---------------- RESPONSE HANDLER ----------------
  Map<String, dynamic> _returnResponse(http.Response response, String requestUrl) {
    final statusCode = response.statusCode;
    final rawBody = response.body;

    if (kDebugMode) {
      print("📍 URL: $requestUrl");
      print("📥 STATUS: $statusCode");
      print("📦 BODY: $rawBody");
    }

    Map<String, dynamic> body;
    try {
      body = jsonDecode(rawBody);
    } catch (_) {
      body = {};
    }

    switch (statusCode) {
      case 200:
      case 201:
      case 204:
        return {"statusCode": statusCode, "body": body};

      case 400:
        throw BadRequestException(body["message"] ?? "Bad Request");
      case 401:
      case 403:
        throw UnauthorisedException(body["message"] ?? "Unauthorized");
      case 404:
        throw FetchDataException("Endpoint not found (404)");
      case 409:
        throw FetchDataException("Conflict error (409)");
      case 422:
        throw FetchDataException(body["message"] ?? "Validation error (422)");
      case >= 500:
        throw FetchDataException("Server error ($statusCode)");

      default:
        throw FetchDataException("Unexpected error: $statusCode");
    }
  }
}
