import 'package:get/get.dart';

import 'breathing_exercises_logic.dart';

class BreathingExercisesBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => BreathingExercisesLogic(state: Get.find()));
  }
}