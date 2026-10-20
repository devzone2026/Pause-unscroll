import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pause_and_scroll/utils/appTheme.dart';
import 'package:pause_and_scroll/widgets/commonTextWidget.dart';
import '../widgets/commonButtonWidget1.dart';

commonDialog(
  BuildContext context, {
  bool showIcon = false,
  String? icon,
  required String title,
  String? subTitle,
  required Function() success,
  required Function() failure,
}) {
  return AlertDialog(
    backgroundColor: ThemeProvider.whiteColor,
    actionsPadding: EdgeInsets.symmetric(horizontal: 2),
    contentPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    title: CommonTextWidget(
      heading: title,
      fontSize: 18,
      maxLine: 3,
      lineHeight: 1.5,
      color: ThemeProvider.greenDarkColor,
      fontWeight: FontWeight.w700,
      textAlign: TextAlign.center,
    ),
    content: CommonTextWidget(heading: subTitle ?? "", lineHeight: 1.5, fontSize: 14, color: ThemeProvider.blackColor, textAlign: TextAlign.center, maxLine: 2),
    scrollable: true,

    icon: (showIcon && icon != null)
        ? Center(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: ThemeProvider.greenDarkColor, borderRadius: BorderRadius.all(Radius.circular(100))),
              child: SvgPicture.asset(icon),
            ),
          )
        : null,

    actions: [
      Row(
        children: [
          Flexible(
            child: CommonButtonWidget1(
              onPressed: () => success(),
              title: "Yes",
              titleColor: ThemeProvider.whiteColor,
              fontSize: 14,
              firstGradientColor: ThemeProvider.greenDarkColor,
              secondGradientColor: ThemeProvider.greenDarkColor,
            ),
          ),

          Flexible(
            child: CommonButtonWidget1(onPressed: () => failure(), title: "No", fontSize: 14),
          ),
        ],
      ),

      10.verticalSpace,
    ],
  );
}
