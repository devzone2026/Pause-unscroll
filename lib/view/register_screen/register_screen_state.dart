import 'package:dio/dio.dart';
import 'package:pause_and_scroll/utils/constants.dart';

import '../../backend/helper/sharedPref.dart';
import '../../backend/repo/api.dart';
import '../../utils/api_endpoint.dart';

class RegisterScreenState {


  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;


  RegisterScreenState({required this.apiService, required this.sharedPreferencesManager});


  Future<void> saveData(String token) async {
    sharedPreferencesManager.sharedPreferences.setString(Constants.saveAuth, token);
  }


  Future<Response?> registerState(Map<String, dynamic> body) async {
    return await apiService.postPublic(endPointRegister , body);
  }
}
