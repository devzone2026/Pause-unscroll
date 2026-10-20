import 'package:get/get.dart';

import 'todo_screen_logic.dart';

class TodoScreenBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => TodoScreenLogic(state: Get.find()));
  }
}