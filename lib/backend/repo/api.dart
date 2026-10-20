import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:pause_and_scroll/utils/constants.dart';
import '../../utils/api_endpoint.dart';
import '../../utils/toasts.dart';
import '../helper/appRoute.dart';
import '../helper/sharedPref.dart';
import 'apiHandler.dart';

class ApiService {
  final String appBaseUrl;
  late Dio _dioWithoutHeader;
  late Dio _dioWithHeader;
  final SharedPrefManger sharedPrefManger;

  ApiService({required this.appBaseUrl, required this.sharedPrefManger}) {
    _dioWithoutHeader = Dio(
      BaseOptions(
        baseUrl: appBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) => true,
      ),
    );

    _dioWithHeader = Dio(
      BaseOptions(
        baseUrl: appBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    _dioWithHeader.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = sharedPrefManger.getString(Constants.saveAuth);
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "$token";
          }
          return handler.next(options);
        },

      onResponse: (response, handler) {
        debugPrint("┌─────────────── RESPONSE ───────────────");
        debugPrint("│ URL       :: ${response.realUri}");
        debugPrint("│ Method    :: ${response.requestOptions.method}");
        debugPrint("│ Status    :: ${response.statusCode} ${response.statusMessage}");
        debugPrint("│ ReqHeader :: ${response.requestOptions.headers}");
        debugPrint("│ ResHeader :: ${response.headers}");
        debugPrint("│ Extra     :: ${response.extra}");
        debugPrint("│ Body      :: ${response.data}");
        debugPrint("└─────────────────────────────────────────");
        handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) async {


        debugPrint("┌─────────────── ERROR ───────────────");
        debugPrint("onError(Url):: ${error.requestOptions.uri}");
        debugPrint("onError(Status):: ${error.response?.statusCode}");
        debugPrint("onError(Message):: ${error.message}");
        debugPrint("onError(Body):: ${error.response?.data}");
        debugPrint("└─────────────────────────────────────────");

        if (error.response?.statusCode == 401) {
          try {
            final newToken = await refreshApi();
            if (newToken != null) {
              sharedPrefManger.sharedPreferences.setString(Constants.saveAuth, newToken);
              final opts = error.requestOptions;
              opts.headers["Authorization"] = newToken;
              final response = await _dioWithoutHeader.fetch(opts);
              return handler.resolve(response);
            }
          } catch (e) {
            debugPrint("Refresh token failed: $e");
          }
        }
        return handler.next(error);
      },
      ));
  }

  refreshApi() async{
    try {
      Map<String, dynamic> data = {"fcmToken": sharedPrefManger.sharedPreferences.getString(Constants.saveToken) };
      await putPrivate(endPointRefreshFcm ,data: data).then((response) {
        if (response != null && response.statusCode == 200) {
          Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
          debugPrint("Register Response :: $myMap");
          sharedPrefManger.sharedPreferences.setString(Constants.saveAuth, myMap["data"]["accessToken"]);
          Get.offAllNamed(AppRouter.dashboardScreen);
        }
      }).catchError((e) {
        debugPrint("Error: $e");
      });
    } catch (error) {
      errorToast('${'Error signing in with Google'.tr}$error');
    }
  }


  //TODO: ===============GET===============
  Future<Response?> getPublic(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      Response response = await _dioWithoutHeader.get(endpoint, queryParameters: queryParams);
      return await ApiHandler.return200Response(response);
    } on DioException catch (e) {
      ApiHandler.exceptionHandler(e);
      return null;
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      return null;
    }
  }

  Future<Response> getPrivate(String endpoint, Map<String, dynamic> queryParams) async {
    try {
      final response = await _dioWithHeader.get(endpoint, queryParameters: queryParams);
      return await ApiHandler.return200Response(response);
    } on DioException catch (e) {
      ApiHandler.exceptionHandler(e);
      rethrow; // propagate error upward instead of returning null
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      throw Exception("Unexpected error occurred: $e");
    }
  }


  //TODO: ===============POST===============
  Future<Response?> postPublic(String endpoint, Map<String, dynamic>? data) async {
    try {
      debugPrint("Endpoint: $endpoint");
      debugPrint("Data: $data");
      Response response = await _dioWithoutHeader.post(endpoint, data: data);
      return await ApiHandler.return200Response(response);
    } on DioException catch (e) {
      ApiHandler.exceptionHandler(e);
      return null;
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      return null;
    }
  }

  Future<Response?> postPrivate(String endpoint, Map<String, dynamic>? data) async {
    try {
      Response response = await _dioWithHeader.post(endpoint, data: data);
      return await ApiHandler.return200Response(response);
    } on DioException catch (e) {
      ApiHandler.exceptionHandler(e);
      return null;
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      return null;
    }
  }

  Future<dynamic> postWithImage(String endpoint, File file, Map<String, String>? extraFields, {required String fileKey}) async {
    try {
      String fileName = file.path.split('/').last;

      FormData formData = FormData.fromMap({
        fileKey: await MultipartFile.fromFile(file.path, filename: fileName),
        ...?extraFields, // Add additional fields if provided
      });

      Response response = await _dioWithHeader.post(endpoint, data: formData);
      return await ApiHandler.return200Response(response);
    } on DioException catch (e) {
      ApiHandler.exceptionHandler(e);
      return null;
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      return null;
    }
  }

  //TODO: ===============PUT===============
  Future<Response?> putPrivate(String endpoint, {Map<String, dynamic>? data, Map<String, dynamic>? queryParams}) async {
    try {
      Response response = await _dioWithHeader.put(endpoint, data: data, queryParameters: queryParams);
      return await ApiHandler.return200Response(response);
    } on DioException catch (e) {
      ApiHandler.exceptionHandler(e);
      return null;
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      return null;
    }
  }

  Future<Response?> putPublic(String endpoint, {Map<String, dynamic>? data, Map<String, dynamic>? queryParams}) async {
    try {
      Response response = await _dioWithoutHeader.put(endpoint, data: data, queryParameters: queryParams);
      return await ApiHandler.return200Response(response);
    } on DioException catch (e) {
      ApiHandler.exceptionHandler(e);
      return null;
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      return null;
    }
  }

  Future<Response?> putMultipart(
    String endpoint, {
    required Map<String, dynamic> fields,
    File? file, // optional file
    String? fileFieldName = 'file', // field name for the file
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      // Prepare multipart form data
      FormData formData = FormData.fromMap({
        ...fields,
        if (file != null) fileFieldName!: await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });

      Response response = await _dioWithHeader.put(endpoint, data: formData, queryParameters: queryParams);

      return await ApiHandler.return200Response(response);
    } on DioException catch (e) {
      ApiHandler.exceptionHandler(e);
      return null;
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      return null;
    }
  }


  //TODO: ===============DELETE===============
  Future<Response?> deletePrivate(String endpoint, {Map<String, dynamic>? queryParams, Map<String, dynamic>? body}) async {
    try {
      Response response = await _dioWithHeader.delete(endpoint, queryParameters: queryParams,data: body);

      return await ApiHandler.return200Response(response);
    } on DioException catch (e) {
      ApiHandler.exceptionHandler(e);
      return null;
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      return null;
    }
  }
}
