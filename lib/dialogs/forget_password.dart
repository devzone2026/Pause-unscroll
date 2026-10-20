import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/utils/appTheme.dart';
import 'package:pause_and_scroll/widgets/commonButtonWidget.dart';
import 'package:pause_and_scroll/widgets/commonTextWidget.dart';
import '../utils/appAssets.dart';
import '../utils/toasts.dart';
import '../view/login_screen/login_screen_logic.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/otp_input_widget.dart';

forgetPasswordDialog(BuildContext context, LoginScreenLogic controller, {required Function(Map<String, dynamic>) callBack}) {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  final formKey = GlobalKey<FormState>();
  String otpIs = "";
  RxBool btnLoader = false.obs;
  RxInt uiState = 0.obs;


  Future<void> forgotPasswordApi({required String email}) async {
    try {
      Map<String, dynamic> data = {"email": email};
      controller.state.forgotPasswordState(data).then((response) {
        if (response != null && response.statusCode == 200) {
          Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
          debugPrint("ForgotPassword Response :: $myMap");
          btnLoader.value = false;
          uiState.value++;
        }
      }).catchError((e) {
        btnLoader.value = false;
        debugPrint("Error: $e");
      });
    } catch (error) {
      btnLoader.value = false;
      errorToast('${'Error signing in with Google'.tr}$error');
    }
  }

  Future<void> verifyOTPApi({required String otp, required String email}) async {
    try {
      Map<String, dynamic> data = {"email": email, "otp": otp};
      await controller.state.verifyOTPState(data).then((response) {
        if (response != null && response.statusCode == 200) {
          Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
          debugPrint("VerifyOTP Response :: $myMap");
          btnLoader.value = false;
          uiState.value++;
        }
      }).catchError((e) {
        btnLoader.value = false;
        debugPrint("Error: $e");
      });
    } catch (error) {
      btnLoader.value = false;
      errorToast('${'Error signing in with Google'.tr}$error');
    }
  }

  Future<void> resetPasswordApi({required String password, required String email}) async {
    try {
      Map<String, dynamic> data = {"email": email, "password": password};
      controller.state.resetPasswordState(data).then((response) {
        if (response != null && response.statusCode == 200) {
          Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
          debugPrint("ResetPassword Response :: $myMap");
          callBack({"key": 2});
          btnLoader.value = false;
          uiState.value++;
        }
      }).catchError((e) {
        btnLoader.value = false;
        debugPrint("Error: $e");
      });
    } catch (error) {
      btnLoader.value = false;
      errorToast('${'Error signing in with Google'.tr}$error');
    }
  }


  return StatefulBuilder(
    builder: (context, setState) {
      return Form(
        key: formKey,
        child: AlertDialog(
          insetPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          actionsPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Obx(() {
            return CommonTextWidget(
              heading: (uiState.value == 0)
                  ? "Reset Password"
                  : (uiState.value == 1)
                  ? "Verify Code"
                  : "Create New Password",
              fontSize: 18,
              color: ThemeProvider.greenDarkColor,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            );
          }),
          content: Obx(() {
            return CommonTextWidget(
              heading: (uiState.value == 0)
                  ? "Enter your email to receive reset\ninstructions"
                  : (uiState.value == 1)
                  ? "Enter the 6-digit code sent to \n ${emailController.text}"
                  : "Enter your new password below",
              lineHeight: 1.5,
              fontSize: 14,
              color: ThemeProvider.blackColor,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
              maxLine: 2,
            );
          }),
          scrollable: true,
          iconPadding: EdgeInsets.only(top: 10, right: 15),
          icon: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(onTap: () => Navigator.pop(context), child: SvgPicture.asset(AssetPath.iconCancel)),
          ),

          actions: [
            Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 2.sp,
                children: [
                  if (uiState.value == 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CommonTextWidget(heading: "Email",
                            fontWeight: FontWeight.w400,
                            fontSize: 14, color: ThemeProvider.blackColor, paddingH: 25),
                        CustomTextField(
                          prefixIcon: SvgPicture.asset(AssetPath.iconEmail),
                          validator: (value) {
                            if (emailController.text
                                .trim()
                                .isEmpty) {
                              return "Email cannot be empty";
                            } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text.trim())) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                          controller: emailController,
                          hintText: "Enter Email",
                          paddingH: 15,
                        ),
                      ],
                    ),

                  if (uiState.value == 1)
                    OtpInputWidget(
                      otpLength: 6,
                      onCompleted: (otp) {
                        otpIs = otp;
                        debugPrint("OTP entered: $otp"); // called when all 6 digits filled
                      },
                      onChange: (otp) {
                        otpIs = otp;
                        debugPrint("OTP entered: $otp"); // called when all 6 digits filled
                      },
                      focusedBorderColor: Color(0xFF4A90E2),
                      enabledBorderColor: Colors.grey,
                      fieldWidth: 48,
                      fieldHeight: 56, // optional
                    ),

                  if (uiState.value == 2)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CommonTextWidget(heading: "New Password", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 25),
                        CustomTextField(
                          obscureText: isPasswordVisible,
                          prefixIcon: SvgPicture.asset(AssetPath.iconLock),
                          suffixIcon: GestureDetector(onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          }, child: SvgPicture.asset(AssetPath.iconUnVisible)),
                          hintText: "Enter Password",
                          validator: (value) {
                            if (passwordController.text
                                .trim()
                                .isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (passwordController.text
                                .trim()
                                .length < 8) {
                              return "Password must be at least 8 characters";
                            }
                            if (!passwordController.text.contains(RegExp(r'[0-9]'))) {
                              return "Password must include at least 1 number";
                            }
                            if (!passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                              return "Password must include at least 1 special character";
                            }
                            return null;
                          },
                          controller: passwordController,
                          paddingH: 15,
                        ),

                        5.verticalSpace,

                        CommonTextWidget(heading: "Confirm Password", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 25),
                        CustomTextField(
                          obscureText: isConfirmPasswordVisible,
                          prefixIcon: SvgPicture.asset(AssetPath.iconLock),
                          suffixIcon: GestureDetector(onTap: () {
                            setState(() {
                              isConfirmPasswordVisible = !isConfirmPasswordVisible;
                            });
                          }, child: SvgPicture.asset(AssetPath.iconUnVisible)),
                          hintText: "Enter Password",
                          validator: (value) {
                            if (confirmPasswordController.text
                                .trim()
                                .isEmpty) {
                              return "Confirm password cannot be empty";
                            } else if (passwordController.text != confirmPasswordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                          controller: confirmPasswordController,
                          paddingH: 15,
                        ),
                      ],
                    ),
                ],
              );
            }),


            Obx(() {
              return (uiState.value == 1) ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  10.verticalSpace,
                  SizedBox(
                    width: double.infinity,
                    child: CommonTextWidget(
                      heading: "Code expires in 5 minutes",
                      fontSize: 12,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                      color: ThemeProvider.blackColor,
                      paddingH: 25,
                    ),
                  ),
                ],
              ) : SizedBox();
            }),

            10.verticalSpace,
            Obx(() {
              return CommonButtonWidget(
                isLoading: btnLoader.value,
                onPressed: () {
                  setState(() {
                    if (uiState.value == 0) {
                      if (formKey.currentState!.validate()) {
                        btnLoader.value = true;
                        forgotPasswordApi(email: emailController.text.trim());
                      }
                    } else if (uiState.value == 1) {
                      if (otpIs.length >= 6) {
                        btnLoader.value = true;
                        verifyOTPApi(otp: otpIs, email: emailController.text.trim());
                      }
                    } else if (uiState.value == 2) {
                      if (formKey.currentState!.validate()) {
                        btnLoader.value = true;
                        resetPasswordApi(password: passwordController.text.trim(), email: emailController.text.trim());
                      }
                    }
                  });
                },
                title: (uiState.value == 0)
                    ? "Link send to your Email"
                    : (uiState.value == 1)
                    ? "Verify Code"
                    : "Reset Password",
                fontSize: 14,
              );
            }),

            Obx(() {
              return (uiState.value == 1) ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  10.verticalSpace,
                  SizedBox(
                    width: double.infinity,
                    child: CommonTextWidget(heading: "Resend Code", fontSize: 16,fontWeight: FontWeight.w600, color: ThemeProvider.greenLiteColor, textAlign: TextAlign.center),
                  ),
                ],
              ): SizedBox();
            }),

            20.verticalSpace,
          ],
        ),
      );
    },
  );
}
