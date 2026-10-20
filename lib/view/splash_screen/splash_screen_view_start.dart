import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../backend/helper/appRoute.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonButtonWidget.dart';
import '../../widgets/commonTextWidget.dart';

class SplashScreenViewStart extends StatelessWidget {
  const SplashScreenViewStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: ThemeProvider.mainGradient),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20.h,
                children: [
                  Hero(tag: "logo", child: Image.asset(AssetPath.splashLogo, width: 120, height: 120)),

                  10.verticalSpace,
                  CommonTextWidget(
                    heading: "Pause & Unscroll",
                    textAlign: TextAlign.center,
                    fontSize: 24,
                    color: ThemeProvider.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                  10.verticalSpace,
                  CommonTextWidget(
                    heading: "In a world full of endless scrolling, let’s pause & unscroll.",
                    maxLine: 3,
                    lineHeight: 1.5,
                    textAlign: TextAlign.center,
                    fontSize: 20,
                    color: ThemeProvider.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 3,
              child: Center(
                child: CommonButtonWidget(
                  onPressed: () {
                    Get.offAllNamed(AppRouter.dashboardScreen);
                  },
                  title: "Enter the app",
                  borderEnable: true,
                  shadowEnable: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
