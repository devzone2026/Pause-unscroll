import 'package:get/get.dart';

import 'nourishment_screen_logic.dart';

class NourishmentScreenBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => NourishmentScreenLogic(state: Get.find()));
  }
}