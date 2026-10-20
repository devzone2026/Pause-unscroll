import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../backend/helper/sharedPref.dart';
import '../../backend/repo/api.dart';
import '../../utils/api_endpoint.dart';
import '../../utils/constants.dart';

class LoginScreenState {

  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;


  LoginScreenState({required this.apiService, required this.sharedPreferencesManager});


  Future<Response?> socialLoginState(Map<String, dynamic> body) async {
    return await apiService.postPublic(endPointRegister , body);
  }

  Future<Response?> emailLoginState(Map<String, dynamic> body) async {
    return await apiService.postPublic(endPointSocialLogin , body);
  }

  Future<Response?> forgotPasswordState(Map<String, dynamic> body) async {
    return await apiService.postPublic(endPointForgotPassword , body);
  }

  Future<Response?> verifyOTPState(Map<String, dynamic> body) async {
    return await apiService.postPublic(endPointVerifyOTP , body);
  }
  Future<Response?> resetPasswordState(Map<String, dynamic> body) async {
    return await apiService.postPublic(endPointResetPassword , body);
  }

  Future<void> saveData(String token) async {
    sharedPreferencesManager.sharedPreferences.setString(Constants.saveAuth, token);
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }


  /*Future<void> initFirebase() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    messaging.getToken().then((value) async{
      sharedPreferencesManager.sharedPreferences.setString(Constants.saveToken, value ?? "No firebase token available");
      debugPrint("FIREBASE TOKEN :: ${sharedPreferencesManager.sharedPreferences.getString(Constants.saveToken)}");
    });
  }*/

  Future<void> initFirebase() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint("Permission: ${settings.authorizationStatus}");

    String? apnsToken = await messaging.getAPNSToken();
    debugPrint("APNS Token: $apnsToken");

    String? fcmToken = await messaging.getToken();
    debugPrint("FCM Token: $fcmToken");

    await sharedPreferencesManager.sharedPreferences.setString(
      Constants.saveToken,
      fcmToken ?? "",
    );
  }


}
