import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/widgets/button_loader.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../backend/helper/appRoute.dart';
import '../../backend/models/get_profile.model.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../utils/constants.dart';
import '../../widgets/commonTextWidget.dart';
import '../../widgets/laod_image.dart';
import 'home_screen_logic.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  final HomeScreenLogic logic = Get.put(HomeScreenLogic(state: Get.find()));

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      logic.profileApi();
      logic.dashboardDetailsApi();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenLogic>(
      init: HomeScreenLogic(state: Get.find()),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ThemeProvider.scaffolderColor,
            appBar: AppBar(
              toolbarHeight: Get.height * .13,
              flexibleSpace: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 60.sp,
                            width: 60.sp,
                            decoration: const BoxDecoration(shape: BoxShape.circle),
                            child: ClipOval(
                              child: GetProfileModel().data?.image != null
                                  ? loadImage(image: Constants.baseImageUrl + GetProfileModel().data!.image, size: 60.sp)
                                  : Image.asset(AssetPath.imgDemo, height: 95.sp, width: 95.sp, fit: BoxFit.cover),
                            ),
                          ),

                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonTextWidget(
                                  heading: "Hello, ${GetProfileModel().data?.name ?? "User"}",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: ThemeProvider.greenDarkColor,
                                  paddingH: 10,
                                  textAlign: TextAlign.start,
                                ),
                                5.verticalSpace,
                                CommonTextWidget(
                                  heading: "How are you feeling today?",
                                  fontSize: 14,
                                  textOverflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeProvider.blackColor,
                                  paddingH: 10,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () => Get.toNamed(AppRouter.notificationScreen),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: ThemeProvider.greenDarkColor, borderRadius: BorderRadius.all(Radius.circular(100))),
                        child: SvgPicture.asset(AssetPath.iconNoti),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.sp),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [],
                body: GetBuilder<HomeScreenLogic>(
                  builder: (_) {
                    return Obx(() {
                      return logic.mainLoader.value
                          ? Center(child: ButtonLoader())
                          : ListView(
                              children: [
                                10.verticalSpace,
                                Container(
                                  height: Get.height * .2,
                                  decoration: BoxDecoration(color: ThemeProvider.greenDarkColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                                  child: Stack(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        spacing: 10.sp,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                spacing: 10.sp,
                                                children: [
                                                  CommonTextWidget(
                                                    heading: "Your Wellness Score",
                                                    textAlign: TextAlign.start,
                                                    fontSize: 16,
                                                    color: ThemeProvider.whiteColor,
                                                    paddingH: 20,
                                                  ),
                                                  CommonTextWidget(
                                                    heading: "Based on last 7 days",
                                                    textAlign: TextAlign.start,
                                                    fontSize: 12,
                                                    color: ThemeProvider.whiteColor,
                                                    paddingH: 20,
                                                  ),

                                                  CommonTextWidget(
                                                    heading: "* Daily tracking completion",
                                                    textAlign: TextAlign.start,
                                                    fontSize: 12,
                                                    color: ThemeProvider.whiteColor,
                                                    paddingH: 20,
                                                  ),
                                                  CommonTextWidget(
                                                    heading: "* Journal entry created",
                                                    textAlign: TextAlign.start,
                                                    fontSize: 12,
                                                    color: ThemeProvider.whiteColor,
                                                    paddingH: 20,
                                                  ),
                                                  CommonTextWidget(
                                                    heading: "* Breathing/Meditation completed",
                                                    textAlign: TextAlign.start,
                                                    fontSize: 12,
                                                    color: ThemeProvider.whiteColor,
                                                    paddingH: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsetsGeometry.only(top: 10, right: 10),
                                            child: CircularPercentIndicator(
                                              radius: 25.sp,
                                              lineWidth: 7.sp,
                                              animation: true,
                                              percent: logic.wellScore,
                                              center: CommonTextWidget(
                                                heading: "${logic.getDashboardModel.data?.wellnessScore ?? 0}%",
                                                fontSize: 12,
                                                maxLine: 2,
                                                color: ThemeProvider.whiteColor,
                                              ),
                                              circularStrokeCap: CircularStrokeCap.round,
                                              backgroundColor: ThemeProvider.whiteColor,
                                              progressColor: ThemeProvider.progressBarColor,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: SvgPicture.asset(AssetPath.bannerHome, height: 65.sp),
                                      ),
                                    ],
                                  ),
                                ),

                                20.verticalSpace,
                                Row(
                                  spacing: 15.sp,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
                                        decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          spacing: 10.sp,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              spacing: 5.sp,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: ThemeProvider.greenDarkColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                                  ),
                                                  child: SvgPicture.asset(AssetPath.iconDrop),
                                                ),

                                                CommonTextWidget(heading: "Hydration", fontSize: 16, color: ThemeProvider.greenDarkColor, paddingH: 5),
                                              ],
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  text: "${logic.getDashboardModel.data?.streaks?.hydration ?? "0"}",
                                                  style: TextStyle(
                                                    color: ThemeProvider.greenDarkColor,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 15.sp,
                                                    fontFamily: "inter",
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: " ",
                                                      style: TextStyle(color: ThemeProvider.descColor, fontFamily: "inter"),
                                                    ),
                                                    TextSpan(
                                                      text: 'day streak',
                                                      style: TextStyle(
                                                        color: ThemeProvider.blackColor,
                                                        fontSize: 12.sp,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: "inter",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
                                        decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          spacing: 10.sp,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              spacing: 5.sp,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: ThemeProvider.greenDarkColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                                  ),
                                                  child: SvgPicture.asset(AssetPath.iconNote),
                                                ),

                                                CommonTextWidget(heading: "Journaling", fontSize: 16, color: ThemeProvider.greenDarkColor, paddingH: 5),
                                              ],
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  text: "${logic.getDashboardModel.data?.streaks?.journaling ?? "0"}",
                                                  style: TextStyle(
                                                    color: ThemeProvider.blackColor,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 15.sp,
                                                    fontFamily: "inter",
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: " ",
                                                      style: TextStyle(color: ThemeProvider.descColor, fontFamily: "inter"),
                                                    ),
                                                    TextSpan(
                                                      text: 'day streak',
                                                      style: TextStyle(
                                                        color: ThemeProvider.blackColor,
                                                        fontSize: 12.sp,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: "inter",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                20.verticalSpace,
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
                                  decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 10.sp,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        spacing: 5.sp,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: ThemeProvider.greenDarkColor,
                                              borderRadius: BorderRadius.all(Radius.circular(100)),
                                            ),
                                            child: SvgPicture.asset(AssetPath.iconSparkles, height: 25),
                                          ),

                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            spacing: 5.sp,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CommonTextWidget(heading: "Today's Inspiration", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 5),
                                              CommonTextWidget(
                                                heading: "Refreshes daily",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: ThemeProvider.blackColor,
                                                paddingH: 5,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      CommonTextWidget(
                                        heading: '"${logic.getDashboardModel.data?.dailyQuote?.text}"',
                                        fontSize: 18,
                                        color: ThemeProvider.greenDarkColor,
                                        fontWeight: FontWeight.w500,
                                        paddingH: 5,
                                        maxLine: 3,
                                        lineHeight: 1.5,
                                      ),

                                      GestureDetector(
                                        onTap: () =>
                                            Get.toNamed(AppRouter.inspirationScreen),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              text: "View more quotes",
                                              style: TextStyle(
                                                color: ThemeProvider.blackColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.sp,
                                                fontFamily: "inter",
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: " ",
                                                  style: TextStyle(color: ThemeProvider.descColor, fontFamily: "inter"),
                                                ),

                                                WidgetSpan(
                                                  alignment: PlaceholderAlignment.middle,
                                                  child: Icon(Icons.arrow_forward, color: ThemeProvider.blackColor, size: 15.sp),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                20.verticalSpace,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  spacing: 5.sp,
                                  children: [
                                    CommonTextWidget(heading: "Today's Wellness Snapshot", fontSize: 16, color: ThemeProvider.greenDarkColor, paddingH: 5),
                                    GestureDetector(
                                      onTap: () => Get.toNamed(AppRouter.dailyProgressPage)?.then((value) => logic.dashboardDetailsApi()),
                                      child: CommonTextWidget(
                                        heading: "View All",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: ThemeProvider.greenDarkColor,
                                        paddingH: 5,
                                      ),
                                    ),
                                  ],
                                ),

                                20.verticalSpace,
                                SizedBox(
                                  height: Get.height * .15,
                                  child: ListView.builder(
                                    itemCount: logic.list.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        child: Container(
                                          width: Get.width * .4,
                                          height: Get.height * .4,
                                          padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 8.sp),
                                          margin: EdgeInsets.symmetric(horizontal: 5.sp),
                                          decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            spacing: 8.sp,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                spacing: 5.sp,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: ThemeProvider.greenDarkColor,
                                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                                    ),
                                                    child: SvgPicture.asset(logic.list[index].icon, height: 20, color: ThemeProvider.whiteColor),
                                                  ),
                                                  CommonTextWidget(
                                                    heading: logic.list[index].title,
                                                    fontSize: 16,
                                                    color: ThemeProvider.blackColor,
                                                    paddingH: 5,
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: CommonTextWidget(heading: logic.list[index].score, fontSize: 14, color: ThemeProvider.greenDarkColor),
                                              ),
                                              CommonTextWidget(
                                                heading: logic.list[index].desc,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: ThemeProvider.blackColor,
                                                paddingH: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                30.verticalSpace,
                              ],
                            );
                    });
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
