import 'package:pause_and_scroll/backend/helper/sharedPref.dart';
import 'package:pause_and_scroll/backend/repo/api.dart';

class PlanningScreenState {

  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;

  PlanningScreenState({required this.apiService, required this.sharedPreferencesManager});
}
