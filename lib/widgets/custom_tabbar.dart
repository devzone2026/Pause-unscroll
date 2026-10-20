import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pause_and_scroll/utils/appAssets.dart';

import '../utils/appTheme.dart';
import 'commonTextWidget.dart';


// TODO :: Daily, weekly.... TabBar
class CustomTabBar extends StatefulWidget {
  final Function(int) onTabChanged; // ✅ add this
  const CustomTabBar({super.key, required this.onTabChanged});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int _selectedIndex = 0;
  final List<String> _tabs = ["Daily", "Weekly"];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: List.generate(_tabs.length, (index) {
        final isSelected = _selectedIndex == index;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onTabChanged(index);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(color: isSelected ? ThemeProvider.greenDarkColor : ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(12)),
              child: CommonTextWidget(
                heading: _tabs[index],
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: isSelected ? Colors.white : ThemeProvider.blackColor,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }),
    );
  }
}



// TODO :: Sunday, Monday.... TabBar
class CustomTabBarDays extends StatefulWidget {
  final Function(int) onTabChanged; // ✅ add this
  const CustomTabBarDays({super.key, required this.onTabChanged});

  @override
  State<CustomTabBarDays> createState() => _CustomTabBarDaysState();
}

class _CustomTabBarDaysState extends State<CustomTabBarDays> {
  int _selectedIndex = -1;
  final List<String> _tabs = ["S", "M", "T", "W", "T", "F", "S"];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(_tabs.length, (index) {
        final isSelected = _selectedIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedIndex = index);
            widget.onTabChanged(index);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(color: isSelected ? ThemeProvider.greenDarkColor : ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(12)),
            child: CommonTextWidget(
              heading: _tabs[index],
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: isSelected ? Colors.white : ThemeProvider.blackColor,
            ),
          ),
        );
      }),
    );
  }
}


// TODO :: Hydration.... TabBar
class CustomHydration extends StatefulWidget {
  final Function(int) onTabChanged;
  final int? listLength;
  final int initialValue;

  const CustomHydration({
    super.key,
    required this.onTabChanged,
    this.listLength,
    this.initialValue = 0,
  });

  @override
  State<CustomHydration> createState() => _CustomHydrationState();
}

class _CustomHydrationState extends State<CustomHydration> {
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(widget.listLength ?? 8, (index) {

        final isSelected = index < selectedValue;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedValue = index + 1;
            });

            widget.onTabChanged(selectedValue);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(
                  width: 1,
                  color: isSelected ? Colors.green : Colors.grey,
                ),
                color: isSelected
                    ? ThemeProvider.greenDarkColor
                    : ThemeProvider.whiteColor,
              ),
              child: SvgPicture.asset(
                AssetPath.iconDrop,
                color: isSelected ? Colors.green : Colors.grey,
              ),
            ),
          ),
        );
      }),
    );
  }
}
