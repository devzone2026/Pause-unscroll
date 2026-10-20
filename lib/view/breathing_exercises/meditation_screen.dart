

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/backend/helper/appRoute.dart';
import 'package:pause_and_scroll/utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonTextWidget.dart';
import 'breathing_exercises_logic.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final BreathingExercisesLogic logic = Get.put(BreathingExercisesLogic(state: Get.find()));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.scaffolderColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: ThemeProvider.scaffolderColor,
        centerTitle: true,
        title: CommonTextWidget(heading: "Meditation", fontWeight: FontWeight.w700, fontSize: 20, color: ThemeProvider.greenDarkColor),
      ),
      body: SafeArea(
        child: GetBuilder<BreathingExercisesLogic>(
          builder:(_) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.sp),
              child: NestedScrollView(headerSliverBuilder: (context, innerBoxIsScrolled) => [],
                  body: Column(
                    children: [
                      CommonTextWidget(
                        heading: "Choose your practice",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ThemeProvider.blackColor,
                        paddingH: 20,
                        textAlign: TextAlign.center,
                      ),

                      20.verticalSpace,
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRouter.meditationSetTimerScreen),
                        child: Container(
                          margin: EdgeInsets.only(top: 10.sp),
                          padding: EdgeInsets.symmetric(vertical: 20.sp),
                          decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 5.sp,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: ThemeProvider.greenDarkColor,
                                          borderRadius: BorderRadius.all(Radius.circular(100))
                                      ),
                                      child: SvgPicture.asset(AssetPath.iconMusic, color: ThemeProvider.whiteColor),
                                    ),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      spacing: 5.sp,
                                      children: [
                                        CommonTextWidget(heading: "Just Meditate", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 10),
                                        CommonTextWidget(heading: "Music + Timer only",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: ThemeProvider.blackColor,
                                            paddingH: 10),
                                      ],
                                    ),
                                  ],
                                ),


                                5.verticalSpace,
                                CommonTextWidget(heading: "Choose soothing music and set your timer. A simple, peaceful meditation experience.",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    maxLine: 3,
                                    lineHeight: 1.2,
                                    textAlign: TextAlign.start,
                                    color: ThemeProvider.blackColor),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}
