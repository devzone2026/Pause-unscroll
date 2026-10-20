
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pause_and_scroll/utils/appTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenLoader extends StatefulWidget {
  const ScreenLoader({super.key});

  @override
  State<ScreenLoader> createState() => _ScreenLoaderState();
}

class _ScreenLoaderState extends State<ScreenLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  SharedPreferences? sharedPref;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      sharedPref = await SharedPreferences.getInstance();
    });
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
     animation: _controller,
     builder: (_, child) {
       return Row(
         mainAxisSize: MainAxisSize.min,
         children: List.generate(4, (index) {
           return Padding(
             padding: const EdgeInsets.symmetric(horizontal: 2),
             child: Transform.scale(
               scale: (1 - ((_controller.value + (index * 0.2)) % 1.0)),
               child: CircleAvatar(
                   radius: 4,
                   backgroundColor: ThemeProvider.greenDarkColor
               ),
             ),
           );
         }),
       );
     },
          );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SharedPreferences>('sharedPref', sharedPref));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}



