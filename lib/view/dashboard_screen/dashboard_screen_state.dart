import '../../backend/helper/sharedPref.dart';
import '../../backend/repo/api.dart';

class DashboardScreenState {

  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;

  DashboardScreenState({required this.apiService, required this.sharedPreferencesManager});
}
