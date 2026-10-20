import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/appAssets.dart';
import '../breathing_exercises/breathing_exercises_state.dart';
import 'planning_screen_state.dart';

class PlanningScreenLogic extends GetxController {
  final PlanningScreenState state;

  PlanningScreenLogic({required this.state});

  List<DemoBreathingExercisesModel> demoList = [];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _populateDemoList();
      update();
    });
  }


  void _populateDemoList() {
    demoList = [
      DemoBreathingExercisesModel(
        title: "To - Do - Lists",
        subTitle: "Manage your tasks",
        icon: AssetPath.iconEditNote,
        desc: "Create daily, weekly, and recurring tasks with gentle reminder",
      ),
      DemoBreathingExercisesModel(
        title: "Daily Progress Tracker",
        subTitle: "Track your wellness",
        icon: AssetPath.iconDailProgress,
        desc: "Log hydration, meditation, mood, and workout activity for today",
      ),
      DemoBreathingExercisesModel(
        title: "Journaling",
        subTitle: "Reflect & record",
        icon: AssetPath.iconTodo,
        desc: "Practice mindful breathing techniques and calming meditation sessions to center yourself ",
      ),
    ];
  }


}
