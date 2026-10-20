import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/utils/appAssets.dart';
import 'package:pause_and_scroll/view/breathing_exercises/breathing_exercises_view.dart';
import 'package:pause_and_scroll/view/calendar_screen/calendar_screen_view.dart';
import 'package:pause_and_scroll/view/home_screen/home_screen_view.dart';
import 'package:pause_and_scroll/view/nourishment_screen/nourishment_screen_view.dart';
import 'package:pause_and_scroll/view/planning_screen/planning_screen_view.dart';
import 'package:pause_and_scroll/view/profile_screen/profile_screen_view.dart';
import '../home_screen/home_screen_logic.dart';
import 'dashboard_screen_state.dart';

class DashboardScreenLogic extends GetxController {
  final DashboardScreenState state;

  DashboardScreenLogic({required this.state});

  RxInt selectedIndex = 0.obs;

  final List<String> icons = [
    AssetPath.iconHome,
    AssetPath.iconMaterial,
    AssetPath.iconWorkout,
    AssetPath.iconApplee,
    // AssetPath.iconIdea,
    AssetPath.iconCalender,
    AssetPath.iconPerson,
  ];

  // ← Add your pages here
  List<Widget> pages = [
    HomeScreenPage(),
    BreathingExercisesPage(),
    PlanningScreenPage(),
    NourishmentScreenPage(),
    // InspirationScreenPage(),
    CalendarScreenPage(),
    ProfileScreenPage(),
  ];

  void onTap(int i) {
    selectedIndex.value = i;
    _onTabChanged(i);
  }


  void _onTabChanged(int index) {
    switch (index) {
      case 0:
        if (Get.isRegistered<HomeScreenLogic>()) {
          Get.find<HomeScreenLogic>().dashboardDetailsApi();
        }
        break;
    }
  }
}
