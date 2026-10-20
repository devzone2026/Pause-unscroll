import 'package:dio/dio.dart';

import '../../backend/helper/sharedPref.dart';
import '../../backend/repo/api.dart';
import '../../utils/api_endpoint.dart';

class BreathingExercisesState {

  ApiService apiService;
  SharedPrefManger sharedPreferencesManager;
  BreathingExercisesState({required this.apiService, required this.sharedPreferencesManager});




  Future<Response?> breathingTechniquesState() async {
    return await apiService.getPrivate(breathingTechniques, {});
  }

  Future<Response?> meditationMusicState() async {
    return await apiService.getPrivate(meditationMusic, {});
  }

  Future saveBreathingTechniquesState(Map<String, dynamic> data) async {
    return await apiService.postPrivate(saveMeditation, data);
  }

}


class DemoBreathingExercisesModel {
  String? title;
  String? subTitle;
  String? icon;
  String? desc;

  DemoBreathingExercisesModel({this.title, this.subTitle, this.icon, this.desc});
}
