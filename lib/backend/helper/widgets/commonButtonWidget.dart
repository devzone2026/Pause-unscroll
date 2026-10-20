import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/widgets/button_loader.dart';
import '../utils/appTheme.dart';
import '../utils/responsive.dart';
import 'commonTextWidget.dart';

class CommonButtonWidget extends StatefulWidget {
  final String? title;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? fontSize;
  final double? borderRadius;
  final Color? firstGradientColor;
  final Color? secondGradientColor;
  final bool showIcon;
  final String? icon;
  final double? height;
  final double? width;
  final bool borderEnable;
  final bool shadowEnable;
  final double paddingH;
  final double paddingV;

  const CommonButtonWidget({
    this.title,
    required this.onPressed,
    this.isLoading = false,
    this.fontSize,
    this.borderRadius,
    this.firstGradientColor,
    this.secondGradientColor,
    this.height,
    this.width,
    this.icon,
    this.showIcon = false,
    this.borderEnable = false,
    this.shadowEnable = false,
    this.paddingH = 15,
    this.paddingV = 10,
    super.key,
  });

  @override
  State<CommonButtonWidget> createState() => _CommonButtonWidgetState();
}

class _CommonButtonWidgetState extends State<CommonButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.paddingH, vertical: widget.paddingV),
      child: GestureDetector(
        onTap: widget.onPressed, // Disable onTap if isLoading is true
        child: Container(
          alignment: AlignmentGeometry.center,
          width: widget.width ?? MediaQuery.of(context).size.width,
          height: widget.height ?? MediaQuery.of(context).size.height * .055,
          decoration: BoxDecoration(
            gradient: ThemeProvider.mainGradient,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10), // Use custom or default radius
            border: widget.borderEnable == true ? Border.all(width: 1, color: ThemeProvider.textFieldBorderColor) : null,

            boxShadow: widget.shadowEnable == true
                ? [BoxShadow(color: ThemeProvider.blackColor.withValues(alpha: 0.6), spreadRadius: 1, blurRadius: 2, offset: Offset(0, 3))]
                : null,
          ),
          child: widget.isLoading
              ? ButtonLoader()
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8.sp,
                  children: [

                    if(widget.showIcon && widget.icon != null)
                    SvgPicture.asset(widget.icon!),

                    CommonTextWidget(
                      textAlign: TextAlign.start,
                      heading: widget.title!.tr,
                      fontSize: widget.fontSize ?? Responsive.responsiveFontSize(context, 16.sp),
                      color: ThemeProvider.whiteColor,
                      fontFamily: 'inter',
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
