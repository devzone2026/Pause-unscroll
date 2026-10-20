import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/view/breathing_exercises/breathing_exercises_logic.dart';

import '../utils/appAssets.dart';
import '../utils/appTheme.dart';
import 'commonTextWidget.dart';

class BottomSheetAllSong extends StatefulWidget {
  final BreathingExercisesLogic logic;
  final String? value;

  const BottomSheetAllSong(this.logic,this.value, {super.key});

  @override
  State<BottomSheetAllSong> createState() => _BottomSheetAllSongState();
}

class _BottomSheetAllSongState extends State<BottomSheetAllSong> {
  String selectedValue = "";



  @override
  void initState() {
    selectedValue = widget.value ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Choose Music",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: ThemeProvider.greenDarkColor),
                ),

                const Text(
                  "Select a meditation track",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),

              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: widget.logic.getMusicList.data?.length,
                itemBuilder: (context, index) {
                 return GestureDetector(
                   onTap: () async{
                     print("===> ${widget.logic.musicBody.audioUrl ?? ""}");
                     widget.logic.songID = widget.logic.getMusicList.data?[index].id ?? "";
                     await widget.logic.player.setUrl(widget.logic.getMusicList.data?[index].audioUrl ?? "");
                     widget.logic.player.play();

                     setState(() {
                       widget.logic.getMusicList.data?.forEach((e) => e.demoPlay = false);
                       widget.logic.getMusicList.data?[index].demoPlay = true;
                     });
                   },
                   child: Container(
                     margin: EdgeInsets.only(top: 10.sp),
                     padding: EdgeInsets.symmetric(vertical: 10.sp),
                     decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                     child: Padding(
                       padding: EdgeInsets.symmetric(horizontal: 10),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.start,
                         spacing: 5.sp,
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [

                               Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 children: [
                                   Container(
                                     padding: EdgeInsets.all(8),
                                     decoration: BoxDecoration(
                                         color: ThemeProvider.greenDarkColor,
                                         borderRadius: BorderRadius.all(Radius.circular(100))
                                     ),
                                     child: widget.logic.getMusicList.data?[index].demoPlay == true
                                         ? Icon(Icons.play_arrow_outlined,color: Colors.white,)
                                         : SvgPicture.asset(AssetPath.iconMusic, color: ThemeProvider.whiteColor),
                                   ),

                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     spacing: 5.sp,
                                     children: [
                                       CommonTextWidget(heading: widget.logic.getMusicList.data?[index].title ?? "", fontSize: 16, color: ThemeProvider.blackColor, paddingH: 10),
                                       CommonTextWidget(heading: widget.logic.getMusicList.data?[index].duration ?? "",
                                           fontWeight: FontWeight.w500,
                                           fontSize: 12,
                                           color: ThemeProvider.blackColor,
                                           paddingH: 10),
                                     ],
                                   ),
                                 ],
                               ),

                               GestureDetector(
                                 onTap: () {
                                   setState(() {
                                     widget.logic.player.stop();
                                     selectedValue = widget.logic.getMusicList.data?[index].id ?? "";
                                     widget.logic.songID = widget.logic.getMusicList.data?[index].id ?? "";
                                     Navigator.pop(context, widget.logic.getMusicList.data?[index]);
                                   });
                                 },
                                 child: Container(
                                   padding: EdgeInsets.all(2),
                                   decoration: BoxDecoration(
                                       color: (selectedValue == widget.logic.getMusicList.data?[index].id) ? ThemeProvider.greenDarkColor : Colors.transparent,
                                       border: (selectedValue != widget.logic.getMusicList.data?[index].id) ? Border.all(width: 1,color: ThemeProvider.blackColor): null,
                                       borderRadius: BorderRadius.all(Radius.circular(100))
                                   ),
                                   child: Icon(Icons.check,color: ThemeProvider.whiteColor,size: 18.sp,),
                                 ),
                               ),

                             ],
                           ),
                         ],
                       ),
                     ),
                   ),
                 );
                }),
          ),


        ],
      ),
    );
  }
}