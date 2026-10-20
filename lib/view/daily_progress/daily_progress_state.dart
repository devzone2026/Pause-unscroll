import 'package:dio/dio.dart';
import 'package:pause_and_scroll/backend/helper/sharedPref.dart';
import 'package:pause_and_scroll/backend/repo/api.dart';

import '../../utils/api_endpoint.dart';

class DailyProgressState {

  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;

  DailyProgressState({required this.apiService, required this.sharedPreferencesManager});



  Future<Response?> planningProgressState() async {
    return await apiService.getPrivate(endPointProgressToday, {});
  }

  Future upDateDailyProgressState(Map<String, dynamic> data) async {
    return await apiService.postPrivate(endPointProgressSave, data);
  }



}
