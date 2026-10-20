import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/widgets/custom_tabbar.dart';
import 'package:pause_and_scroll/widgets/screen_loader.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonTextWidget.dart';
import 'daily_progress_logic.dart';

class DailyProgressPage extends StatefulWidget {
  const DailyProgressPage({super.key});

  @override
  State<DailyProgressPage> createState() => _DailyProgressPageState();
}

class _DailyProgressPageState extends State<DailyProgressPage> {
  final DailyProgressLogic logic = Get.put(DailyProgressLogic(state: Get.find()));

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DailyProgressLogic(state: Get.find()),
      builder: (controller) =>
          Scaffold(
            backgroundColor: ThemeProvider.scaffolderColor,
            appBar: AppBar(scrolledUnderElevation: 0, backgroundColor: ThemeProvider.scaffolderColor, centerTitle: true),
            body: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              CommonTextWidget(heading: "Daily Progress", fontWeight: FontWeight.w700, fontSize: 16, color: ThemeProvider.greenDarkColor),
                              CommonTextWidget(
                                heading: "Track your wellness for today",
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: ThemeProvider.blackColor,
                              ),
                            ],
                          ),

                          10.verticalSpace,

                          Obx(() {
                            return Expanded(
                              child: logic.apiLoader.value
                                  ? Center(child: ScreenLoader())
                                  : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 15.sp),
                                    padding: EdgeInsets.symmetric(vertical: 20.sp),
                                    decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        spacing: 10.sp,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: ThemeProvider.greenDarkColor,
                                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                                ),
                                                child: SvgPicture.asset(AssetPath.iconDrop, color: ThemeProvider.whiteColor),
                                              ),

                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  spacing: 5.sp,
                                                  children: [
                                                    CommonTextWidget(heading: "Hydration", fontSize: 14, color: ThemeProvider.blackColor, paddingH: 20),
                                                    CommonTextWidget(
                                                      heading: "${logic.dailyProgressModel.data?.hydrationIntake} / 8 glasses",
                                                      fontWeight: FontWeight.w500,
                                                      maxLine: 3,
                                                      fontSize: 12,
                                                      color: ThemeProvider.blackColor,
                                                      paddingH: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          CustomHydration(initialValue: logic.dailyProgressModel.data?.hydrationIntake ?? 0, onTabChanged: (value) {
                                            logic.dailyProgressModel.data?.hydrationIntake = value;
                                            logic.upDateDailyProgressApi(hydration: value);
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),

                                  5.verticalSpace,
                                  Container(
                                    margin: EdgeInsets.only(top: 15.sp),
                                    padding: EdgeInsets.symmetric(vertical: 15.sp),
                                    decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        spacing: 10.sp,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color: ThemeProvider.greenDarkColor,
                                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                                      ),
                                                      child: SvgPicture.asset(AssetPath.iconBrain, height: 22, color: ThemeProvider.whiteColor),
                                                    ),

                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        spacing: 5.sp,
                                                        children: [
                                                          CommonTextWidget(
                                                            heading: "Meditation",
                                                            fontSize: 14,
                                                            color: ThemeProvider.blackColor,
                                                            paddingH: 20,
                                                          ),
                                                          CommonTextWidget(
                                                            heading: "Minutes Practiced",
                                                            fontWeight: FontWeight.w500,
                                                            maxLine: 3,
                                                            fontSize: 12,
                                                            color: ThemeProvider.blackColor,
                                                            paddingH: 20,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              CommonTextWidget(
                                                heading: (logic.dailyProgressModel.data!.localMeditationTime/60).toInt().toString(),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: ThemeProvider.blackColor,
                                                paddingH: 20,
                                              ),
                                            ],
                                          ),

                                          5.verticalSpace,
                                          Column(
                                            spacing: 10,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                child: SliderTheme(
                                                  data: SliderTheme.of(context).copyWith(
                                                    trackHeight: 12.sp,
                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                                                    overlayShape: SliderComponentShape.noOverlay,
                                                  ),
                                                  child: Slider(
                                                    value: logic.dailyProgressModel.data!.localMeditationTime.toDouble(),
                                                    min: 0,
                                                    max: 7200,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        logic.dailyProgressModel.data?.localMeditationTime = value.toInt();
                                                      });
                                                    },
                                                    activeColor: ThemeProvider.greenDarkColor.withValues(alpha: .8),
                                                    inactiveColor: ThemeProvider.textFieldBorderColor,
                                                  ),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    CommonTextWidget(
                                                      heading: "0",
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700,
                                                      color: ThemeProvider.greenDarkColor,
                                                      textAlign: TextAlign.center,
                                                    ),

                                                    CommonTextWidget(
                                                      heading: "120 min",
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700,
                                                      color: ThemeProvider.greenDarkColor,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  5.verticalSpace,
                                  Container(
                                    margin: EdgeInsets.only(top: 15.sp),
                                    padding: EdgeInsets.symmetric(vertical: 15.sp),
                                    decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        spacing: 10.sp,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color: ThemeProvider.greenDarkColor,
                                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                                      ),
                                                      child: SvgPicture.asset(AssetPath.iconEmoji, color: ThemeProvider.whiteColor, height: 22),
                                                    ),

                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        spacing: 5.sp,
                                                        children: [
                                                          CommonTextWidget(heading: "Mood", fontSize: 14, color: ThemeProvider.blackColor, paddingH: 20),
                                                          CommonTextWidget(
                                                            heading: "How are you feeling?",
                                                            fontWeight: FontWeight.w500,
                                                            maxLine: 3,
                                                            fontSize: 12,
                                                            color: ThemeProvider.blackColor,
                                                            paddingH: 20,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SvgPicture.asset(AssetPath.iconSmileEyes, height: 22),
                                            ],
                                          ),

                                          5.verticalSpace,
                                          Column(
                                            spacing: 10,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                child: SliderTheme(
                                                  data: SliderTheme.of(context).copyWith(
                                                    trackHeight: 12.sp,
                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                                                    overlayShape: SliderComponentShape.noOverlay,
                                                  ),
                                                  child: Slider(
                                                    value: logic.dailyProgressModel.data?.localMoodTime.toDouble() ?? 0.0,
                                                    min: 0,
                                                    max: 120,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        logic.dailyProgressModel.data?.localMoodTime = value.toInt();
                                                        Future.delayed(Duration(seconds: 1), () {
                                                          logic.upDateDailyProgressApi(mood: value.toInt());
                                                        });
                                                      });
                                                    },
                                                    activeColor: ThemeProvider.greenDarkColor.withValues(alpha: .8),
                                                    inactiveColor: ThemeProvider.textFieldBorderColor,
                                                  ),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    CommonTextWidget(
                                                      heading: "Low",
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700,
                                                      color: ThemeProvider.greenDarkColor,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    CommonTextWidget(
                                                      heading: "${logic.dailyProgressModel.data?.localMoodTime}/100",
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700,
                                                      color: ThemeProvider.greenDarkColor,
                                                      textAlign: TextAlign.center,
                                                    ),

                                                    CommonTextWidget(
                                                      heading: "High",
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700,
                                                      color: ThemeProvider.greenDarkColor,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  5.verticalSpace,
                                  Container(
                                    margin: EdgeInsets.only(top: 15.sp),
                                    padding: EdgeInsets.symmetric(vertical: 15.sp),
                                    decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        spacing: 10.sp,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color: ThemeProvider.greenDarkColor,
                                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                                      ),
                                                      child: SvgPicture.asset(AssetPath.iconDumBell, height: 25, color: ThemeProvider.whiteColor),
                                                    ),

                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        spacing: 5.sp,
                                                        children: [
                                                          CommonTextWidget(heading: "Workout", fontSize: 14, color: ThemeProvider.blackColor, paddingH: 20),
                                                          CommonTextWidget(
                                                            heading: "Duration",
                                                            fontWeight: FontWeight.w500,
                                                            maxLine: 3,
                                                            fontSize: 12,
                                                            color: ThemeProvider.blackColor,
                                                            paddingH: 20,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              CommonTextWidget(
                                                heading: "${logic.dailyProgressModel.data?.localWorkoutTime.toDouble() ?? 0.0} m",
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: ThemeProvider.blackColor,
                                                paddingH: 20,
                                              ),
                                            ],
                                          ),

                                          5.verticalSpace,
                                          Column(
                                            spacing: 10,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                child: SliderTheme(
                                                  data: SliderTheme.of(context).copyWith(
                                                    trackHeight: 12.sp,
                                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                                                    overlayShape: SliderComponentShape.noOverlay,
                                                  ),
                                                  child: Slider(
                                                    value: logic.dailyProgressModel.data?.localWorkoutTime.toDouble() ?? 0.0,
                                                    min: 0,
                                                    max: 120,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        logic.dailyProgressModel.data?.localWorkoutTime = value.toInt();
                                                        Future.delayed(Duration(seconds: 1), () {
                                                          logic.upDateDailyProgressApi(workoutMinutes: value.toInt());
                                                        });
                                                      });
                                                    },
                                                    activeColor: ThemeProvider.greenDarkColor.withValues(alpha: .8),
                                                    inactiveColor: ThemeProvider.textFieldBorderColor,
                                                  ),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    CommonTextWidget(
                                                      heading: "0",
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700,
                                                      color: ThemeProvider.greenDarkColor,
                                                      textAlign: TextAlign.center,
                                                    ),

                                                    CommonTextWidget(
                                                      heading: "3h 30m",
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700,
                                                      color: ThemeProvider.greenDarkColor,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
