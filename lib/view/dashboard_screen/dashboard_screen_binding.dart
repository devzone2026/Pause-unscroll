import 'package:get/get.dart';

import 'dashboard_screen_logic.dart';

class DashboardScreenBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => DashboardScreenLogic(state : Get.find()));
  }
}