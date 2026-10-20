import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/widgets/commonButtonWidget1.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonTextWidget.dart';
import 'breathing_exercises_logic.dart';

class StartBreathingScreen extends StatefulWidget {
  const StartBreathingScreen({super.key});

  @override
  State<StartBreathingScreen> createState() => _StartBreathingScreenState();
}

class _StartBreathingScreenState extends State<StartBreathingScreen> {
  // Use find() instead of put() — controller is already registered upstream
  late final BreathingExercisesLogic logic = Get.find<BreathingExercisesLogic>();

  @override
  void dispose() {
    logic.resetSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BreathingExercisesLogic(state: Get.find()),
      builder: (controller) => Scaffold(
        backgroundColor: ThemeProvider.scaffolderColor,
        appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: ThemeProvider.scaffolderColor),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.sp),
            // NestedScrollView with no slivers and a non-scrolling body is redundant — removed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                30.verticalSpace,

                // Static data — no need for Obx or GetBuilder
                if (logic.isThisExercise)
                  CommonTextWidget(
                    heading: logic.workingBreathClass.name ?? "",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: ThemeProvider.greenDarkColor,
                    textAlign: TextAlign.center,
                  ),
                20.verticalSpace,

                // Reactive elapsed timer
                Obx(() {
                  if (logic.isThisExercise) {
                    return CommonTextWidget(
                      heading: logic.formatTime(logic.elapsedSeconds.value),
                      fontSize: 60.sp,
                      fontWeight: FontWeight.w900,
                      color: ThemeProvider.blackColor,
                      textAlign: TextAlign.center,
                    );
                  } else {
                    final seconds = logic.isIdle
                        ? logic.setTimeLimit.value *
                              60 // convert minutes → seconds
                        : logic.remainingSeconds.value;
                    return CommonTextWidget(
                      heading: logic.formatTime(seconds),
                      fontSize: 60.sp,
                      fontWeight: FontWeight.w900,
                      color: ThemeProvider.blackColor,
                      textAlign: TextAlign.center,
                    );
                  }
                }),
                10.verticalSpace,

                if (!logic.isThisExercise)
                  CommonTextWidget(
                    heading: "Minutes",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: ThemeProvider.hintColor,
                    paddingH: 20,
                    textAlign: TextAlign.center,
                  ),

                // "minutes" label — removed isThisExercise flag (field deleted in optimized controller)
                // Add back here if you re-introduce that flag
                40.verticalSpace,

                // Phase card
                Container(
                  width: double.infinity,
                  height: Get.height * .25,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.sp), color: ThemeProvider.whiteColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Reactive phase label + countdown
                      if (logic.isThisExercise)
                        Obx(
                          () => RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: logic.phaseCountdown.value.toString(),
                              style: TextStyle(color: ThemeProvider.blackColor, fontWeight: FontWeight.w800, fontSize: 30.sp, fontFamily: "inter"),
                              children: [
                                const TextSpan(text: "\n"),
                                TextSpan(
                                  // Use the typed enum label getter instead of raw .value
                                  text: logic.phaseLabel,
                                  style: TextStyle(color: ThemeProvider.blackColor, fontWeight: FontWeight.w800, fontSize: 14.sp, fontFamily: "inter"),
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (logic.isThisExercise) 20.verticalSpace,
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(width: 50.sp, height: 50.sp, child: SvgPicture.asset(AssetPath.iconRecord)),

                          if (!logic.isThisExercise)
                            Obx(() {
                              return CircularPercentIndicator(
                                radius: 60.0,
                                lineWidth: 12.0,
                                animation: true,
                                reverse: false,
                                animateFromLastPercent: true,
                                animationDuration: 900,
                                percent: logic.progress,
                                circularStrokeCap: CircularStrokeCap.round,
                                backgroundColor: ThemeProvider.textFieldBorderColor,
                                progressColor: ThemeProvider.greenDarkColor.withValues(alpha: .8),
                              );
                            }),
                        ],
                      ),
                    ],
                  ),
                ),

                50.verticalSpace,

                // Action buttons
                Row(
                  children: [
                    // Play / Pause / Resume button
                    Obx(() {
                      final status = logic.sessionStatus.value;
                      return Flexible(
                        child: CommonButtonWidget1(
                          onPressed: logic.toggleSession,
                          title: switch (status) {
                            SessionStatus.idle => "Play",
                            SessionStatus.paused => "Resume",
                            SessionStatus.running => "Pause",
                          },
                          titleColor: ThemeProvider.whiteColor,
                          fontSize: 15,
                          firstGradientColor: !logic.exerciseComplete.value ? ThemeProvider.greenDarkColor : ThemeProvider.greenLiteColor,
                          secondGradientColor: !logic.exerciseComplete.value ? ThemeProvider.greenDarkColor : ThemeProvider.greenLiteColor,
                          showIcon: true,
                          icon: status == SessionStatus.running
                              ? AssetPath
                                    .iconPlay // show pause icon
                              : AssetPath.iconPlayer, // show play icon
                        ),
                      );
                    }),

                    10.horizontalSpace,

                    // Stop / Save button
                    Obx(() {
                      return Flexible(
                        child: CommonButtonWidget1(
                          onPressed: () {
                            if (!logic.exerciseComplete.value) {
                              logic.exerciseComplete.value = true;
                              logic.stopSession(value: true);
                            } else {
                              logic.saveLoader.value = true;
                              logic.saveBreathingTechniquesApi(
                                totalSecond: logic.totalSecondSaved,
                                breathId: logic.workingBreathClass.id ?? "",
                                musicId: logic.musicBody.id,
                              );
                            }
                          },
                          isLoading: logic.exerciseComplete.value ? logic.saveLoader.value : false,
                          title: logic.exerciseComplete.value ? "Save" : "Stop",
                          fontSize: 15,
                          firstGradientColor: ThemeProvider.textFieldBorderColor,
                          secondGradientColor: ThemeProvider.textFieldBorderColor,
                          showIcon: true,
                          icon: logic.exerciseComplete.value ? null : AssetPath.iconStop,
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
