import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/utils/appTranslate.dart';
import 'package:pause_and_scroll/utils/connectivity.dart';
import 'package:pause_and_scroll/utils/constants.dart';
import 'backend/helper/appRoute.dart';
import 'backend/helper/mainBinding.dart';
import 'backend/helper/sharedPref.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await MainBinding().dependencies();
  Get.put(ConnectivityController());
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform );
  String currentLanguage = Get.find<SharedPrefManger>().getString('language') ?? Constants.defaultLanguageApp;
  runApp(MyApp(currentLanguage : currentLanguage));
}

class MyApp extends StatelessWidget {
  final String currentLanguage;
   const MyApp({super.key, required this.currentLanguage});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: Get.key,
        initialRoute: AppRouter.splashScreen,
        getPages: AppRouter.routes,
        defaultTransition: Transition.fadeIn,
        translations: AppTranslation(),
        locale: Locale(currentLanguage),
        fallbackLocale: Locale(currentLanguage),
        builder: (context, child) {
          return Obx(() {
            var isConnected = Get.find<ConnectivityController>().isConnected.value;
            if (!isConnected) {
              return MaterialApp(
                home: Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No Internet Connection',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return child ?? const SizedBox.shrink();
          });
        },
      ),
    );
  }
}