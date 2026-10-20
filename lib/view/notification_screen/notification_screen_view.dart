import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pause_and_scroll/utils/appTheme.dart';
import 'package:pause_and_scroll/widgets/button_loader.dart';
import 'package:pause_and_scroll/widgets/commonTextWidget.dart';
import '../../utils/appAssets.dart';
import 'notification_screen_logic.dart';

class NotificationScreenPage extends StatefulWidget {
  const NotificationScreenPage({super.key});

  @override
  State<NotificationScreenPage> createState() => _NotificationScreenPageState();
}

class _NotificationScreenPageState extends State<NotificationScreenPage> {
  final NotificationScreenLogic logic = Get.put(NotificationScreenLogic(state: Get.find()));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(!logic.deleteModeEnable.value){
          Get.back();
        }else{
          logic.deleteList.clear();
          logic.deleteModeEnable.value = false;
          logic.update();
        }
        return Future.value(false);
      },
      child: GetBuilder(
        init: NotificationScreenLogic(state: Get.find()),
        builder: (controller) =>
            Scaffold(
                backgroundColor: ThemeProvider.scaffolderColor,
                appBar: AppBar(
                  scrolledUnderElevation: 0,
                  backgroundColor: ThemeProvider.scaffolderColor,
                  centerTitle: true,
                  title: CommonTextWidget(heading: "Notifications", fontWeight: FontWeight.w700, fontSize: 20, color: ThemeProvider.greenDarkColor),
                  leading: GestureDetector(
                    onTap: () {
                      if(!logic.deleteModeEnable.value){
                        Get.back();
                      }else{
                        logic.deleteList.clear();
                        logic.deleteModeEnable.value = false;
                        logic.update();
                      }
                    },
                    child: Obx(() {
                      return Icon(
                          !logic.deleteModeEnable.value
                              ? Icons.arrow_back_sharp : Icons.close, color: ThemeProvider.greenDarkColor, size: 20.sp);
                    }),
                  ),
                  actions: [
                    if(logic.deleteModeEnable.value)
                      IconButton(onPressed: () => logic.deleteNotificationApi(),
                          icon: Icon(Icons.delete, color: ThemeProvider.greenDarkColor, size: 20.sp))
                  ],
                ),
                body: Obx(() {
                  if (logic.mainLoader.value) {
                    return Center(child: ButtonLoader());
                  } else {
                    if (logic.getNotificationModel.data!.isEmpty) {
                      return Container(child: noData(context));
                    } else {
                      return Container(child: dataList(context));
                    }
                  }
                })
            ),
      ),
    );
  }

  Widget? dataList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: logic.getNotificationModel.data?.length,
      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPress: () {
            logic.deleteModeEnable.value = true;
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
            padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
            decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Stack(
              children: [

                Obx(() {
                  return logic.deleteModeEnable.value
                      ? GestureDetector(
                    onTap: () {
                      String id = logic.getNotificationModel.data?[index].id ?? "";
                      if (logic.deleteList.contains(id)) {
                        logic.deleteList.remove(id);
                      } else {
                        logic.deleteList.add(id);
                      }
                      logic.update();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        logic.deleteList.contains(logic.getNotificationModel.data?[index].id ?? "")
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: ThemeProvider.greenDarkColor,
                      ),
                    ),
                  )
                      : SizedBox();
                }),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 5.sp,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: DateFormat('MMM d, yyyy').format(DateTime.parse(logic.getNotificationModel.data?[index].createdAt ?? "")),
                        style: TextStyle(color: ThemeProvider.descColor, fontWeight: FontWeight.w500, fontSize: 12.sp, fontFamily: "inter"),
                        children: [
                          TextSpan(
                            text: " • ",
                            style: TextStyle(color: ThemeProvider.descColor, fontFamily: "inter"),
                          ),
                          TextSpan(
                            text: DateFormat('h:mm a').format(DateTime.parse(logic.getNotificationModel.data?[index].createdAt ?? "").toLocal()),
                            style: TextStyle(color: ThemeProvider.descColor, fontWeight: FontWeight.w500, fontFamily: "inter"),
                          ),
                        ],
                      ),
                    ),
                    2.verticalSpace,
                    CommonTextWidget(
                        heading: logic.getNotificationModel.data?[index].title ?? "",
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: ThemeProvider.blackColor),
                    2.verticalSpace,
                    CommonTextWidget(
                      heading: logic.getNotificationModel.data?[index].body ?? "",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      maxLine: 5,
                      color: ThemeProvider.descColor,
                    ),
                    2.verticalSpace,
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget? noData(BuildContext context) {
    return ListView(
      children: [
        25.verticalSpace,
        Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(color: ThemeProvider.greenDarkColor, borderRadius: BorderRadius.all(Radius.circular(100))),
            child: SvgPicture.asset(AssetPath.iconNotiNone),
          ),
        ),
        15.verticalSpace,
        CommonTextWidget(
          heading: "No Notification Yet",
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: ThemeProvider.blackColor,
          textAlign: TextAlign.center,
        ),
        10.verticalSpace,
        CommonTextWidget(
          heading: "When reminders are sent, they’ll appear here.",
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: ThemeProvider.blackColor,
          textAlign: TextAlign.center,
        ),

        50.verticalSpace,
        SvgPicture.asset(AssetPath.bannerNotify),
      ],
    );
  }
}
