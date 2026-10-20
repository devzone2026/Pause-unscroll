import 'package:flutter/material.dart';

class ThemeProvider {
  static const blackColor = Color(0xFF000000);
  static const whiteColor = Color(0xFFFFFFFF);

  static const greenLiteColor = Color(0xFFA3D87D);
  static const greenDarkColor = Color(0xFF567242);
  static const scaffolderColor = Color(0xFFF9FAFB);
  static const scaffolderColor1 = Color(0xFFFFFBEE);
  static const resendOTP = Color(0xFF99CA75);



  static const textFieldBorderColor = Color(0xFFDEDEDE);
  static const textHintColor = Color(0xFF666666);
  static const hintColor = Color(0xFF888888);
  static const hintIconColor = Color(0xFFE5E7EB);


  static const descColor = Color(0xFF475569);
  static const progressBarColor = Color(0xFFFBE1C6);





  // gradients colors are ::
  static const Gradient mainGradient = LinearGradient(
    colors: [greenLiteColor, greenDarkColor],
    begin: AlignmentGeometry.centerLeft,
    end: AlignmentGeometry.centerRight,
  );
}
