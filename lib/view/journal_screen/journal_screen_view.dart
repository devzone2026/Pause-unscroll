import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/backend/helper/appRoute.dart';
import 'package:pause_and_scroll/utils/utils_methods.dart';
import 'package:pause_and_scroll/widgets/commonButtonWidget.dart';
import 'package:pause_and_scroll/widgets/screen_loader.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonTextWidget.dart';
import 'journal_screen_logic.dart';

class JournalScreenPage extends StatefulWidget {
  const JournalScreenPage({super.key});

  @override
  State<JournalScreenPage> createState() => _JournalScreenPageState();
}

class _JournalScreenPageState extends State<JournalScreenPage> {
  final JournalScreenLogic logic = Get.put(JournalScreenLogic(state: Get.find()));

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: JournalScreenLogic(state: Get.find()),
      builder: (controller) => Scaffold(
        backgroundColor: ThemeProvider.scaffolderColor,
        appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: ThemeProvider.scaffolderColor, centerTitle: true),
        body: NotificationListener<ScrollNotification>(
          onNotification: logic.onScrollNotification,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.sp),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        CommonTextWidget(heading: "Journal", fontWeight: FontWeight.w700, fontSize: 16, color: ThemeProvider.greenDarkColor),
                        CommonTextWidget(
                          heading: logic.listLength == 0 ? "Start your journaling journey" : "${logic.listLength} entry",
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: ThemeProvider.blackColor,
                        ),
                      ],
                    ),

                    CommonButtonWidget(
                      onPressed: () => Get.toNamed(AppRouter.createJournalScreen),
                      title: "New Entry",
                      width: 100,
                      height: 30,
                      fontSize: 10,
                      showIcon: true,
                      icon: AssetPath.iconAdd,
                      paddingH: 0,
                    ),
                  ],
                ),

                Obx(() {
                  return Expanded(
                    child: (logic.apiLoader.value)
                        ? ScreenLoader()
                        : Column(
                            children: [
                              20.verticalSpace,
                              if (logic.journalList.isEmpty)
                                Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: Get.height * .25,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.sp), color: ThemeProvider.whiteColor),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        spacing: 10,
                                        children: [
                                          CommonTextWidget(
                                            heading: "No journal entries yet",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: ThemeProvider.blackColor.withValues(alpha: .5),
                                          ),

                                          CommonButtonWidget(onPressed: () => Get.toNamed(AppRouter.createJournalScreen), title: "Write your First Entry", width: double.infinity, paddingH: 15),
                                        ],
                                      ),
                                    ),
                                    50.verticalSpace,
                                    SvgPicture.asset(AssetPath.bannerJournal, height: 180.sp),
                                  ],
                                ),

                              Expanded(
                                child: ListView.builder(
                                  itemCount: logic.journalList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 15.sp),
                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                                      width: double.infinity,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.sp), color: ThemeProvider.whiteColor),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        spacing: 5,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: CommonTextWidget(
                                                  heading: formatChatDate(logic.journalList[index].createdAt ?? ""),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: ThemeProvider.blackColor,
                                                ),
                                              ),

                                              Row(
                                                spacing: 8,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => Get.toNamed(AppRouter.createJournalScreen, arguments: [logic.journalList[index].content,logic.journalList[index].id]),
                                                    child: SvgPicture.asset(AssetPath.iconEdit, color: ThemeProvider.blackColor, height: 20),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () => logic.deleteJournalApi(journalId: logic.journalList[index].id ?? ""),
                                                    child: SvgPicture.asset(AssetPath.iconDel, color: ThemeProvider.blackColor, height: 20),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          Wrap(
                                            spacing: 5,
                                            runSpacing: 5,
                                            children: [
                                              CommonTextWidget(
                                                heading: logic.journalList[index].content ?? "",
                                                maxLine: logic.journalList[index].isExpanded ? null : 2,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: ThemeProvider.blackColor,
                                              ),

                                              if(logic.journalList[index].content.toString().length > 50)
                                              GestureDetector(
                                                onTap: () => setState(() => logic.journalList[index].isExpanded = !logic.journalList[index].isExpanded),
                                                child: CommonTextWidget(
                                                  heading: logic.journalList[index].isExpanded ? "Show less" : "Show more",
                                                  maxLine: logic.journalList[index].isExpanded ? null : 2,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: ThemeProvider.greenDarkColor,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
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
      ),
    );
  }
}
