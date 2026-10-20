import 'package:get/get.dart';

import 'splash_screen_logic.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => SplashScreenLogic(state: Get.find()));
  }
}