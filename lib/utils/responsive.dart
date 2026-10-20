

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Responsive{

  static double responsiveFontSize(BuildContext context, double baseSize, {double maxFontSize = 32}) {
    // Return the base size directly for Android and iOS
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return baseSize;
    }

    // Get screen dimensions
    double width;
    double height;

    if(MediaQuery.of(context).orientation == Orientation.landscape){
      width = MediaQuery.of(context).size.height;
      height = MediaQuery.of(context).size.width;
    }else{
      width = MediaQuery.of(context).size.width;
      height = MediaQuery.of(context).size.height;
    }


    // Calculate a scaling factor based on the average of width and height
    double averageDimension = (width + height) / 2;

    // Calculate font size based on the average dimension
    double calculatedFontSize = baseSize * (averageDimension / 1000).clamp(0.75, 1.5);

    // Adjust for very small screens (height less than 400)
    if (height < 400) {
      calculatedFontSize = baseSize * 0.5; // Ensure a smaller font size for very small screens
    }

    // Ensure font size does not exceed the maximum cap
    return calculatedFontSize > maxFontSize ? maxFontSize : calculatedFontSize;
  }

}