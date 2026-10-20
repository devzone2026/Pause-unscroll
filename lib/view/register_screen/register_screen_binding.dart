import 'package:get/get.dart';
import 'register_screen_logic.dart';

class RegisterScreenBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => RegisterScreenLogic(state: Get.find()));
  }
}