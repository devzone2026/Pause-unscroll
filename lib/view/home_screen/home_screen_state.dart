import 'package:dio/dio.dart';

import '../../backend/helper/sharedPref.dart';
import '../../backend/repo/api.dart';
import '../../utils/api_endpoint.dart';

class HomeScreenState {

  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;

  HomeScreenState({required this.apiService, required this.sharedPreferencesManager});


  Future<Response?> profileState() async {
    return await apiService.getPrivate(endPointProfileDetails, {});
  }


  Future<Response?> dashboardDetailsState() async {
    return await apiService.getPrivate(endPointDashboardDetails, {});
  }


}
