import 'package:get/get.dart';
import 'package:pause_and_scroll/backend/helper/sharedPref.dart';
import 'package:pause_and_scroll/view/breathing_exercises/breathing_exercises_state.dart';
import 'package:pause_and_scroll/view/calendar_screen/calendar_screen_state.dart';
import 'package:pause_and_scroll/view/daily_progress/daily_progress_state.dart';
import 'package:pause_and_scroll/view/dashboard_screen/dashboard_screen_state.dart';
import 'package:pause_and_scroll/view/home_screen/home_screen_state.dart';
import 'package:pause_and_scroll/view/journal_screen/journal_screen_state.dart';
import 'package:pause_and_scroll/view/login_screen/login_screen_state.dart';
import 'package:pause_and_scroll/view/notification_screen/notification_screen_state.dart';
import 'package:pause_and_scroll/view/nourishment_screen/nourishment_screen_state.dart';
import 'package:pause_and_scroll/view/planning_screen/planning_screen_state.dart';
import 'package:pause_and_scroll/view/profile_screen/profile_screen_state.dart';
import 'package:pause_and_scroll/view/register_screen/register_screen_state.dart';
import 'package:pause_and_scroll/view/splash_screen/splash_screen_state.dart';
import 'package:pause_and_scroll/view/todo_screen/todo_screen_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';
import '../../view/inspiration_screen/inspiration_screen_state.dart';
import '../repo/api.dart';
import '../repo/socket_service.dart';

class MainBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    final sharedPref = await SharedPreferences.getInstance();
    Get.put(SharedPrefManger(sharedPreferences: sharedPref), permanent: true);


    Get.put(ApiService(appBaseUrl: Constants.baseUrl,sharedPrefManger: Get.find()), permanent: true);
    Get.lazyPut(() => SocketService(socketBaseUrl: Constants.baseSocketUrl), fenix: true);


    Get.lazyPut(() => SplashScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => LoginScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => RegisterScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => DashboardScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => NotificationScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ProfileScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => NourishmentScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => InspirationScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => CalendarScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => HomeScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => BreathingExercisesState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => PlanningScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);


    Get.lazyPut(() => JournalScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => TodoScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => DailyProgressState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
  }
}
