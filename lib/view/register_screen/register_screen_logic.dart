import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/utils/constants.dart';

import '../../backend/helper/appRoute.dart';
import '../../utils/toasts.dart';
import 'register_screen_state.dart';

class RegisterScreenLogic extends GetxController {
  final RegisterScreenState state;

  RegisterScreenLogic({required this.state});

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxBool mainLoader = false.obs;
  RxBool passwordVisible = true.obs;
  RxBool confirmPasswordVisible = true.obs;



  Future<void> registerApi() async {
    try {
      Map<String, dynamic> data = {
        "type": "email",
        "name": nameController.text.trim().toString(),
        "email": emailController.text.trim().toString(),
        "password": passwordController.text.trim().toString(),
        "fcmToken": state.sharedPreferencesManager.sharedPreferences.getString(Constants.saveToken),
      };
      state
          .registerState(data)
          .then((response) {
            if (response != null && response.statusCode == 200) {
              Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
              debugPrint("Register Response :: $myMap");
              state.saveData(myMap["data"]["accessToken"]);
              Get.toNamed(AppRouter.splashScreen1);
              mainLoader.value = false;
            }
          })
          .catchError((e) {
            debugPrint("Error: $e");
            mainLoader.value = false;
          });
    } catch (error) {
      errorToast('${'Error signing in with Google'.tr}$error');
      mainLoader.value = false;
    }finally {
      mainLoader.value = false;
    }
  }
}
