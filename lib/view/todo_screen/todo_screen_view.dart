import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/widgets/screen_loader.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonTextWidget.dart';
import '../../widgets/custom_tabbar.dart';
import '../../widgets/custom_text_field.dart';
import 'todo_screen_logic.dart';

class TodoScreenPage extends StatefulWidget {
  const TodoScreenPage({super.key});

  @override
  State<TodoScreenPage> createState() => _TodoScreenPageState();
}

class _TodoScreenPageState extends State<TodoScreenPage> {
  final TodoScreenLogic logic = Get.put(TodoScreenLogic(state: Get.find()));

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TodoScreenLogic(state: Get.find()),
      builder: (controller) => Scaffold(
        backgroundColor: ThemeProvider.scaffolderColor,
        appBar: AppBar(scrolledUnderElevation: 0,backgroundColor: ThemeProvider.scaffolderColor, centerTitle: true),
        body: NotificationListener<ScrollNotification>(
          onNotification: logic.onScrollNotification,
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            CommonTextWidget(heading: "To-Do Lists", fontWeight: FontWeight.w700, fontSize: 16, color: ThemeProvider.greenDarkColor),
                            CommonTextWidget(heading: "0 of 0 completed", fontWeight: FontWeight.w400, fontSize: 14, color: ThemeProvider.blackColor),
                          ],
                        ),

                        20.verticalSpace,
                        CustomTabBar(
                          onTabChanged: (index) {
                            logic.currentIndex = index;
                            debugPrint("Selected index: $index");
                            logic.currentPage = 1;
                            logic.apiLoader.value = true;
                            logic.getTodoApi(pagination: logic.currentPage);
                            logic.update();
                          },
                        ),
                        10.verticalSpace,

                        if (logic.currentIndex == 1)
                          CustomTabBarDays(
                            onTabChanged: (index) {
                              logic.currentDay = index;
                              logic.filterTodoByDay(index);
                            },
                          ),

                        15.verticalSpace,
                        Container(
                          margin: EdgeInsets.only(bottom: 15.sp),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          height: Get.height * .07,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.sp), color: ThemeProvider.whiteColor),
                          child: Row(
                            children: [
                              Flexible(
                                child: CustomTextField(controller: logic.todoController, hintText: "Add New Task....", bgColor: ThemeProvider.scaffolderColor),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (logic.todoController.text.isNotEmpty) {
                                    logic.createTodoApi();
                                  }
                                },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(gradient: ThemeProvider.mainGradient, borderRadius: BorderRadiusGeometry.circular(12)),
                                  child: SvgPicture.asset(AssetPath.iconAdd, height: 10),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Obx(() {
                          return Expanded(child: (logic.apiLoader.value)
                              ? Center(child: ScreenLoader())
                              : (logic.todoList.isEmpty)
                              ? Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: Get.height * .18,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: ThemeProvider.blackColor.withValues(alpha: 0.2),
                                      spreadRadius: .5,
                                      blurRadius: .5,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(15.sp),
                                  color: ThemeProvider.whiteColor,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 8.sp,
                                  children: [
                                    CommonTextWidget(
                                      heading: "No tasks yet",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: ThemeProvider.blackColor.withValues(alpha: .5),
                                    ),
                                    CommonTextWidget(
                                      heading: "Add a task to get started",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: ThemeProvider.blackColor.withValues(alpha: .5),
                                    ),
                                  ],
                                ),
                              ),
                              40.verticalSpace,
                              SvgPicture.asset(AssetPath.bannerTodo, height: 180.sp),
                            ],
                          )
                              : Column(
                            children: List.generate(logic.todoList.length, (index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 15.sp),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: Get.height * .07,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.sp), color: ThemeProvider.whiteColor),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () => logic.todoCompleteApi(logic.todoList[index].id ?? ""),
                                            child: Icon(
                                              logic.todoList[index].isCompleted == true ? Icons.radio_button_checked : Icons.radio_button_off,
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: CommonTextWidget(
                                              heading: logic.todoList[index].title ?? "",
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: ThemeProvider.blackColor,
                                              textDecoration: logic.todoList[index].isCompleted == true ? TextDecoration.lineThrough : TextDecoration.none,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(AssetPath.iconNoti, height: 20),
                                        SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () => logic.deleteTodoApi(journalId: logic.todoList[index].id ?? ""),
                                          child: SvgPicture.asset(AssetPath.iconDel, height: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ));
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
