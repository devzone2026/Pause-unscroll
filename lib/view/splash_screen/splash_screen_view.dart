import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/utils/appAssets.dart';
import 'package:pause_and_scroll/utils/appTheme.dart';
import 'package:pause_and_scroll/widgets/commonTextWidget.dart';
import 'splash_screen_logic.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final SplashScreenLogic logic = Get.put(SplashScreenLogic(state: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: ThemeProvider.mainGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20.h,
          children: [
            ScaleTransition(scale: logic.scaleAnimation, child: Image.asset(AssetPath.splashLogo, width: 200, height: 200)),

            Obx(
              () => AnimatedOpacity(
                opacity: logic.showText.value ? 1 : 0,
                duration: const Duration(milliseconds: 600),
                child: CommonTextWidget(heading: "Pause & Unscroll", fontSize: 24, color: ThemeProvider.whiteColor, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
