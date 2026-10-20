
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../widgets/commonTextWidget.dart';
import 'appTheme.dart';


/// Show a success toast with a check icon
successToast(String message) {
  HapticFeedback.lightImpact();
  Get.showSnackbar(GetSnackBar(
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      messageText: Row(
        children: [
          // Success icon
          Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 10), // Space between icon and message
          Expanded(
            child: CommonTextWidget(
              heading: message.tr,
              fontSize: 14,
              fontFamily: 'inter',
              color: ThemeProvider.whiteColor,
            ),)
        ],
      ),
      duration: const Duration(seconds: 2),
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      padding: const EdgeInsets.all(10)));
}

/// Show an error toast with an error icon
errorToast(String message) {
  HapticFeedback.lightImpact();
  Get.showSnackbar(GetSnackBar(
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.red,
    messageText: Row(
      children: [
        // Error icon
        Icon(Icons.error, color: Colors.white),
        const SizedBox(width: 10), // Space between icon and message
        Expanded(
          child: CommonTextWidget(
            heading: message.tr,
            fontSize: 14,
            fontFamily: 'inter',
            color: ThemeProvider.whiteColor,
          ),)
      ],
    ),
    duration: const Duration(seconds: 2),
    snackStyle: SnackStyle.FLOATING,
    margin: EdgeInsets.all(10),
    borderRadius: 10,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    padding: const EdgeInsets.all(10), // Adjust vertical padding to reduce height
  ));
}

