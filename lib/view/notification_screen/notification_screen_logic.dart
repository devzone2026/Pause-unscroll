import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../backend/models/get_notification_model.dart';
import 'notification_screen_state.dart';


class NotificationScreenLogic extends GetxController {
  final NotificationScreenState state;

  NotificationScreenLogic({required this.state});

  GetNotificationModel getNotificationModel = GetNotificationModel();
  RxBool mainLoader = true.obs;
  RxBool deleteModeEnable = false.obs;
  List<String> deleteList = [];



  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getNotificationApi();
    });
  }

  Future<void> getNotificationApi() async {
    try {
      final response = await state.getNotificationState(endUrl: "?page=1&limit=20");
      if (response != null && response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
        debugPrint("Profile Response :: $myMap");
        getNotificationModel = GetNotificationModel.fromJson(myMap);
        mainLoader.value = false;
        update();
      }
    } catch (error) {
      debugPrint("Error: $error");
      mainLoader.value = false;
    }
  }


  Future<void> deleteNotificationApi() async {
    try {
      print("LIST IS :: $deleteList");
      final response = await state.deleteNotificationState(deleteList);
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        getNotificationModel.data?.removeWhere((element) => deleteList.contains(element.id));
        deleteList.clear();
        print("111111111111111111111111111");
        deleteModeEnable.value = false;

        update();
      }
    } catch (error) {
      debugPrint("deleteNotificationApi error: $error");
    }
  }



}
