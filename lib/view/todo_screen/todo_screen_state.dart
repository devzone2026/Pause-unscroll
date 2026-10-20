import 'package:dio/dio.dart';
import 'package:pause_and_scroll/backend/repo/api.dart';

import '../../backend/helper/sharedPref.dart';
import '../../utils/api_endpoint.dart';

class TodoScreenState {

  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;

  TodoScreenState({required this.apiService,required this.sharedPreferencesManager});


  Future<Response?> getTodoState(int pagination, String type) async {
    return await apiService.getPrivate("$endPointPlanningTodoList?frequency=$type&page=$pagination&limit=20", {});
  }


  Future createTodoState(Map<String, dynamic> data) async {
    return await apiService.postPrivate(endPointPlanningTodoCreate, data);
  }


  Future completeTodoState(String todoId) async {
    return await apiService.putPrivate(endPointPlanningComplete + todoId);
  }


  Future todoDeleteState(String journalId) async {
    return await apiService.deletePrivate(endPointPlanningDelete + journalId, queryParams: {});
  }
}
