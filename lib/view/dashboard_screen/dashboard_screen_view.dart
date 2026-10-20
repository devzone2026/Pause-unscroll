import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/utils/appTheme.dart';

import 'dashboard_screen_logic.dart';

class DashboardScreenPage extends StatefulWidget {
  const DashboardScreenPage({super.key});

  @override
  State<DashboardScreenPage> createState() => _DashboardScreenPageState();
}

class _DashboardScreenPageState extends State<DashboardScreenPage> {
  final DashboardScreenLogic logic = Get.put(DashboardScreenLogic(state: Get.find()));


  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DashboardScreenLogic(state: Get.find()),
      builder:(_) =>  SafeArea(
        left: true, right: true, bottom: true, top: false,
        child: Scaffold(
          body: Obx(() {
            return IndexedStack(
              alignment: AlignmentGeometry.center,
              index: logic.selectedIndex.value,
              children: logic.pages,
            );
          }),

          bottomNavigationBar: Obx(() {
            return Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(logic.icons.length, (i) {
                  final isSelected = i == logic.selectedIndex.value;
                  return GestureDetector(
                    onTap: () => logic.onTap(i),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Indicator dot
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 4,
                          width: isSelected ? 28.sp : 0,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A7C59),
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(2), bottomRight: Radius.circular(2)),
                          ),
                        ),
                        const SizedBox(height: 4),

                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(logic.icons[i],color: isSelected ? ThemeProvider.greenDarkColor : ThemeProvider.hintColor)
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}
