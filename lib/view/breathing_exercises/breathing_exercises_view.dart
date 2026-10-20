import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/backend/helper/appRoute.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonTextWidget.dart';
import 'breathing_exercises_logic.dart';

class BreathingExercisesPage extends StatelessWidget {
  BreathingExercisesPage({super.key});

  final BreathingExercisesLogic logic = Get.put(BreathingExercisesLogic(state: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.scaffolderColor,
      body: SafeArea(
        child: GetBuilder<BreathingExercisesLogic>(
          builder:(_) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.sp),
              child: NestedScrollView(headerSliverBuilder: (context, innerBoxIsScrolled) => [],
                  body: Stack(
                    children: [
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: SvgPicture.asset(AssetPath.bannerBreath)),
                      Column(
                        children: [
                          30.verticalSpace,

                          CommonTextWidget(
                            heading: "Breathing Exercises",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: ThemeProvider.greenDarkColor,
                            paddingH: 20,
                            textAlign: TextAlign.center,
                          ),
                          10.verticalSpace,
                          CommonTextWidget(
                            heading: "Come back to yourself",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ThemeProvider.blackColor,
                            paddingH: 20,
                            textAlign: TextAlign.center,
                          ),

                          20.verticalSpace,
                          Expanded(
                            child: ListView.builder(
                                itemCount: logic.demoList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if(index == 0){
                                        logic.isThisExercise = true;
                                        Get.toNamed(AppRouter.breathingMeditationScreen);
                                      }else if(index == 1){
                                        logic.isThisExercise = false;
                                        Get.toNamed(AppRouter.meditationScreen);
                                      }
                                    },
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
                                                  child: SvgPicture.asset(logic.demoList[index].icon ?? "", color: ThemeProvider.whiteColor),
                                                ),

                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  spacing: 5.sp,
                                                  children: [
                                                    CommonTextWidget(heading: logic.demoList[index].title ?? "", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 10),
                                                    CommonTextWidget(heading: logic.demoList[index].subTitle ?? "",
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12,
                                                        color: ThemeProvider.blackColor,
                                                        paddingH: 10),
                                                  ],
                                                ),
                                              ],
                                            ),


                                            5.verticalSpace,
                                            CommonTextWidget(heading: logic.demoList[index].desc ?? "",
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
                                  );
                                }),
                          ),
                        ],
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
