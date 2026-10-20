import 'package:get/get.dart';

import 'daily_progress_logic.dart';

class DailyProgressBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => DailyProgressLogic(state: Get.find()));
  }
}