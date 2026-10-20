import 'package:get/get.dart';

import 'planning_screen_logic.dart';

class PlanningScreenBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => PlanningScreenLogic(state: Get.find()));
  }
}