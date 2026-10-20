import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../backend/models/get_totdo_model.dart';
import 'todo_screen_state.dart';

class TodoScreenLogic extends GetxController {
  final TodoScreenState state;

  TodoScreenLogic({required this.state});

  int currentIndex = 0;
  int currentDay = 0;
  TextEditingController todoController = TextEditingController();
  GetTodoModel getTodoModel = GetTodoModel();
  List<TodoBody> todoList = [];
  int currentPage = 1;
  RxBool apiLoader = true.obs;

  @override
  void onInit() {
    super.onInit();
    getTodoApi(pagination: currentPage);
  }

  Future<void> getTodoApi({required int pagination}) async {
    try {
      final response = await state.getTodoState(
        pagination,
        currentIndex == 0
            ? "daily"
            : currentIndex == 1
            ? "weekly"
            : "monthly",
      );
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        debugPrint("Todo Response :: $map");
        getTodoModel = GetTodoModel.fromJson(map);
        if(pagination == 1)  todoList.clear();
        todoList.addAll(getTodoModel.data!);
        apiLoader.value = false;
        update();
      }
    } catch (error) {
      apiLoader.value = false;
      debugPrint("meditationMusicApi error: $error");
    }
  }


  void filterTodoByDay(int dayIndex) {
    todoList.clear();
    todoList.addAll(
      getTodoModel.data!.where((todo) =>
      todo.daysOfWeek != null && todo.daysOfWeek.contains(dayIndex)).toList());
    update();
  }

  Future<void> createTodoApi() async {
    try {
      const List<String> dayNames = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"];

      final data = {
        "title": todoController.text.trim(),
        "frequency": currentIndex == 0
            ? "daily"
            : currentIndex == 1
            ? "weekly"
            : "monthly",

        if (currentIndex == 1) "daysOfWeek": [dayNames[currentDay]],
      };

      debugPrint("body :: $data");
      final response = await state.createTodoState(data);
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        debugPrint("Save Breathing Tech. Response :: $map");
        currentPage = 1;
        todoController.clear();
        update();
        getTodoApi(pagination: currentPage);
      }
    } catch (error) {
      debugPrint("saveBreathingTechniquesApi error: $error");
    }
  }

  Future<void> deleteTodoApi({required String journalId}) async {
    try {
      final response = await state.todoDeleteState(journalId);
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        debugPrint("Save Breathing Tech. Response :: $map");
        todoList.removeAt(todoList.indexWhere((element) => element.id == journalId));
        update();
      }
    } catch (error) {
      debugPrint("saveBreathingTechniquesApi error: $error");
    }
  }

  void todoCompleteApi(String s) async {
    try {
      final response = await state.completeTodoState(s);
      if (response?.statusCode == 200) {
        final map = Map<String, dynamic>.from(response!.data as Map);
        debugPrint("Save Breathing Tech. Response :: $map");
        currentPage = 1;
        getTodoApi(pagination: currentPage);
      }
    } catch (error) {
      debugPrint("saveBreathingTechniquesApi error: $error");
    }
  }


  bool onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      debugPrint("total pages :: ${getTodoModel.totalRecord ?? 0}");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        currentPage++;
        getTodoApi(pagination: currentPage);
      });
    }
    return false;
  }
}
