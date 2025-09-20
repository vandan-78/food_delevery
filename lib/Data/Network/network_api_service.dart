import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../app_excaptions.dart';
import 'base_api_services.dart';

class NetworkApiService extends BaseApiServices {
  @override
  Future getApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(
        Uri.parse(url),
        headers: {'x-api-key': 'reqres-free-v1'}, // example header
      )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
      debugPrint("GET Response: $responseJson");
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  @override
  Future postApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
        Uri.parse(url),
        body: data,
        headers: {'x-api-key': 'reqres-free-v1'}, // example header
      )
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
      debugPrint("POST Response: $responseJson");
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedExceptions(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          "Error occurred while communicating with server "
              "with status code : ${response.statusCode}",
        );
    }
  }
}
