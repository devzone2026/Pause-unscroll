import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pause_and_scroll/backend/repo/api.dart';

import '../../backend/helper/sharedPref.dart';
import '../../utils/api_endpoint.dart';

class NotificationScreenState {

  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;

  NotificationScreenState({required this.apiService, required this.sharedPreferencesManager});


  Future<Response?> getNotificationState({required String endUrl}) async {
    return await apiService.getPrivate(endPointNotification + endUrl, {});
  }

  Future deleteNotificationState(List<String> ids) async {
    return await apiService.deletePrivate(endPointNotification, body: {"notificationIds" : ids});
  }


}
