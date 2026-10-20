import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/utils/constants.dart';
import '../../backend/helper/appRoute.dart';
import 'splash_screen_state.dart';

class SplashScreenLogic extends GetxController with GetSingleTickerProviderStateMixin {
  final SplashScreenState state;

  SplashScreenLogic({required this.state});

  late AnimationController controller;
  late Animation<double> scaleAnimation;
  RxBool showText = false.obs;

  @override
  void onInit() {
    super.onInit();

    controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));

    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);

    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        showText.value = true;
        Future.delayed(const Duration(seconds: 2), () {
          if (!isClosed) {
            debugPrint("SAVE-AUTH :: ${state.sharedPreferencesManager.sharedPreferences.getString(Constants.saveAuth)}");
            if (state.sharedPreferencesManager.sharedPreferences.getString(Constants.saveAuth).toString().isNotEmpty &&
                state.sharedPreferencesManager.sharedPreferences.getString(Constants.saveAuth) != null) {
              Get.offNamed(AppRouter.dashboardScreen);
            } else {
              Get.offNamed(AppRouter.loginScreen);
            }
          }
        });
      }
    });
  }


  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
