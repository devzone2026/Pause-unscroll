import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/widgets/commonButtonWidget.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonTextWidget.dart';
import 'breathing_exercises_logic.dart';

class BreathingMeditationScreen extends StatefulWidget {
  const BreathingMeditationScreen({super.key});

  @override
  State<BreathingMeditationScreen> createState() => _BreathingMeditationScreenState();
}

class _BreathingMeditationScreenState extends State<BreathingMeditationScreen> {
  final BreathingExercisesLogic logic = Get.put(BreathingExercisesLogic(state: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.scaffolderColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: ThemeProvider.scaffolderColor,
        centerTitle: true,
        title: CommonTextWidget(heading: "Breathing & Meditation", fontWeight: FontWeight.w700,
            fontSize: 20, color: ThemeProvider.greenDarkColor),
      ),
      body: SafeArea(
        child: GetBuilder<BreathingExercisesLogic>(
          builder: (_) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.sp),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [],
                body: Column(
                  children: [
                    CommonTextWidget(
                      heading: "Choose an exercise to begin",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ThemeProvider.blackColor,
                      paddingH: 20,
                      textAlign: TextAlign.center,
                    ),

                    20.verticalSpace,
                    Expanded(
                      child: ListView.builder(
                        itemCount: (logic.breathingTech.data?.length ?? 0),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // Last item
                         /* if (index == (logic.breathingTech.data?.length ?? 0)) {
                            return Container(
                              margin: EdgeInsets.only(top: 10.sp),
                              padding: EdgeInsets.symmetric(vertical: 15.sp),
                              decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(12.sp))),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  spacing: 5.sp,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      spacing: 5.sp,
                                      children: [
                                        SvgPicture.asset(AssetPath.iconMusic, color: ThemeProvider.hintIconColor),
                                        CommonTextWidget(
                                            heading: "Meditation Music ", fontSize: 14, fontWeight: FontWeight.w500, color: ThemeProvider.blackColor),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(borderRadius: BorderRadiusGeometry.circular(15), color: ThemeProvider.hintIconColor),
                                      child: CommonTextWidget(heading: "Play", fontSize: 14, fontWeight: FontWeight.w500, color: ThemeProvider.blackColor),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }*/

                          // List items
                          return Obx(() {
                            return GestureDetector(
                              onTap: () {
                                logic.currentTab.value = index;
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10.sp),
                                padding: EdgeInsets.symmetric(vertical: 20.sp),
                                decoration: BoxDecoration(
                                    color: ThemeProvider.whiteColor,
                                    border: Border.all(color: logic.currentTab.value == index ? ThemeProvider.greenDarkColor : ThemeProvider.whiteColor, width: 1),
                                    borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    spacing: 5.sp,
                                    children: [
                                      CommonTextWidget(heading: logic.breathingTech.data?[index].name ?? "", fontSize: 16, color: ThemeProvider.blackColor),
                                      5.verticalSpace,
                                      CommonTextWidget(
                                        heading: logic.breathingTech.data?[index].description ?? "",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        maxLine: 3,
                                        lineHeight: 1.2,
                                        textAlign: TextAlign.start,
                                        color: ThemeProvider.blackColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ),


                    CommonButtonWidget(
                      onPressed: () => logic.startSession(),
                      title: "Start Session",
                      width: double.infinity,
                      paddingH: 0,
                      showIcon: true,
                      icon: AssetPath.iconPlayer,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
