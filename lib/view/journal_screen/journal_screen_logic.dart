import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../backend/models/get_journal_model.dart';
import 'journal_screen_state.dart';

class JournalScreenLogic extends GetxController {
  final JournalScreenState state;

  JournalScreenLogic({required this.state});

  TextEditingController noteController = TextEditingController();
  GetJournalModel getJournalModel = GetJournalModel();
  List<JournalBody> journalList = [];
  int currentPage = 1;
  int listLength = 0;

  RxBool saveLoader = false.obs;
  RxBool apiLoader = true.obs;

  @override
  void onInit() {
    super.onInit();
    getJournalApi(pagination: currentPage);
  }

  Future<void> getJournalApi({required int pagination}) async {
    try {
      final response = await state.getJournalState(pagination);
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        debugPrint("Music Response :: $map");
        getJournalModel = GetJournalModel.fromJson(map);
        if(pagination == 1) journalList.clear();
        journalList.addAll(getJournalModel.data!);
        listLength = getJournalModel.totalRecord ?? 0;
        apiLoader.value = false;
        update();
      }
    } catch (error) {
      debugPrint("meditationMusicApi error: $error");
    }
  }

  Future<void> createJournalApi() async {
    try {
      final data = {"content": noteController.text.trim()};
      debugPrint("body :: $data");
      final response = await state.journalCreateState(data);
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        debugPrint("Save Breathing Tech. Response :: $map");
        currentPage = 1;
        getJournalApi(pagination: currentPage);
        listLength++;
        Get.back();
      }
    } catch (error) {
      debugPrint("saveBreathingTechniquesApi error: $error");
    }
  }

  Future<void> deleteJournalApi({required String journalId}) async {
    try {
      final response = await state.journalDeleteState(journalId);
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        debugPrint("Save Breathing Tech. Response :: $map");
        journalList.removeAt(journalList.indexWhere((element) => element.id == journalId));
        listLength--;
        update();
      }
    } catch (error) {
      debugPrint("saveBreathingTechniquesApi error: $error");
    }
  }

  Future<void> updateJournalApi({required String id}) async {
    try {
      final data = {"content": noteController.text.trim()};
      final response = await state.journalUpdateState(id, data);
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        debugPrint("Update journal Response :: $map");
        currentPage = 1;
        getJournalApi(pagination: currentPage);
        Get.back();
      }
    } catch (error) {
      debugPrint("saveBreathingTechniquesApi error: $error");
    }
  }

  bool onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      debugPrint("total pages :: ${getJournalModel.totalRecord ?? 0}");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        currentPage++;
        getJournalApi(pagination: currentPage);
      });
    }
    return false;
  }



}
