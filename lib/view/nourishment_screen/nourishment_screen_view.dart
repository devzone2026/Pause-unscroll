import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/backend/helper/appRoute.dart';
import 'package:pause_and_scroll/utils/validations.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonTextWidget.dart';
import 'nourishment_screen_logic.dart';

class NourishmentScreenPage extends StatefulWidget {
  const NourishmentScreenPage({super.key});

  @override
  State<NourishmentScreenPage> createState() => _NourishmentScreenPageState();
}

class _NourishmentScreenPageState extends State<NourishmentScreenPage> {
  final NourishmentScreenLogic logic = Get.put(NourishmentScreenLogic(state: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.scaffolderColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.sp),
          child: NestedScrollView(headerSliverBuilder: (context, innerBoxIsScrolled) => [],
              body: Column(
                children: [
                  30.verticalSpace,

                  CommonTextWidget(
                    heading: "Nourishment & Energy",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: ThemeProvider.greenDarkColor,
                    paddingH: 20,
                    textAlign: TextAlign.center,
                  ),
                  10.verticalSpace,
                  CommonTextWidget(
                    heading: "How are you feeling right now?",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ThemeProvider.blackColor,
                    paddingH: 20,
                    textAlign: TextAlign.center,
                  ),

                  20.verticalSpace,
                  Expanded(
                    child: ListView.builder(
                        itemCount: logic.list.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              logic.clickedItem = logic.list[index];
                              Get.toNamed(AppRouter.nourishmentScreenInfo);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10.sp),
                              padding: EdgeInsets.symmetric(vertical: 20.sp),
                              decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: ThemeProvider.greenDarkColor,
                                          borderRadius: BorderRadius.all(Radius.circular(100))
                                      ),
                                      child:  logic.list[index].icon.endsWith('.svg')
                                          ? SvgPicture.asset(logic.list[index].icon, color: ThemeProvider.whiteColor)
                                          : Image.asset(logic.list[index].icon, height: 30, width: 30,color: ThemeProvider.whiteColor),
                                    ),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      spacing: 5.sp,
                                      children: [
                                        CommonTextWidget(heading: logic.list[index].title , fontSize: 16, color: ThemeProvider.blackColor, paddingH: 20),
                                        CommonTextWidget(heading: "View suggestion",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: ThemeProvider.blackColor,
                                            paddingH: 20),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
