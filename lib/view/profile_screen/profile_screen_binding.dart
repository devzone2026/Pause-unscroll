import 'package:get/get.dart';

import 'profile_screen_logic.dart';

class ProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => ProfileScreenLogic(state: Get.find()));
  }
}