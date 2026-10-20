import 'package:dio/dio.dart';
import 'package:pause_and_scroll/backend/helper/sharedPref.dart';
import 'package:pause_and_scroll/backend/repo/api.dart';

import '../../utils/api_endpoint.dart';
import '../../utils/constants.dart';

class SplashScreenState {

  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;


  SplashScreenState({required this.apiService, required this.sharedPreferencesManager});


  Future<Response?> refreshState(Map<String, dynamic> body) async {
    return await apiService.putPrivate(endPointRefreshFcm ,data: body);
  }

  Future<void> saveData(String token) async {
    sharedPreferencesManager.sharedPreferences.setString(Constants.saveAuth, token);
  }

}
