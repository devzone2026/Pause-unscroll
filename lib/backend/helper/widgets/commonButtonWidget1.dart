
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/widgets/button_loader.dart';
import '../utils/appTheme.dart';
import '../utils/responsive.dart';
import 'commonTextWidget.dart';

class CommonButtonWidget1 extends StatefulWidget {
  final String? title;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? fontSize;
  final double? borderRadius;
  final Color? firstGradientColor;
  final Color? secondGradientColor;
  final Color? titleColor;
  final bool showIcon;
  final double? height;
  final double? width;
  final String? icon;
  final double? paddingH;
  final double? paddingV;

  const CommonButtonWidget1({
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
    this.showIcon = true,
    super.key,
    this.titleColor,
    this.paddingH,
    this.paddingV,
  });

  @override
  State<CommonButtonWidget1> createState() => _CommonButtonWidgetState();
}

class _CommonButtonWidgetState extends State<CommonButtonWidget1> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.paddingH ?? 15 , vertical: widget.paddingV ?? 10),
      child: GestureDetector(
        onTap: !widget.isLoading ? widget.onPressed : null,
        child: Container(
          alignment: AlignmentGeometry.center,
          width: widget.width??MediaQuery.of(context).size.width,
          height: widget.height ??MediaQuery.of(context).size.height * .05,
          decoration: BoxDecoration(
            border: Border.all(width: 1,color: ThemeProvider.textFieldBorderColor),
            color: widget.firstGradientColor ?? ThemeProvider.whiteColor,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10), // Use custom or default radius
          ),
          child: widget.isLoading
              ? ButtonLoader()
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8.sp,
            children: [


              if(widget.icon != null)
                SvgPicture.asset(widget.icon!),

              CommonTextWidget(
                textAlign: TextAlign.center,
                heading: widget.title!.tr,
                fontSize: widget.fontSize?.sp ?? Responsive.responsiveFontSize(context, 18.sp),
                color: widget.titleColor ?? ThemeProvider.blackColor,
                fontWeight: FontWeight.w500,
                fontFamily: 'inter',
              ),
            ],
          )
        ),
      ),
    );
  }

}