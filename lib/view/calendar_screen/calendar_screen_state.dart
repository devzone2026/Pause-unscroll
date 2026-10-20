import 'package:dio/dio.dart';

import '../../backend/helper/sharedPref.dart';
import '../../backend/repo/api.dart';
import '../../utils/api_endpoint.dart';

class CalendarScreenState {
  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;


  CalendarScreenState({required this.apiService,required this.sharedPreferencesManager});



  Future createCalendarState(Map<String, dynamic> data) async {
    return await apiService.postPrivate(endPointAddEvent, data);
  }

  Future<Response?> getEventsState(String param) async {
    return await apiService.getPrivate(endPointAddGetEvent + param, {});
  }

  Future deleteEventState(String eventId) async {
    return await apiService.deletePrivate(endPointAddDeleteEvent + eventId, queryParams: {});
  }

}
