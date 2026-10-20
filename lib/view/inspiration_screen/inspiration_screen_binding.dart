import 'package:get/get.dart';

import 'inspiration_screen_logic.dart';

class InspirationScreenBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => InspirationScreenLogic(state: Get.find()));
  }
}