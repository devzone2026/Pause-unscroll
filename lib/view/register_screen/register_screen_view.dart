import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonButtonWidget.dart';
import '../../widgets/commonButtonWidget1.dart';
import '../../widgets/commonTextWidget.dart';
import '../../widgets/custom_text_field.dart';
import '../login_screen/login_screen_logic.dart';
import 'register_screen_logic.dart';

class RegisterScreenPage extends StatelessWidget {
  RegisterScreenPage({super.key});

  final RegisterScreenLogic logic = Get.put(RegisterScreenLogic(state: Get.find()));
  final LoginScreenLogic loginLogic = Get.put(LoginScreenLogic(state: Get.find()));
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RegisterScreenLogic(state: Get.find()),
      builder:(controller) =>  GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
          backgroundColor: ThemeProvider.scaffolderColor,
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  35.verticalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10.sp,
                    children: [
                      Image.asset(AssetPath.splashLogo, width: 100, height: 100),
                      2.verticalSpace,
                      CommonTextWidget(heading: "Begin Your Journey", fontSize: 20, color: ThemeProvider.greenDarkColor,fontWeight: FontWeight.w700),
                      CommonTextWidget(heading: "Create space for wellness", color: ThemeProvider.blackColor, fontSize: 14,fontWeight: FontWeight.w300,),
                    ],
                  ),

                  20.verticalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 2.sp,
                    children: [
                      CommonTextWidget(heading: "Name", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 20),
                      CustomTextField(
                        prefixIcon: SvgPicture.asset(AssetPath.iconPerson),
                        controller: logic.nameController,
                        hintText: "Enter Name",
                        paddingH: 15,
                        validator: (value) {
                          if (logic.nameController.text.trim().isEmpty) {
                            return "Name cannot be empty";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  15.verticalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 2.sp,
                    children: [
                      CommonTextWidget(heading: "Email", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 20),
                      CustomTextField(
                        prefixIcon: SvgPicture.asset(AssetPath.iconEmail),
                        controller: logic.emailController,
                        hintText: "Enter Email",
                        paddingH: 15,
                        validator: (value) {
                          if (logic.emailController.text.trim().isEmpty) {
                            return "Email cannot be empty";
                          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(logic.emailController.text.trim())) {
                            return "Enter a valid email address";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  15.verticalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 2.sp,
                    children: [
                      CommonTextWidget(heading: "Password", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 20),

                      Obx(() {
                        return CustomTextField(
                          obscureText: logic.passwordVisible.value,
                          prefixIcon: SvgPicture.asset(AssetPath.iconLock),
                          suffixIcon: GestureDetector(
                            onTap: () => logic.passwordVisible.value = !logic.passwordVisible.value,
                            child: SvgPicture.asset(AssetPath.iconUnVisible),
                          ),
                          hintText: "Enter Password",
                          controller: logic.passwordController,
                          paddingH: 15,
                          validator: (value) {
                            if (logic.passwordController.text.trim().isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (logic.passwordController.text.trim().length < 8) {
                              return "Password must be at least 8 characters";
                            }
                            if (!logic.passwordController.text.contains(RegExp(r'[0-9]'))) {
                              return "Password must include at least 1 number";
                            }
                            if (!logic.passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                              return "Password must include at least 1 special character";
                            }
                            return null;
                          },
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
                      CommonTextWidget(heading: "Confirm Password", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 20),

                      Obx(() {
                        return CustomTextField(
                          obscureText: logic.confirmPasswordVisible.value,
                          prefixIcon: SvgPicture.asset(AssetPath.iconLock),
                          suffixIcon: GestureDetector(
                            onTap: () => logic.confirmPasswordVisible.value = !logic.confirmPasswordVisible.value,
                            child: SvgPicture.asset(AssetPath.iconUnVisible),
                          ),
                          hintText: "Enter Confirm Password",
                          controller: logic.confirmPasswordController,
                          validator: (value) {
                            if (logic.confirmPasswordController.text.trim().isEmpty) {
                              return "Confirm password cannot be empty";
                            } else if (logic.passwordController.text != logic.confirmPasswordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                          paddingH: 15,
                        );
                      }),
                    ],
                  ),

                  20.verticalSpace,
                  Obx(() {
                    return CommonButtonWidget(
                      isLoading: logic.mainLoader.value,
                      onPressed: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        if (_formKey.currentState!.validate()) {
                          logic.mainLoader.value = true;
                          Future.delayed(Duration(seconds: 2), () {
                            logic.registerApi();
                          });
                        }
                      },
                      title: "Create Account",
                    );
                  }),

                  Row(
                    children: [
                      Flexible(child: SvgPicture.asset(AssetPath.leftLine)),
                      CommonTextWidget(
                        heading: "Or continue with",
                        fontSize: 14,
                        color: ThemeProvider.hintColor,
                        textAlign: TextAlign.end,
                        paddingH: 20,
                        paddingV: 15,
                      ),
                      Flexible(child: SvgPicture.asset(AssetPath.rightLine)),
                    ],
                  ),

                  Obx(() {
                    return CommonButtonWidget1(
                      onPressed: () {
                        loginLogic.googleLoader.value = true;
                        loginLogic.loginWithGoogle(context);
                      },
                      isLoading: loginLogic.googleLoader.value,
                      title: "Sign up with Google",
                      fontSize: 16,
                      icon: AssetPath.iconGoogle,
                    );
                  }),

                  if(Platform.isIOS)
                  Obx(() {
                    return CommonButtonWidget1(
                      onPressed: () {
                        loginLogic.appleLoader.value = true;
                        loginLogic.loginWithApply(context);
                      },
                      isLoading: loginLogic.appleLoader.value,
                      fontSize: 16,
                      title: "Sign up with Apple",
                      icon: AssetPath.iconApple,
                    );
                  }),

                  30.verticalSpace,
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "I have already an account",
                      style: TextStyle(color: ThemeProvider.blackColor, fontWeight: FontWeight.w500, fontSize: 14.sp, fontFamily: "inter"),
                      children: [
                        TextSpan(text: " "),

                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(color: ThemeProvider.greenDarkColor, fontWeight: FontWeight.w500, fontFamily: "inter"),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.back();
                            },
                        ),
                      ],
                    ),
                  ),

                  15.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
