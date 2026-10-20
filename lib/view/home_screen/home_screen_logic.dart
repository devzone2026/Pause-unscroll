import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/utils/appAssets.dart';
import '../../backend/models/get_dashboard_model.dart';
import '../../backend/models/get_profile.model.dart';
import 'home_screen_state.dart';

class HomeScreenLogic extends GetxController {
  final HomeScreenState state;

  HomeScreenLogic({required this.state});

  RxString username = "User".obs;
  GetDashboardModel getDashboardModel = GetDashboardModel();
  RxBool mainLoader = true.obs;
  double wellScore = 0.0;
  List<DashBoardModel> list = [];

  Future<void> profileApi() async {
    try {
      final response = await state.profileState();
      if (response != null && response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
        debugPrint("Profile Response :: $myMap");
        GetProfileModel().fromJson(myMap);
        username.value = GetProfileModel().data?.name ?? "";

        state.sharedPreferencesManager.putBool("notification1", GetProfileModel().data?.dailyReminder ?? false);
        state.sharedPreferencesManager.putBool("notification2", GetProfileModel().data?.enableNotification ?? false);
        state.sharedPreferencesManager.putBool("notification3", GetProfileModel().data?.streakReminder ?? false);

        update();
      }
    } catch (error) {
      debugPrint("Error: $error");
    }
  }

  Future<void> dashboardDetailsApi() async {
    try {
      final response = await state.dashboardDetailsState();
      if (response != null && response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
        debugPrint("Dashboard Response :: $myMap");
        getDashboardModel = GetDashboardModel.fromJson(myMap);
        mainLoader.value = false;
        wellScore = (getDashboardModel.data?.wellnessScore)! / 100.0;
        list.clear();

        list.add(
          DashBoardModel(title: "Water", icon: AssetPath.iconDrop, score: "${getDashboardModel.data!.todaySnapshot?.hydration ?? "0"} / 8", desc: "Glasses"),
        );
        list.add(
          DashBoardModel(
            title: "Meditation",
            icon: AssetPath.iconMeditation,
            score: "${getDashboardModel.data!.todaySnapshot?.meditationMinutes ?? "0"}",
            desc: "Minutes",
          ),
        );
        list.add(DashBoardModel(title: "Mood", icon: AssetPath.iconEmoji, score: "${getDashboardModel.data!.todaySnapshot?.mood ?? "0"}", desc: "Out of 100"));
        list.add(
          DashBoardModel(title: "Workout", icon: AssetPath.iconDumBell, score: getDashboardModel.data!.todaySnapshot?.workoutDuration ?? "0", desc: "Minutes"),
        );
        update();
      }
    } catch (error) {
      mainLoader.value = false;
      debugPrint("Error: $error");
    }
  }
}

class DashBoardModel {
  String title;
  String icon;
  String score;
  String desc;

  DashBoardModel({required this.title, required this.icon, required this.score, required this.desc});
}
