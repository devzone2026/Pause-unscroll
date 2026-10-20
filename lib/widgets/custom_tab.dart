

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/appTheme.dart';
import 'commonTextWidget.dart';

class CustomToggleTab extends StatefulWidget {
  final Function(int) onTabChanged;
  final List<String> tabs;

  const CustomToggleTab({
    super.key,
    required this.onTabChanged,
    required this.tabs,
  });

  @override
  State<CustomToggleTab> createState() => _CustomToggleTabState();
}

class _CustomToggleTabState extends State<CustomToggleTab> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(widget.tabs.length, (index) {
          final isSelected = _selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedIndex = index);
                widget.onTabChanged(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? ThemeProvider.mainGradient
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CommonTextWidget(
                  heading: widget.tabs[index],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? ThemeProvider.whiteColor : ThemeProvider.blackColor,
                  paddingH: 20,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}