import 'package:dio/dio.dart';
import 'package:pause_and_scroll/backend/repo/api.dart';

import '../../backend/helper/sharedPref.dart';
import '../../utils/api_endpoint.dart';

class JournalScreenState {
  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;

  JournalScreenState({required this.apiService, required this.sharedPreferencesManager});

  Future<Response?> getJournalState(int pagination) async {
    return await apiService.getPrivate("$endPointJournalList?page=$pagination&limit=20", {});
  }

  Future journalCreateState(Map<String, dynamic> data) async {
    return await apiService.postPrivate(endPointJournalCreate, data);
  }

  Future journalUpdateState(String id, Map<String, String> data) async {
    return await apiService.putPrivate(endPointJournalUpdate + id, data: data);
  }

  Future journalDeleteState(String journalId) async {
    return await apiService.deletePrivate(endPointJournalDelete + journalId, queryParams: {});
  }
}
