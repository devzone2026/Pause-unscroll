import 'package:get/get.dart';

import 'calendar_screen_logic.dart';

class CalendarScreenBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => CalendarScreenLogic(state: Get.find()));
  }
}