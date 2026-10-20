import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/backend/helper/appRoute.dart';
import 'package:pause_and_scroll/utils/appTheme.dart';
import 'package:pause_and_scroll/utils/validations.dart';
import 'package:pause_and_scroll/widgets/commonButtonWidget.dart';
import 'package:pause_and_scroll/widgets/commonTextWidget.dart';
import 'package:pause_and_scroll/widgets/custom_text_field.dart';
import '../../dialogs/forget_password.dart';
import '../../utils/appAssets.dart';
import '../../widgets/commonButtonWidget1.dart';
import 'login_screen_logic.dart';

class LoginScreenPage extends StatelessWidget {
  LoginScreenPage({super.key});

  final LoginScreenLogic logic = Get.put(LoginScreenLogic(state: Get.find()));
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LoginScreenLogic(state: Get.find()),
      builder: (controller) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
          backgroundColor: ThemeProvider.scaffolderColor,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ---------- TOP: Logo + Welcome text ----------
                            Column(
                              children: [
                                15.verticalSpace,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 10.sp,
                                  children: [
                                    Image.asset(AssetPath.splashLogo, width: 100, height: 100),
                                    2.verticalSpace,
                                    CommonTextWidget(
                                      heading: "Welcome Back",
                                      fontSize: 20,
                                      color: ThemeProvider.greenDarkColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    CommonTextWidget(
                                      heading: "Take a moment for yourself",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: ThemeProvider.blackColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // ---------- MIDDLE: Form fields ----------
                            Column(
                              children: [
                                15.verticalSpace,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 2.sp,
                                  children: [
                                    CommonTextWidget(
                                      heading: "Email",
                                      fontSize: 16,
                                      color: ThemeProvider.blackColor,
                                      paddingH: 20,
                                    ),
                                    CustomTextField(
                                      prefixIcon: SvgPicture.asset(AssetPath.iconEmail),
                                      controller: logic.emailController,
                                      hintText: "Enter Email",
                                      paddingH: 15,
                                      validator: (value) {
                                        if (logic.emailController.text.trim().isEmpty) {
                                          return "Email cannot be empty";
                                        } else if (!Validations.isEmailValid(
                                            logic.emailController.text.trim())) {
                                          return "Enter a valid email address";
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),

                                10.verticalSpace,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 2.sp,
                                  children: [
                                    CommonTextWidget(
                                      heading: "Password",
                                      fontSize: 16,
                                      color: ThemeProvider.blackColor,
                                      paddingH: 20,
                                    ),
                                    Obx(() {
                                      return CustomTextField(
                                        obscureText: logic.passwordVisible.value,
                                        controller: logic.passwordController,
                                        prefixIcon: SvgPicture.asset(AssetPath.iconLock),
                                        suffixIcon: GestureDetector(
                                          onTap: () => logic.passwordVisible.value =
                                          !logic.passwordVisible.value,
                                          child: SvgPicture.asset(
                                            logic.passwordVisible.value
                                                ? AssetPath.iconUnVisible
                                                : AssetPath.iconUnVisible,
                                          ),
                                        ),
                                        hintText: "Enter Password",
                                        validator: (value) {
                                          if (logic.passwordController.text.trim().isEmpty) {
                                            return "Password cannot be empty";
                                          }
                                          return null;
                                        },
                                        paddingH: 15,
                                      );
                                    }),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return forgetPasswordDialog(
                                              context,
                                              callBack: (Map<String, dynamic> value) {
                                                debugPrint(value.toString());
                                                if (value["key"] == 2) {
                                                  Get.back();
                                                }
                                              },
                                              logic,
                                            );
                                          },
                                        );
                                      },
                                      child: CommonTextWidget(
                                        heading: "Forgot Password",
                                        fontSize: 14,
                                        color: ThemeProvider.blackColor,
                                        paddingH: 20,
                                        paddingV: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // ---------- BOTTOM: Buttons + Sign up ----------
                            Column(
                              children: [
                                Obx(() {
                                  return CommonButtonWidget(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        FocusManager.instance.primaryFocus!.unfocus();
                                        logic.mainLoader.value = true;
                                        logic.emailLoginApi();
                                      }
                                    },
                                    isLoading: logic.mainLoader.value,
                                    title: "Sign In",
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
                                      FocusManager.instance.primaryFocus!.unfocus();
                                      logic.googleLoader.value = true;
                                      logic.loginWithGoogle(context);
                                    },
                                    isLoading: logic.googleLoader.value,
                                    title: "Sign in with Google",
                                    fontSize: 16,
                                    icon: AssetPath.iconGoogle,
                                  );
                                }),

                                if (Platform.isIOS)
                                  Obx(() {
                                    return CommonButtonWidget1(
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus!.unfocus();
                                        logic.appleLoader.value = true;
                                        logic.loginWithApply(context);
                                      },
                                      isLoading: logic.appleLoader.value,
                                      fontSize: 16,
                                      title: "Sign in with Apple",
                                      icon: AssetPath.iconApple,
                                    );
                                  }),

                                15.verticalSpace,
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: "Don't have an account?",
                                    style: TextStyle(
                                      color: ThemeProvider.blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      fontFamily: "inter",
                                    ),
                                    children: [
                                      TextSpan(text: " "),
                                      TextSpan(
                                        text: 'Sign up',
                                        style: TextStyle(
                                          color: ThemeProvider.greenDarkColor,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "inter",
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.toNamed(AppRouter.registerScreen);
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                                10.verticalSpace,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}