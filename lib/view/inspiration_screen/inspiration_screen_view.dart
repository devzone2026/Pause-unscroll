import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pause_and_scroll/widgets/button_loader.dart';
import '../../backend/helper/appRoute.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonTextWidget.dart';
import 'inspiration_screen_logic.dart';

class InspirationScreenPage extends StatefulWidget {
  const InspirationScreenPage({super.key});

  @override
  State<InspirationScreenPage> createState() => _InspirationScreenPageState();
}

class _InspirationScreenPageState extends State<InspirationScreenPage> {
  final InspirationScreenLogic logic = Get.put(InspirationScreenLogic(state: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.scaffolderColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.sp),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [

              SliverAppBar(
                backgroundColor: ThemeProvider.scaffolderColor,
                scrolledUnderElevation: 0,
                elevation: 0,
                pinned: true,
                floating: false,
                expandedHeight: 220.sp,
                // ✅ This collapses when scrolled (title, subtitle, button)
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(gradient: ThemeProvider.mainGradient, borderRadius: BorderRadius.all(Radius.circular(100))),
                        child: SvgPicture.asset(AssetPath.iconSparkles, color: ThemeProvider.whiteColor),
                      ),
                      12.verticalSpace,
                      CommonTextWidget(
                        heading: "Daily Inspiration",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: ThemeProvider.greenDarkColor,
                        paddingH: 20,
                        textAlign: TextAlign.center,
                      ),
                      10.verticalSpace,
                      CommonTextWidget(
                        heading: DateFormat('EEEE, MMMM d').format(DateTime.now()),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ThemeProvider.blackColor,
                        paddingH: 20,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),


            ],
            body: Obx(() {
              return logic.mainLoader.value
                  ? Center(child: ButtonLoader())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        30.verticalSpace,
                        Container(
                          margin: EdgeInsets.only(top: 10.sp),
                          padding: EdgeInsets.symmetric(vertical: 20.sp),
                          decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 5.sp,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(gradient: ThemeProvider.mainGradient, borderRadius: BorderRadius.all(Radius.circular(100))),
                                  child: CommonTextWidget(
                                    heading: logic.getInspirationModel.data?[0].category ?? "",
                                    fontSize: 12,
                                    color: ThemeProvider.whiteColor,
                                  ),
                                ),

                                CommonTextWidget(
                                  heading: '"${logic.getInspirationModel.data?[0].text}"',
                                  fontSize: 24,
                                  color: ThemeProvider.blackColor,
                                  maxLine: 3,
                                  lineHeight: 1.5,
                                ),
                              ],
                            ),
                          ),
                        ),

                        18.verticalSpace,
                        CommonTextWidget(
                          heading: 'All Quotes',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: ThemeProvider.greenDarkColor,
                          textAlign: TextAlign.start,
                        ),
                        12.verticalSpace,

                        if (logic.getInspirationModel.data != null)
                          Expanded(
                            child: ListView.builder(
                              itemCount: logic.getInspirationModel.data?.length ?? 0 + 1,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                // ← Last item = footer
                                if (index == 10) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15.sp),
                                    child: Column(
                                      spacing: 10.sp,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 10.sp),
                                          padding: EdgeInsets.symmetric(vertical: 20.sp),
                                          decoration: BoxDecoration(
                                            color: ThemeProvider.scaffolderColor1.withValues(alpha: .3),
                                            borderRadius: BorderRadius.all(Radius.circular(15.sp)),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            child: CommonTextWidget(
                                              heading:
                                                  "Take a moment to let these words settle. There's no rush, no pressure. Just gentle encouragement for wherever you are today.",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              maxLine: 5,
                                              color: ThemeProvider.greenDarkColor,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),

                                        CommonTextWidget(
                                          heading: "A new quote appears each day",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          maxLine: 5,
                                          color: ThemeProvider.hintColor,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppRouter.nourishmentScreenInfo
                                        ,arguments: [logic.getInspirationModel.data?[index].category ?? ""]);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10.sp),
                                    padding: EdgeInsets.symmetric(vertical: 20.sp),
                                    decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        spacing: 5.sp,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                            decoration: BoxDecoration(
                                              gradient: ThemeProvider.mainGradient,
                                              borderRadius: BorderRadius.all(Radius.circular(100)),
                                            ),
                                            child: CommonTextWidget(
                                              heading: logic.getInspirationModel.data?[index].category ?? "",
                                              fontSize: 12,
                                              color: ThemeProvider.whiteColor,
                                            ),
                                          ),
                                          CommonTextWidget(
                                            heading: '"${logic.getInspirationModel.data?[index].text ?? ""}"',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: ThemeProvider.blackColor,
                                            maxLine: 3,
                                            textOverflow: TextOverflow.ellipsis,
                                            lineHeight: 1.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    );
            }),
          ),
        ),
      ),
    );
  }
}
