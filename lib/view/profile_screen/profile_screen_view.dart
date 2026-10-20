import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/backend/helper/appRoute.dart';
import 'package:pause_and_scroll/dialogs/common_dialog.dart';
import 'package:pause_and_scroll/utils/appTheme.dart';
import 'package:pause_and_scroll/widgets/button_loader.dart';
import '../../backend/models/get_profile.model.dart';
import '../../utils/appAssets.dart';
import '../../utils/constants.dart';
import '../../widgets/commonTextWidget.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/laod_image.dart';
import '../home_screen/home_screen_logic.dart';
import 'profile_screen_logic.dart';

class ProfileScreenPage extends StatefulWidget {
  const ProfileScreenPage({super.key});

  @override
  State<ProfileScreenPage> createState() => _ProfileScreenPageState();
}

class _ProfileScreenPageState extends State<ProfileScreenPage> {
  final ProfileScreenLogic logic = Get.put(ProfileScreenLogic(state: Get.find()));
  final HomeScreenLogic homeLogic = Get.put(HomeScreenLogic(state: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.scaffolderColor,
      body: GetBuilder<HomeScreenLogic>(
        init: HomeScreenLogic(state: Get.find()),
        builder: (_) {
          logic.nameController.text = GetProfileModel().data?.name ?? "";
          logic.emailController.text = GetProfileModel().data?.email ?? "";
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.sp),
              child: Stack(
                children: [
                  ListView(
                    children: [
                      30.verticalSpace,

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonTextWidget(
                            heading: "Profile",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: ThemeProvider.greenDarkColor,
                            paddingH: 20,
                            textAlign: TextAlign.center,
                          ),
                          10.verticalSpace,
                          CommonTextWidget(
                            heading: "Manage your account",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ThemeProvider.blackColor,
                            paddingH: 20,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      20.verticalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
                        decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10.sp,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  height: 95.sp,
                                  width: 95.sp,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: GetProfileModel().data?.image != null
                                        ? loadImage(image: Constants.baseImageUrl + GetProfileModel().data!.image)
                                        : Image.asset(
                                      AssetPath.imgDemo,
                                      height: 95.sp,
                                      width: 95.sp,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () => Get.toNamed(AppRouter.profileScreenEditView),
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(gradient: ThemeProvider.mainGradient, borderRadius: BorderRadius.all(Radius.circular(100))),
                                    child: SvgPicture.asset(AssetPath.iconEdit),
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 2.sp,
                              children: [
                                CommonTextWidget(heading: "Name", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 10),
                                CustomTextField(
                                    readOnly: true, hintText: "Enter Name", controller: logic.nameController, bgColor: ThemeProvider.scaffolderColor),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 2.sp,
                              children: [
                                CommonTextWidget(heading: "Email", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 10),
                                CustomTextField(
                                    hintText: "Enter Email", controller: logic.emailController, readOnly: true, bgColor: ThemeProvider.scaffolderColor),
                              ],
                            ),
                          ],
                        ),
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
                            GestureDetector(
                              onTap: () => Get.toNamed(AppRouter.notificationScreen),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: ThemeProvider.greenDarkColor, borderRadius: BorderRadius.all(Radius.circular(100))),
                                    child: SvgPicture.asset(AssetPath.iconNoti),
                                  ),

                                  CommonTextWidget(heading: "Notification", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 20),
                                ],
                              ),
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 5.sp,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 5.sp,
                                  children: [
                                    CommonTextWidget(heading: "Enable Notification’s", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 20),
                                    CommonTextWidget(
                                      heading: "Receive Gentle reminders",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeProvider.blackColor,
                                      paddingH: 20,
                                    ),
                                  ],
                                ),

                                Obx(() {
                                  return Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: logic.notification1.value,
                                      activeColor: Colors.white,
                                      inactiveThumbColor: Colors.white,
                                      activeTrackColor: ThemeProvider.greenDarkColor,
                                      inactiveTrackColor: ThemeProvider.hintColor,
                                      onChanged: (bool value) async {
                                        logic.notification1.value = value;
                                        logic.state.sharedPreferencesManager.putBool("notification1", value);
                                        logic.state.updateToggles({"enableNotification" : value});
                                      },
                                    ),
                                  );
                                }),
                              ],
                            ),
                            3.verticalSpace,

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 5.sp,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 5.sp,
                                  children: [
                                    CommonTextWidget(heading: "Daily Reminder", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 20),
                                    CommonTextWidget(
                                      heading: "Optional daily check-in",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeProvider.blackColor,
                                      paddingH: 20,
                                    ),
                                  ],
                                ),

                                Obx(() {
                                  return Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: logic.notification2.value,
                                      activeColor: Colors.white,
                                      inactiveThumbColor: Colors.white,
                                      activeTrackColor: ThemeProvider.greenDarkColor,
                                      inactiveTrackColor: ThemeProvider.hintColor,
                                      onChanged: (bool value) async {
                                        logic.notification2.value = value;
                                        logic.state.sharedPreferencesManager.putBool("notification2", value);
                                        logic.state.updateToggles({"dailyReminder" : value});
                                      },
                                    ),
                                  );
                                }),
                              ],
                            ),
                            3.verticalSpace,

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 5.sp,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 5.sp,
                                  children: [
                                    CommonTextWidget(heading: "Streak Reminder", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 20),
                                    CommonTextWidget(
                                      heading: "No pressure, just encouragement",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeProvider.blackColor,
                                      paddingH: 20,
                                    ),
                                  ],
                                ),

                                Obx(() {
                                  return Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: logic.notification3.value,
                                      activeColor: Colors.white,
                                      inactiveThumbColor: Colors.white,
                                      activeTrackColor: ThemeProvider.greenDarkColor,
                                      inactiveTrackColor: ThemeProvider.hintColor,
                                      onChanged: (bool value) async {
                                        logic.notification3.value = value;
                                        logic.state.sharedPreferencesManager.putBool("notification3", value);
                                        logic.state.updateToggles({"streakReminder" : value});
                                      },
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),

                      20.verticalSpace,
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                          Get.toNamed(AppRouter.changePasswordScreen);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
                          decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(color: ThemeProvider.greenDarkColor, borderRadius: BorderRadius.all(Radius.circular(100))),
                                child: SvgPicture.asset(AssetPath.iconKey),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 5.sp,
                                children: [
                                  CommonTextWidget(heading: "Change Password", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 20),
                                  CommonTextWidget(
                                    heading: "Update your Current Password",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: ThemeProvider.blackColor,
                                    paddingH: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      20.verticalSpace,
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return commonDialog(
                                context,
                                title: "Are You sure you want to logout",
                                showIcon: true,
                                icon: AssetPath.iconLogout,
                                failure: () => Get.back(),
                                success: () {
                                  logic.mainLoader.value = true;
                                  Get.back();
                                  logic.signOutApi();
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
                          decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(color: ThemeProvider.greenDarkColor, borderRadius: BorderRadius.all(Radius.circular(100))),
                                child: SvgPicture.asset(AssetPath.iconLogout),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 5.sp,
                                children: [
                                  CommonTextWidget(heading: "Log Out", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 20),
                                  CommonTextWidget(
                                    heading: "Sign out of your account",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: ThemeProvider.blackColor,
                                    paddingH: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      20.verticalSpace,
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return commonDialog(
                                context,
                                title: "Are You sure you want to Delete your account",
                                showIcon: true,
                                icon: AssetPath.iconDel,
                                failure: () => Get.back(),
                                success: () {
                                  logic.mainLoader.value = true;
                                  Get.back();
                                  logic.deleteApi();
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
                          decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(color: ThemeProvider.greenDarkColor, borderRadius: BorderRadius.all(Radius.circular(100))),
                                child: SvgPicture.asset(AssetPath.iconDel),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 5.sp,
                                children: [
                                  CommonTextWidget(heading: "Delete account", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 20),
                                  CommonTextWidget(
                                    heading: "Permanently remove your account ",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: ThemeProvider.blackColor,
                                    paddingH: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      30.verticalSpace,
                    ],
                  ),
                  Obx(() => logic.mainLoader.value ? Container(alignment: Alignment.center, child: ButtonLoader()) : SizedBox())
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
