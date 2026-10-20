import 'package:get/get.dart';
import 'notification_screen_logic.dart';

class NotificationScreenBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => NotificationScreenLogic(state: Get.find()));
  }
}