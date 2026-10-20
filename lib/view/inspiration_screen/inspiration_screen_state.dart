import 'package:dio/dio.dart';
import 'package:pause_and_scroll/backend/helper/sharedPref.dart';
import 'package:pause_and_scroll/backend/repo/api.dart';

import '../../utils/api_endpoint.dart';

class InspirationScreenState {

  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;

  InspirationScreenState({required this.apiService, required this.sharedPreferencesManager});


  Future<Response?> inspirationState() async {
    return await apiService.getPrivate(endPointInspirationDaily, {});
  }
}
