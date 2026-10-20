import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

class IOSBottomSheet extends StatefulWidget {
  const IOSBottomSheet({super.key});

  @override
  State<IOSBottomSheet> createState() => _IOSBottomSheetState();
}

class _IOSBottomSheetState extends State<IOSBottomSheet> {
  int selectedValue = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Time",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                GestureDetector(
                  onTap: () => Navigator.pop(context, selectedValue),
                  child: const Text(
                    "Done",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),


              ],
            ),
          ),

          Expanded(
            child: CupertinoPicker(
              itemExtent: 40,
              scrollController: FixedExtentScrollController(
                initialItem: 0,
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedValue = index + 10;
                });
              },
              children: List.generate(
                111,
                    (index) => Center(
                  child: Text(
                    "${index + 10}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}