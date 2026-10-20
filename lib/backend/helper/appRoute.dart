import 'package:get/get.dart';
import 'package:pause_and_scroll/view/breathing_exercises/breathing_exercises_binding.dart';
import 'package:pause_and_scroll/view/calendar_screen/calendar_screen_binding.dart';
import 'package:pause_and_scroll/view/calendar_screen/calendar_screen_view.dart';
import 'package:pause_and_scroll/view/daily_progress/daily_progress_binding.dart';
import 'package:pause_and_scroll/view/dashboard_screen/dashboard_screen_binding.dart';
import 'package:pause_and_scroll/view/dashboard_screen/dashboard_screen_view.dart';
import 'package:pause_and_scroll/view/home_screen/home_screen_binding.dart';
import 'package:pause_and_scroll/view/home_screen/home_screen_view.dart';
import 'package:pause_and_scroll/view/inspiration_screen/inspiration_screen_binding.dart';
import 'package:pause_and_scroll/view/inspiration_screen/inspiration_screen_view.dart';
import 'package:pause_and_scroll/view/journal_screen/journal_screen_binding.dart';
import 'package:pause_and_scroll/view/journal_screen/journal_screen_view.dart';
import 'package:pause_and_scroll/view/login_screen/login_screen_binding.dart';
import 'package:pause_and_scroll/view/login_screen/login_screen_view.dart';
import 'package:pause_and_scroll/view/notification_screen/notification_screen_binding.dart';
import 'package:pause_and_scroll/view/notification_screen/notification_screen_view.dart';
import 'package:pause_and_scroll/view/nourishment_screen/nourishment_screen_binding.dart';
import 'package:pause_and_scroll/view/nourishment_screen/nourishment_screen_info.dart';
import 'package:pause_and_scroll/view/profile_screen/change_password_view.dart';
import 'package:pause_and_scroll/view/profile_screen/profile_screen_binding.dart';
import 'package:pause_and_scroll/view/profile_screen/profile_screen_edit_view.dart';
import 'package:pause_and_scroll/view/profile_screen/profile_screen_view.dart';
import 'package:pause_and_scroll/view/register_screen/register_screen_binding.dart';
import 'package:pause_and_scroll/view/register_screen/register_screen_view.dart';
import 'package:pause_and_scroll/view/splash_screen/splash_screen_binding.dart';
import 'package:pause_and_scroll/view/splash_screen/splash_screen_view.dart';
import 'package:pause_and_scroll/view/splash_screen/splash_screen_view_start.dart';
import 'package:pause_and_scroll/view/todo_screen/todo_screen_binding.dart';
import 'package:pause_and_scroll/view/todo_screen/todo_screen_view.dart';

import '../../view/breathing_exercises/breathing_exercises_view.dart';
import '../../view/breathing_exercises/breathing_meditation_screen.dart';
import '../../view/breathing_exercises/meditation_screen.dart';
import '../../view/breathing_exercises/meditation_settimer_screen.dart';
import '../../view/breathing_exercises/start_breathing_screen.dart';
import '../../view/daily_progress/daily_progress_view.dart';
import '../../view/journal_screen/create_journal_screen.dart';
import '../../view/nourishment_screen/nourishment_screen_view.dart';
import '../../view/planning_screen/planning_screen_binding.dart';
import '../../view/planning_screen/planning_screen_view.dart';

class AppRouter {
  static const String splashScreen = '/splash_screen';
  static const String splashScreen1 = '/splash_screen1';
  static const String loginScreen = '/login_screen';
  static const String registerScreen = '/register_screen';
  static const String dashboardScreen = '/dashboard_screen';
  static const String notificationScreen = '/notification_screen';
  static const String profileScreen = '/profile_screen';
  static const String profileScreenEditView = '/profile_screen_edit';
  static const String inspirationScreen = '/inspiration_screen';
  static const String nourishmentScreen = '/nourishment_screen';
  static const String nourishmentScreenInfo = '/nourishment_screen_info';
  static const String calendarScreen = '/calendar_screen';
  static const String homeScreen = '/home_screen';
  static const String breathingExercisesScreen = '/breathing_exercises_screen';
  static const String changePasswordScreen = '/changePasswordScreen';
  static const String planningScreenPage = '/planningScreenPage';
  static const String journalScreenPage = '/journalScreenPage';
  static const String createJournalScreen = '/createJournalScreen';
  static const String todoScreenPage = '/todoScreenPage';


  static const String startBreathingScreen = '/startBreathingScreen';
  static const String breathingMeditationScreen = '/breathingMeditationScreen';
  static const String meditationScreen = '/meditationScreen';
  static const String meditationSetTimerScreen = '/meditationSetTimerScreen';
  static const String dailyProgressPage = '/dailyProgressPage';





  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreenPage(), binding: SplashScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: splashScreen1, page: () => SplashScreenViewStart(), binding: SplashScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: loginScreen, page: () => LoginScreenPage(), binding: LoginScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: registerScreen, page: () => RegisterScreenPage(), binding: RegisterScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: dashboardScreen, page: () => DashboardScreenPage(), binding: DashboardScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: notificationScreen, page: () => NotificationScreenPage(), binding: NotificationScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: profileScreen, page: () => ProfileScreenPage(), binding: ProfileScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: profileScreenEditView, page: () => ProfileScreenEditView(), binding: ProfileScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: changePasswordScreen, page: () => ChangePasswordView(), binding: ProfileScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: inspirationScreen, page: () => InspirationScreenPage(), binding: InspirationScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: nourishmentScreen, page: () => NourishmentScreenPage(), binding: NourishmentScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: nourishmentScreenInfo, page: () => NourishmentScreenInfo(), binding: NourishmentScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: calendarScreen, page: () => CalendarScreenPage(), binding: CalendarScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: homeScreen, page: () => HomeScreenPage(), binding: HomeScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: planningScreenPage, page: () => PlanningScreenPage(), binding: PlanningScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),



    GetPage(name: journalScreenPage, page: () => JournalScreenPage(), binding: JournalScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: createJournalScreen, page: () => CreateJournalScreen(), binding: JournalScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: todoScreenPage, page: () => TodoScreenPage(), binding: TodoScreenBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: dailyProgressPage, page: () => DailyProgressPage(), binding: DailyProgressBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),






    GetPage(name: breathingExercisesScreen, page: () => BreathingExercisesPage(), binding: BreathingExercisesBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: startBreathingScreen, page: () => StartBreathingScreen(), binding: BreathingExercisesBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: breathingMeditationScreen, page: () => BreathingMeditationScreen(), binding: BreathingExercisesBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: meditationScreen, page: () => MeditationScreen(), binding: BreathingExercisesBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),
    GetPage(name: meditationSetTimerScreen, page: () => MeditationSetTimerScreen(), binding: BreathingExercisesBinding(), transition: Transition.fadeIn, transitionDuration: const Duration(milliseconds: 300),),





  ];
}
