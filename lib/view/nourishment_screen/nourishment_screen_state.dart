import 'package:dio/dio.dart';

import '../../backend/helper/sharedPref.dart';
import '../../backend/repo/api.dart';
import '../../utils/api_endpoint.dart';

class NourishmentScreenState {

  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;

  NourishmentScreenState({required this.apiService, required this.sharedPreferencesManager});


  Future<Response?> nourishmentState({required String endUrl}) async {
    return await apiService.getPrivate(endPointNourishmentSuggestion + endUrl, {});
  }
}
