
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/view/profile_screen/profile_screen_logic.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonButtonWidget.dart';
import '../../widgets/commonTextWidget.dart';
import '../../widgets/custom_text_field.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final ProfileScreenLogic logic = Get.put(ProfileScreenLogic(state: Get.find()));
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ThemeProvider.scaffolderColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: ThemeProvider.scaffolderColor,
          centerTitle: true,
          title: CommonTextWidget(
            heading: "Change Password",
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: ThemeProvider.greenDarkColor,
          ),
        ),
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [],
                body: Column(
                  children: [



                    CommonTextWidget(heading: "Update your account password",fontWeight: FontWeight.w500, fontSize: 14, color: ThemeProvider.blackColor, paddingH: 10),

                    Container(
                      margin: EdgeInsets.only(top: 30.sp),
                      padding: EdgeInsets.symmetric(vertical: 20.sp),
                      decoration: BoxDecoration(
                        color: ThemeProvider.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(15.sp)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [




                          10.verticalSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 2.sp,
                            children: [
                              CommonTextWidget(heading: "Current Password", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 10),

                              Obx(() {
                                return CustomTextField(
                                  obscureText: logic.currentVisible.value,
                                  controller: logic.currentPasswordController,
                                  prefixIcon: SvgPicture.asset(AssetPath.iconLock),
                                  suffixIcon: GestureDetector(
                                    onTap: () => logic.currentVisible.value = !logic.currentVisible.value,
                                    child: SvgPicture.asset(!logic.currentVisible.value ? AssetPath.iconVisible : AssetPath.iconUnVisible, width: 24, color: Colors.grey),
                                  ),
                                  hintText: "Enter Password",
                                  validator: (value) {
                                    if (logic.currentPasswordController.text.trim().isEmpty) {
                                      return "Password cannot be empty";
                                    }
                                    return null;
                                  },
                                  paddingH: 10,
                                );
                              }),
                            ],
                          ),



                          15.verticalSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 2.sp,
                            children: [
                              CommonTextWidget(heading: "New Password", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 10),

                              Obx(() {
                                return CustomTextField(
                                  obscureText: logic.newVisible.value,
                                  controller: logic.newPasswordController,
                                  prefixIcon: SvgPicture.asset(AssetPath.iconLock),
                                  suffixIcon: GestureDetector(
                                    onTap: () => logic.newVisible.value = !logic.newVisible.value,
                                    child: SvgPicture.asset(!logic.newVisible.value ? AssetPath.iconVisible : AssetPath.iconUnVisible, width: 24, color: Colors.grey),
                                  ),
                                  hintText: "Enter New Password",
                                  validator: (value) {
                                    if (logic.newPasswordController.text.trim().isEmpty) {
                                      return "Password cannot be empty";
                                    }
                                    if (logic.newPasswordController.text.trim().length < 8) {
                                      return "Password must be at least 8 characters";
                                    }
                                    if (!logic.newPasswordController.text.contains(RegExp(r'[0-9]'))) {
                                      return "Password must include at least 1 number";
                                    }
                                    if (!logic.newPasswordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                      return "Password must include at least 1 special character";
                                    }

                                    return null;
                                  },
                                  paddingH: 10,
                                );
                              }),
                            ],
                          ),


                          15.verticalSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 2.sp,
                            children: [
                              CommonTextWidget(heading: "Confirm New Password", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 10),

                              Obx(() {
                                return CustomTextField(
                                  obscureText: logic.confirmVisible.value,
                                  controller: logic.confirmPasswordController,
                                  prefixIcon: SvgPicture.asset(AssetPath.iconLock),
                                  suffixIcon: GestureDetector(
                                    onTap: () => logic.confirmVisible.value = !logic.confirmVisible.value,
                                    child: SvgPicture.asset(!logic.confirmVisible.value ? AssetPath.iconVisible : AssetPath.iconUnVisible, width: 24, color: Colors.grey),
                                  ),
                                  hintText: "Enter Confirm Password",

                                  validator: (value) {
                                    if (logic.confirmPasswordController.text.trim().isEmpty) {
                                      return "Confirm password cannot be empty";
                                    } else if (logic.newPasswordController.text != logic.confirmPasswordController.text) {
                                      return "Passwords do not match";
                                    }
                                    return null;
                                  },
                                  paddingH: 10,
                                );
                              }),
                            ],
                          ),



                        ],
                      ),
                    ),
                    Expanded(child: Container()),


                    Obx(() {
                      return CommonButtonWidget(
                        isLoading: logic.mainLoader.value,
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            FocusManager.instance.primaryFocus!.unfocus();
                            logic.mainLoader.value = true;
                            Future.delayed(Duration(seconds: 2), () {
                              logic.changePasswordApi();
                            });
                          }
                        },
                        title: "Update Password",
                        showIcon: false,
                      );
                    }),
                    20.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
