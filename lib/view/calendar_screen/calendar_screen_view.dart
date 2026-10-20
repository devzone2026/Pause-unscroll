import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pause_and_scroll/utils/appAssets.dart';
import 'package:pause_and_scroll/utils/appTheme.dart';
import 'package:pause_and_scroll/utils/utils_methods.dart';
import 'package:pause_and_scroll/widgets/button_loader.dart';
import 'package:pause_and_scroll/widgets/commonButtonWidget.dart';
import 'package:pause_and_scroll/widgets/commonButtonWidget1.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../widgets/commonTextWidget.dart';
import '../../widgets/custom_tab.dart';
import '../../widgets/custom_text_field.dart';
import 'calendar_screen_logic.dart';

class CalendarScreenPage extends StatefulWidget {
  const CalendarScreenPage({super.key});

  @override
  State<CalendarScreenPage> createState() => _CalendarScreenPageState();
}

class _CalendarScreenPageState extends State<CalendarScreenPage> with SingleTickerProviderStateMixin {
  final CalendarScreenLogic logic = Get.put(CalendarScreenLogic(state: Get.find()));

  final _formKey = GlobalKey<FormState>();

  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _fabAnimation = CurvedAnimation(parent: _fabController, curve: Curves.easeInOut);

    _scrollController.addListener(() {
      final collapsed = _scrollController.offset > 280;
      if (collapsed != _isCollapsed) {
        setState(() => _isCollapsed = collapsed);
        if (collapsed) {
          _fabController.forward();
        } else {
          _fabController.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.scaffolderColor,
      body: GetBuilder<CalendarScreenLogic>(
        init: CalendarScreenLogic(state: Get.find()),
        builder: (_) {
          return Form(
            key: _formKey,
            child: SafeArea(
              child: Stack(
                children: [
                  // ─── Main scroll content ──────────────────────────────────
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // ─── Collapsing Calendar Header ───────────────────────
                      SliverAppBar(
                        expandedHeight: 360.sp,
                        collapsedHeight: 60,
                        pinned: true,
                        floating: false,
                        elevation: 0,
                        backgroundColor: ThemeProvider.scaffolderColor,
                        automaticallyImplyLeading: false,

                        // ── Collapsed state ──
                        title: AnimatedOpacity(
                          opacity: _isCollapsed ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: GestureDetector(
                            onTap: () {
                              _scrollController.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: ThemeProvider.whiteColor,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [BoxShadow(color: ThemeProvider.blackColor.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 8,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(gradient: ThemeProvider.mainGradient, shape: BoxShape.circle),
                                    child: Icon(Icons.calendar_month_rounded, color: ThemeProvider.whiteColor, size: 16),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        DateFormat('MMMM yyyy').format(logic.focusedDay.value),
                                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: ThemeProvider.greenDarkColor),
                                      ),
                                      Text(
                                        "Tap to expand calendar",
                                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: ThemeProvider.blackColor.withValues(alpha: 0.5)),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.keyboard_arrow_down_rounded, color: ThemeProvider.greenDarkColor, size: 18),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // ── Expanded state ──
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              20.verticalSpace,
                              // Header text
                              AnimatedOpacity(
                                opacity: _isCollapsed ? 0.0 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                child: Column(
                                  children: [
                                    CommonTextWidget(
                                      heading: "Wellness Calendar",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: ThemeProvider.greenDarkColor,
                                      paddingH: 20,
                                      textAlign: TextAlign.center,
                                    ),
                                    4.verticalSpace,
                                    CommonTextWidget(
                                      heading: "Plan meals and workouts",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: ThemeProvider.blackColor.withValues(alpha: 0.6),
                                      paddingH: 20,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                              12.verticalSpace,

                              // Calendar card
                              Card(
                                margin: const EdgeInsets.symmetric(horizontal: 12),
                                elevation: 3,
                                shadowColor: ThemeProvider.greenDarkColor.withValues(alpha: 0.15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: TableCalendar(
                                  firstDay: DateTime.utc(2020, 1, 1),
                                  lastDay: DateTime.now(),
                                  focusedDay: logic.focusedDay.value,
                                  calendarFormat: logic.calendarFormat.value,
                                  availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                                  rowHeight: 36,
                                  daysOfWeekHeight: 28,
                                  selectedDayPredicate: (day) => isSameDay(logic.selectedDay.value, day),
                                  onDaySelected: (selected, focused) {
                                    logic.selectedDay.value = selected;
                                    logic.focusedDay.value = focused;

                                    final formatted = DateFormat('EEEE, MMMM d').format(selected);
                                    final apiDate = DateFormat('yyyy-MM-dd').format(selected);
                                    logic.selectedDate = formatted;

                                    final today = DateTime.now();
                                    final selectedDateOnly = DateTime(selected.year, selected.month, selected.day);
                                    final todayOnly = DateTime(today.year, today.month, today.day);
                                    logic.isPastDate = selectedDateOnly.isBefore(todayOnly);
                                    logic.oldDayLoader.value = true;
                                    logic.getEventsApi(date: apiDate);
                                    logic.update();
                                  },
                                  onFormatChanged: (format) {
                                    logic.calendarFormat.value = format;
                                  },
                                  headerStyle: HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                    titleTextStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: ThemeProvider.greenDarkColor),
                                    leftChevronIcon: Icon(Icons.chevron_left, color: ThemeProvider.greenDarkColor, size: 20),
                                    rightChevronIcon: Icon(Icons.chevron_right, color: ThemeProvider.greenDarkColor, size: 20),
                                    headerPadding: const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                  daysOfWeekStyle: DaysOfWeekStyle(
                                    weekdayStyle: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: ThemeProvider.blackColor.withValues(alpha: 0.5),
                                    ),
                                    weekendStyle: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: ThemeProvider.greenDarkColor.withValues(alpha: 0.7),
                                    ),
                                  ),
                                  calendarStyle: CalendarStyle(
                                    cellMargin: const EdgeInsets.all(2),
                                    defaultDecoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(6))),
                                    weekendDecoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(6))),
                                    outsideDecoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(6))),
                                    todayDecoration: BoxDecoration(
                                      color: ThemeProvider.greenLiteColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                    ),
                                    selectedDecoration: BoxDecoration(
                                      color: ThemeProvider.greenDarkColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                    ),
                                    markerDecoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(Radius.circular(3)),
                                    ),
                                    defaultTextStyle: TextStyle(fontSize: 12.sp),
                                    weekendTextStyle: TextStyle(fontSize: 12.sp, color: ThemeProvider.greenDarkColor),
                                    selectedTextStyle: TextStyle(fontSize: 12.sp, color: ThemeProvider.whiteColor, fontWeight: FontWeight.w700),
                                    todayTextStyle: TextStyle(fontSize: 12.sp, color: ThemeProvider.whiteColor, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ─── Body content ─────────────────────────────────────
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              10.verticalSpace,

                              // ── Selected date card ──
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 15.sp),
                                decoration: BoxDecoration(
                                  color: ThemeProvider.whiteColor,
                                  borderRadius: BorderRadius.all(Radius.circular(15.sp)),
                                  boxShadow: [BoxShadow(color: ThemeProvider.blackColor.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Date row + add button
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CommonTextWidget(
                                              heading: logic.selectedDate ?? DateFormat('EEEE, MMMM d').format(DateTime.now()),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: ThemeProvider.greenDarkColor,
                                            ),

                                          ],
                                        ),
                                        if (!logic.isPastDate)
                                          GestureDetector(
                                            onTap: () {
                                              logic.addItems = !logic.addItems;
                                              logic.update();
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                gradient: logic.addItems ? null : ThemeProvider.mainGradient,
                                                color: logic.addItems ? ThemeProvider.blackColor.withValues(alpha: 0.08) : null,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                logic.addItems ? Icons.close_rounded : Icons.add_rounded,
                                                color: logic.addItems ? ThemeProvider.blackColor.withValues(alpha: 0.5) : ThemeProvider.whiteColor,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),

                                    // ── Add form (today/future only) ──
                                    if (!logic.isPastDate && logic.addItems) ...[
                                      12.verticalSpace,
                                      Container(
                                        padding: EdgeInsets.all(12.sp),
                                        decoration: BoxDecoration(color: ThemeProvider.scaffolderColor, borderRadius: BorderRadius.circular(12)),
                                        child: Column(
                                          children: [
                                            CustomToggleTab(
                                              tabs: const ["Meal", "Workout"],
                                              onTabChanged: (index) {
                                                logic.isMealTabOpen = index == 0;
                                                logic.update();
                                              },
                                            ),
                                            8.verticalSpace,
                                            if (logic.isMealTabOpen)
                                              Obx(
                                                () => Row(
                                                  spacing: 5,
                                                  children: [
                                                    Flexible(
                                                      child: CommonButtonWidget1(
                                                        onPressed: () => logic.mealIndexing.value = 0,
                                                        height: 32.h,
                                                        paddingH: 0,
                                                        paddingV: 4,
                                                        title: "Breakfast",
                                                        fontSize: 11,
                                                        titleColor: logic.mealIndexing.value == 0 ? ThemeProvider.whiteColor : ThemeProvider.blackColor,
                                                        firstGradientColor: logic.mealIndexing.value == 0
                                                            ? ThemeProvider.greenDarkColor
                                                            : ThemeProvider.whiteColor,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: CommonButtonWidget1(
                                                        onPressed: () => logic.mealIndexing.value = 1,
                                                        height: 32.h,
                                                        paddingH: 0,
                                                        paddingV: 4,
                                                        title: "Lunch",
                                                        fontSize: 11,
                                                        titleColor: logic.mealIndexing.value == 1 ? ThemeProvider.whiteColor : ThemeProvider.blackColor,
                                                        firstGradientColor: logic.mealIndexing.value == 1
                                                            ? ThemeProvider.greenDarkColor
                                                            : ThemeProvider.whiteColor,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: CommonButtonWidget1(
                                                        onPressed: () => logic.mealIndexing.value = 2,
                                                        height: 32.h,
                                                        paddingH: 0,
                                                        paddingV: 4,
                                                        title: "Dinner",
                                                        fontSize: 11,
                                                        titleColor: logic.mealIndexing.value == 2 ? ThemeProvider.whiteColor : ThemeProvider.blackColor,
                                                        firstGradientColor: logic.mealIndexing.value == 2
                                                            ? ThemeProvider.greenDarkColor
                                                            : ThemeProvider.whiteColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            8.verticalSpace,
                                            CustomTextField(
                                              controller: logic.calendarController,
                                              hintText: logic.isMealTabOpen ? "e.g salmon and vegetables..." : "e.g 30 min yoga...",
                                              validator: (value) {
                                                if (logic.calendarController.text.trim().isEmpty) {
                                                  return "Please enter a title";
                                                }
                                                return null;
                                              },
                                            ),
                                            8.verticalSpace,
                                            Row(
                                              spacing: 10,
                                              children: [
                                                Obx(() {
                                                  return Flexible(
                                                    child: CommonButtonWidget(
                                                      onPressed: () {
                                                        FocusManager.instance.primaryFocus!.unfocus();
                                                        if (_formKey.currentState!.validate()) {
                                                          logic.addLoader.value = true;
                                                          final submitDate = DateFormat('yyyy-MM-dd').format(logic.selectedDay.value);
                                                          logic.createCalendarApi(date: submitDate, title: logic.calendarController.text);
                                                        }
                                                      },
                                                      isLoading: logic.addLoader.value,
                                                      title: "Add",
                                                      height: 35.h,
                                                      paddingH: 0,
                                                    ),
                                                  );
                                                }),
                                                Flexible(
                                                  child: CommonButtonWidget1(
                                                    onPressed: () {
                                                      logic.addItems = false;
                                                      logic.update();
                                                    },
                                                    title: "Cancel",
                                                    height: 35.h,
                                                    paddingH: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                    // ── Past date summary ──

                                    Obx(() {
                                     return  logic.oldDayLoader.value
                                         ?  Center(child: ButtonLoader())
                                         : (logic.isPastDate)
                                         ? Column(children: [12.verticalSpace, _buildEventSummaryCard("Day Summary", logic)])
                                         : SizedBox();
                                    }),



                                    // ── Events list ──
                                    Obx(() {
                                      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                                      final apiDate = convertToApiDate(logic.selectedDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now()));
                                      return (logic.todayLoader.value)
                                          ? Center(child: ButtonLoader())
                                          : (logic.calendarList.isNotEmpty && apiDate == today)
                                          ? Column(
                                              children: [
                                                ...[
                                                  12.verticalSpace,
                                                  ...List.generate(logic.calendarList.length, (index) {
                                                    final item = logic.calendarList[index];
                                                    return Container(
                                                      margin: const EdgeInsets.only(bottom: 8),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFF0F4F8),
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      ),
                                                      child: ListTile(
                                                        dense: true,
                                                        visualDensity: VisualDensity.comfortable,
                                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                                        title: CommonTextWidget(
                                                          heading: item.title ?? "",
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w600,
                                                          color: ThemeProvider.greenDarkColor,
                                                          textAlign: TextAlign.start,
                                                        ),
                                                        subtitle: CommonTextWidget(
                                                          heading: (item.mealType ?? item.type ?? "").capitalizeFirst ?? "",
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w300,
                                                          color: ThemeProvider.blackColor.withValues(alpha: 0.5),
                                                          textAlign: TextAlign.start,
                                                        ),
                                                        trailing: GestureDetector(
                                                          onTap: () => logic.deleteEventApi(eventId: item.id ?? ""),
                                                          child: Icon(Icons.close_rounded, size: 18, color: ThemeProvider.blackColor.withValues(alpha: 0.4)),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ],
                                              ],
                                            )
                                          : SizedBox();
                                    }),
                                  ],
                                ),
                              ),

                              20.verticalSpace,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Reusable summary card (replaces repeated Card widgets) ──────────────────
  Widget _buildEventSummaryCard(String title, CalendarScreenLogic logic) {
    return Column(
      spacing: 10,
      children: [
        if (logic.getEventModel.data?.summary != null)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ThemeProvider.whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeProvider.greenDarkColor.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: ThemeProvider.mainGradient,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  ),
                  child: Text(
                    "Day Summary",
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: ThemeProvider.whiteColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _buildItem(icon: AssetPath.iconMeditation, value: "Meditation Minutes: ${logic.getEventModel.data!.summary!.meditationMinutes}"),
                      _buildItem(icon: AssetPath.iconMeditation, value: "Breathing Sessions: ${logic.getEventModel.data!.summary!.breathingSessions}"),
                      _buildItem(icon: AssetPath.iconApplee, value:  "Meals Count: ${logic.getEventModel.data!.summary!.mealsCount}"),
                      _buildItem(icon: AssetPath.iconDumBell, value: "Workout Count: ${logic.getEventModel.data!.summary!.workoutCount}"),
                      _buildItem(icon: AssetPath.iconDrop, value: "Hydration: ${logic.getEventModel.data!.summary!.hydration}"),
                      _buildItem(icon: AssetPath.iconEmoji, value: "Mood: ${logic.getEventModel.data!.summary!.mood}"),
                      _buildItem(icon: AssetPath.iconDumBell, value: "Workout Minutes: ${logic.getEventModel.data!.summary!.workoutMinutes}"),
                    ],
                  ),
                ),
              ],
            ),
          ),

        if (logic.getEventModel.data!.mindActivities.isNotEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ThemeProvider.whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeProvider.greenDarkColor.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: ThemeProvider.mainGradient,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  ),
                  child: Text(
                    "Mind Activity",
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: ThemeProvider.whiteColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: List.generate(logic.getEventModel.data!.mindActivities.length, (index) {
                      return _buildItem(icon: AssetPath.iconBrain, value: "${logic.getEventModel.data!.mindActivities[index].label ?? ""}: ${logic.getEventModel.data!.mindActivities[index].value ?? ""}");
                    }),
                  ),
                )
              ],
            ),
          ),

        if (logic.getEventModel.data!.meals.isNotEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ThemeProvider.whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeProvider.greenDarkColor.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: ThemeProvider.mainGradient,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  ),
                  child: Text(
                    "Meal",
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: ThemeProvider.whiteColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: List.generate(logic.getEventModel.data!.meals.length, (index) {
                      return _buildItem(icon: AssetPath.iconApplee, value: "${logic.getEventModel.data!.meals[index].label ?? ""}: ${logic.getEventModel.data!.meals[index].value ?? ""}");
                    }),
                  ),
                ),
              ],
            ),
          ),

        if (logic.getEventModel.data!.workouts.isNotEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ThemeProvider.whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeProvider.greenDarkColor.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: ThemeProvider.mainGradient,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  ),
                  child: Text(
                    "Meal",
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: ThemeProvider.whiteColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: List.generate(logic.getEventModel.data!.workouts.length, (index) {
                      return _buildItem(icon: AssetPath.iconDumBell, value: "${logic.getEventModel.data!.workouts[index].label ?? ""}: ${logic.getEventModel.data!.workouts[index].value ?? ""}");
                    }),
                  ),
                ),
              ],
            ),
          ),

        if (logic.getEventModel.data!.journal.isNotEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ThemeProvider.whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeProvider.greenDarkColor.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: ThemeProvider.mainGradient,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  ),
                  child: Text(
                    "Meal",
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: ThemeProvider.whiteColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: List.generate(logic.getEventModel.data!.journal.length, (index) {
                      return _buildItem(icon: AssetPath.iconBrain, value: "${logic.getEventModel.data!.journal[index].label ?? ""}: ${logic.getEventModel.data!.journal[index].value ?? ""}");
                    }),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ── Item chip ───────────────────────────────────────────────────────────────
  Widget _buildItem({required String icon, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: ThemeProvider.greenDarkColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: ThemeProvider.greenDarkColor, shape: BoxShape.circle),
            child: SvgPicture.asset(icon, height: 12, color: ThemeProvider.whiteColor),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: ThemeProvider.greenDarkColor),
          ),
        ],
      ),
    );
  }
}
