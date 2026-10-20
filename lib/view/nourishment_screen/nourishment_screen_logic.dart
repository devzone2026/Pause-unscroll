import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/utils/appAssets.dart';

import '../../backend/models/get_nourishment_suggestions_model.dart';
import 'nourishment_screen_state.dart';

class NourishmentScreenLogic extends GetxController {
  final NourishmentScreenState state;

  NourishmentScreenLogic({required this.state});

  List<NourishmentLocalModel> list = [];
  NourishmentLocalModel? clickedItem;
  GetNourishmentSuggestionsModel getNourishmentSuggestionsModel = GetNourishmentSuggestionsModel();
  List<SuggestionBody> suggestionList = [];
  RxBool mainLoader = true.obs;

  List<SuggestionBody> allSuggestionList = [];
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    list.clear();
    // ["anxiety", "stress", "lowmood", "fatigue", "irritability", "focus", "cravings", "emotional", "sleepissues", "energyboost"]

    list.add(NourishmentLocalModel(title: "I'm Tired", id: "fatigue", icon: AssetPath.iconTeaCup));
    list.add(NourishmentLocalModel(title: "I Need To Focus", id: "focus", icon: AssetPath.iconBrain));
    list.add(NourishmentLocalModel(title: "I Feel Anxious", id: "anxiety", icon: AssetPath.iconMaterial));
    list.add(NourishmentLocalModel(title: "I Feel Lightheaded", id: "energyboost", icon: AssetPath.imgEnergy));

    list.add(NourishmentLocalModel(title: "I'm Stressed", id: "stress", icon: AssetPath.imgStressBrain));
    list.add(NourishmentLocalModel(title: "I Feel Low", id: "lowmood", icon: AssetPath.iconBrain));
    list.add(NourishmentLocalModel(title: "I Feel Irritable", id: "irritability", icon: AssetPath.imgIrritability));
    list.add(NourishmentLocalModel(title: "I Have Cravings", id: "cravings", icon: AssetPath.iconBrain));
    list.add(NourishmentLocalModel(title: "I'm Emotional", id: "emotional", icon: AssetPath.imgMentalHealth));

    list.add(NourishmentLocalModel(title: "I Can't Sleep", id: "sleepissues", icon: AssetPath.imgSleep));
  }

  Future<void> getNourishmentApi({required String mood}) async {
    try {
      final response = await state.nourishmentState(endUrl: "?mood=$mood");
      if (response != null && response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
        debugPrint("Profile Response :: $myMap");
        getNourishmentSuggestionsModel = GetNourishmentSuggestionsModel.fromJson(myMap);

        suggestionList.clear();
        allSuggestionList.clear(); // ✅ Save original list

        suggestionList.addAll(getNourishmentSuggestionsModel.data!);
        allSuggestionList.addAll(getNourishmentSuggestionsModel.data!); // ✅ Keep original copy

        mainLoader.value = false;
        update();
      }
    } catch (error) {
      mainLoader.value = false;
      debugPrint("Error: $error");
    }
  }


  void searchNourishment(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      // ✅ If search is empty → restore full list
      suggestionList.clear();
      suggestionList.addAll(allSuggestionList);
    } else {
      // ✅ Filter from original list
      final filtered = allSuggestionList.where((item) {
        // ✅ Change 'title' to whatever your model's search field is
        return item.title.toString().toLowerCase().contains(query.toLowerCase());
      }).toList();
      suggestionList.clear();
      suggestionList.addAll(filtered);
    }
    update();
  }
}

class NourishmentLocalModel {
  String id;
  String title;
  String icon;

  NourishmentLocalModel({required this.title, required this.icon, required this.id});
}
