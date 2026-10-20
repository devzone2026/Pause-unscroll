import 'package:get/get.dart';

import 'login_screen_logic.dart';

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => LoginScreenLogic(state: Get.find()));
  }
}
