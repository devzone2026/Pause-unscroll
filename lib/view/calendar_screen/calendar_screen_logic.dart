
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../backend/models/get_event_model.dart';
import '../../backend/models/get_today_event_model.dart';
import 'calendar_screen_state.dart';

class CalendarScreenLogic extends GetxController {
  final CalendarScreenState state;
  CalendarScreenLogic({required this.state});

  TextEditingController calendarController = TextEditingController();
  final calendarFormat = CalendarFormat.month.obs;
  final focusedDay = DateTime.now().obs;
  final selectedDay = DateTime.now().obs;

  String? selectedDate;
  bool isMealTabOpen = true;
  bool isPastDate = false;
  bool addItems = false;
  RxInt mealIndexing = 0.obs;
  List<MealsWorkout> calendarList = [];

  RxBool addLoader = false.obs;
  GetEventModel getEventModel = GetEventModel();
  GetTodayEventModel getTodayEventModel = GetTodayEventModel();


  RxBool todayLoader = true.obs;
  RxBool oldDayLoader = true.obs;


  @override
  void onInit() {
    super.onInit();
    getEventsApi(date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  Future<void> createCalendarApi({required String date, required String title}) async {
    try {
      final data = {
        "date": date,
        "type": isMealTabOpen ? "meal" : "workout",
        if(isMealTabOpen)
        "mealType": mealIndexing.value == 0 ? "breakfast" : mealIndexing.value == 1 ? "lunch" : mealIndexing.value == 2 ? "dinner" : "",
        "title": title
      };
      debugPrint("body :: $data");
      final response = await state.createCalendarState(data);
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        debugPrint("Add Event Response :: $map");
        final createdItem = MealsWorkout.fromJson(
          Map<String, dynamic>.from(map["data"] as Map),
        );
        calendarList.add(createdItem);

        addLoader.value = false;
        calendarController.text = "";
        addItems = false;
        update();
      }
    } catch (error) {
      addLoader.value = false;
      debugPrint("saveBreathingTechniquesApi error: $error");
    }
  }

  Future<void> getEventsApi({required String date}) async {
    try {
      final response = await state.getEventsState("?date=$date");
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        debugPrint("Get Event Response :: $map");
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        if (date == today) {
          getTodayEventModel = GetTodayEventModel.fromJson(map);
          calendarList.clear();
          calendarList.addAll(getTodayEventModel.data!.mealsWorkouts);
          debugPrint("Stored in getTodayEventModel");
        } else {
          getEventModel = GetEventModel.fromJson(map);
          debugPrint("Stored in getEventModel");
        }
        oldDayLoader.value = false;
        todayLoader.value = false;
        update();
      }
    } catch (error) {
      oldDayLoader.value = false;
      todayLoader.value = false;
      debugPrint("getEventsApi error: $error");
    }
  }

  Future<void> deleteEventApi({required String eventId}) async {
    try {
      final response = await state.deleteEventState(eventId);
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        calendarList.removeAt(calendarList.indexWhere((element) => element.id == eventId));
        update();
        debugPrint("Save Breathing Tech. Response :: $map");
        update();
      }
    } catch (error) {
      debugPrint("saveBreathingTechniquesApi error: $error");
    }
  }
}
