import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/widgets/commonButtonWidget.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/bottom_sheet_all_song.dart';
import '../../widgets/bottom_sheet_timer_selecter.dart';
import '../../widgets/commonTextWidget.dart';
import 'breathing_exercises_logic.dart';

class MeditationSetTimerScreen extends StatefulWidget {
  const MeditationSetTimerScreen({super.key});

  @override
  State<MeditationSetTimerScreen> createState() => _MeditationSetTimerScreenState();
}

class _MeditationSetTimerScreenState extends State<MeditationSetTimerScreen> {
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
      builder:(controller) =>  Scaffold(
        backgroundColor: ThemeProvider.scaffolderColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: ThemeProvider.scaffolderColor,
          centerTitle: true,
          title: CommonTextWidget(heading: "Set Timer", fontWeight: FontWeight.w700, fontSize: 20, color: ThemeProvider.greenDarkColor),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.sp),
            // NestedScrollView with no slivers and a non-scrolling body is redundant — removed
            child: NestedScrollView(headerSliverBuilder: (context, innerBoxIsScrolled) => [],
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    10.verticalSpace,
      
                    // Static data — no need for Obx or GetBuilder
                    CommonTextWidget(
                      heading: "How long would you like to meditate?",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: ThemeProvider.blackColor,
                      textAlign: TextAlign.center,
                    ),
                    40.verticalSpace,
      
      
                    if(logic.musicBody.id != null)
                      Container(
                        margin: EdgeInsets.only(top: 10.sp),
                        padding: EdgeInsets.symmetric(vertical: 15.sp),
                        decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 5.sp,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
      
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
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
                                          CommonTextWidget(heading: logic.musicBody.title ?? "", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 10),
                                          CommonTextWidget(heading: logic.musicBody.duration ?? "",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: ThemeProvider.blackColor,
                                              paddingH: 10),
                                        ],
                                      ),
                                    ],
                                  ),
      
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: ThemeProvider.greenDarkColor,
                                         borderRadius: BorderRadius.all(Radius.circular(100))
                                    ),
                                    child: Icon(Icons.check,color: ThemeProvider.whiteColor,size: 18.sp,),
                                  ),
      
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
      
                    20.verticalSpace,
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
                          Obx(
                                () => RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: logic.setTimeLimit.value.toString(),
                                style: TextStyle(color: ThemeProvider.blackColor, fontWeight: FontWeight.w800, fontSize: 30.sp, fontFamily: "inter"),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    final result = await showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => const IOSBottomSheet(),
                                    );
      
                                    if (result != null) {
                                      print("asdasdsad $result");
                                      logic.setTimeLimit.value = result;
                                    }
                                  },
      
                                children: [
                                  const TextSpan(text: "\n"),
                                  TextSpan(
                                    // Use the typed enum label getter instead of raw .value
                                    text: "Minutes",
                                    style: TextStyle(color: ThemeProvider.textHintColor, fontWeight: FontWeight.w800, fontSize: 14.sp, fontFamily: "inter"),
                                  ),
                                ],
                              ),
                            ),
                          ),
      
                          30.verticalSpace,
                          Column(
                            spacing: 5,
                            children: [
                              Obx(() {
                                final progress = (logic.setTimeLimit.value / 120);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 8.sp,
                                    borderRadius: BorderRadius.circular(10.sp),
                                    backgroundColor: ThemeProvider.textFieldBorderColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      ThemeProvider.greenDarkColor.withValues(alpha: .8),
                                    ),
                                  ),
                                );
                              }),
      
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
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
      
                    Expanded(child: SizedBox()),
      
                    CommonButtonWidget(
                      onPressed: () async{
                        final result = await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (_) => BottomSheetAllSong(logic, logic.songID),
                        );

                        logic.player.stop();
                        logic.getMusicList.data?.forEach((e) => e.demoPlay = false);

                        if (result != null) {
                          logic.musicBody = result;
                          await logic.player.setUrl(logic.musicBody.audioUrl ?? "");
                        }
                        logic.update();
                      },
                      title: (logic.musicBody.id != null) ? "Change Music" :"Select Music",
                      width: double.infinity,
                      paddingH: 0,
                      showIcon: true,
                      icon: AssetPath.iconMusic,
                    ),
      
                    CommonButtonWidget(
                      onPressed: () => logic.startSession(),
                      title: "Start Meditation",
                      width: double.infinity,
                      paddingH: 0,
                      showIcon: true,
                      icon: AssetPath.iconPlayer,
                    ),
                    20.verticalSpace,
      
                  ],
                ))
          ),
        ),
      ),
    );
  }
}
