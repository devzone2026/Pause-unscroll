import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pause_and_scroll/backend/repo/api.dart';

import '../../backend/helper/sharedPref.dart';
import '../../utils/api_endpoint.dart';

class ProfileScreenState {
  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;

  ProfileScreenState({required this.apiService, required this.sharedPreferencesManager});



  Future<Response?> profileState() async {
    return await apiService.getPrivate(endPointProfileDetails, {});
  }

  Future<Response?> signOutState() async {
    return await apiService.getPrivate(endPointSignOut, {});
  }

  Future<Response?> deleteState() async {
    return await apiService.deletePrivate(endPointDeleteAccount);
  }

  void clearShared() {
    sharedPreferencesManager.sharedPreferences.clear();
  }


  Future<Response?> updateProfileState(Map<String, dynamic> body, File? file) async {
    return await apiService.putMultipart(endPointUpdateProfile , fields: body,file: file,fileFieldName: "image");
  }


  Future<Response?>  updateToggles(Map<String, dynamic> body) async {
    return await apiService.putPrivate(endPointUpdateProfile, data: body);
  }

  Future<Response?> changePasswordState(Map<String, dynamic> body) async {
    return await apiService.postPrivate(endPointChangePassword , body);
  }





}
