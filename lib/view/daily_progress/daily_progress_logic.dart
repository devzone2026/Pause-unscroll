import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../backend/models/get_daily_progress_model.dart';
import 'daily_progress_state.dart';

class DailyProgressLogic extends GetxController {
  final DailyProgressState state;


  DailyProgressLogic({required this.state});

  GetDailyProgressModel dailyProgressModel = GetDailyProgressModel();


  RxBool apiLoader = true.obs;


  @override
  void onInit() {
    super.onInit();
    planningProgressApi();
  }

  Future<void> planningProgressApi() async {
    try {
      final response = await state.planningProgressState();
      if (response != null && response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
        debugPrint("Profile Response :: $myMap");
        dailyProgressModel = GetDailyProgressModel.fromJson(myMap);

        dailyProgressModel.data?.hydrationIntake = dailyProgressModel.data?.hydration ?? 0;
        dailyProgressModel.data?.localMeditationTime = dailyProgressModel.data?.meditationTime ?? 0;
        dailyProgressModel.data?.localMoodTime = dailyProgressModel.data?.mood ?? 0;
        dailyProgressModel.data?.localWorkoutTime = dailyProgressModel.data?.workoutMinutes ?? 0;

        apiLoader.value = false;
        update();
      }
    } catch (error) {
      apiLoader.value = false;
      debugPrint("Error: $error");
    }
  }



  Future<void> upDateDailyProgressApi({
    int? hydration,
    int? mood,
    int? workoutMinutes,
  }) async {
    try {
      final data = {
        if(hydration != null)
        "hydration": hydration,
        if(mood != null)
        "mood": mood,
        if(workoutMinutes != null)
        "workoutMinutes": workoutMinutes
      };
      debugPrint("body :: $data");
      final response = await state.upDateDailyProgressState(data);
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        debugPrint("Save Breathing Tech. Response :: $map");
        update();
      }
    } catch (error) {
      debugPrint("saveBreathingTechniquesApi error: $error");
    }
  }



}
