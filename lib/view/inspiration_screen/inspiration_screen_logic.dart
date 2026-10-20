import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/backend/models/get_inspiration_model.dart';
import 'inspiration_screen_state.dart';

class InspirationScreenLogic extends GetxController {
  final InspirationScreenState state;

  InspirationScreenLogic({required this.state});

  GetInspirationModel getInspirationModel = GetInspirationModel();
  RxBool mainLoader = true.obs;

  @override
  void onInit() {
    super.onInit();
    getInspirationApi();
  }

  Future<void> getInspirationApi() async {
    try {
      final response = await state.inspirationState();
      if (response != null && response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
        debugPrint("Profile Response :: $myMap");
        getInspirationModel = GetInspirationModel.fromJson(myMap);
        mainLoader.value = false;
        update();
      }
    } catch (error) {
      mainLoader.value = false;
      debugPrint("Error: $error");
    }
  }
}
