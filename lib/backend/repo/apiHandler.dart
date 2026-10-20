

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:pause_and_scroll/utils/toasts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/appRoute.dart';

class ApiHandler{

  static Future<Response> return200Response(Response response) async {
    debugPrint("Request: ${response.data}");

    switch (response.statusCode) {
      case 200:
        return response;

      case 400:
        final data = response.data is String ? jsonDecode(response.data) : response.data;
        debugPrint("Bad Request: $data");
        errorToast(data["responseMessage"]);
        throw Exception("Bad Request");

      case 401:
        debugPrint("Unauthorized: ${response.data}");
        _navigatorToLogin();
        throw Exception("Unauthorized");

      case 403:
        debugPrint("Unauthorized: 111 ${response.data}");
        throw Exception("Unauthorized");

      case 409:
        debugPrint("Conflict: ${response.data}");
        throw Exception("Conflict");

      case 500:
        debugPrint("Internal Server Error: ${response.data}");
        throw Exception("Internal Server Error");

      default:
        debugPrint("Unhandled status code ${response.statusCode}: ${response.data}");
        throw Exception("Unhandled status code: ${response.statusCode}");
    }
  }


  static exceptionHandler(DioException exception) {
    if (exception.response != null) {
      debugPrint("DioError with response: ${exception.response?.statusCode} - ${exception.response?.data}");
      _navigatorToLogin();
      String? message;
      final data = exception.response?.data;
      if (data is Map) {
        message = data["responseMessage"];
      } else if (data is String) {
        try {
          final decoded = jsonDecode(data);
          message = decoded["responseMessage"];
        } catch (_) {}
      }
      if (message != null) errorToast(message);
    } else {
      debugPrint("DioError without response: ${exception.message}");
    }
  }


  static _navigatorToLogin() async{
    SharedPreferences sharedPrefManger = await SharedPreferences.getInstance();
    sharedPrefManger.clear();
    Get.offAllNamed(AppRouter.loginScreen);
  }


}