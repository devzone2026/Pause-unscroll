import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/utils/toasts.dart';
import 'package:pause_and_scroll/widgets/commonButtonWidget.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonTextWidget.dart';
import 'journal_screen_logic.dart';

class CreateJournalScreen extends StatefulWidget {
  const CreateJournalScreen({super.key});

  @override
  State<CreateJournalScreen> createState() => _CreateJournalScreenState();
}

class _CreateJournalScreenState extends State<CreateJournalScreen> {
  final JournalScreenLogic logic = Get.put(JournalScreenLogic(state: Get.find()));
  String isEditId = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      if (args != null && args is List && args.isNotEmpty) {
        logic.noteController.text = args[0]?.toString() ?? "";
        isEditId = args.length > 1 ? args[1]?.toString() ?? "" : "";
        logic.update();
      }
    });
  }

  @override
  void dispose() {
    logic.noteController.text = '';
    logic.saveLoader.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: JournalScreenLogic(state: Get.find()),
      builder: (controller) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
          backgroundColor: ThemeProvider.scaffolderColor,
          appBar: AppBar(scrolledUnderElevation: 0, backgroundColor: ThemeProvider.scaffolderColor, centerTitle: true),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.sp),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  pinned: true,        // ← makes it sticky
                  floating: false,
                  snap: false,
                  scrolledUnderElevation: 0,
                  backgroundColor: ThemeProvider.scaffolderColor,
                  toolbarHeight: Get.height * .1,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          CommonTextWidget(heading: "New Entry", fontWeight: FontWeight.w700, fontSize: 16, color: ThemeProvider.greenDarkColor),
                          CommonTextWidget(
                            heading: "Your thoughts are auto-saved",
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: ThemeProvider.blackColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          20.verticalSpace,

                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.sp), color: ThemeProvider.whiteColor),
                            child: TextField(
                              controller: logic.noteController,
                              minLines: 12,
                              maxLines: 13,
                              decoration: InputDecoration(
                                hintText: "Type a message...",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: ThemeProvider.textFieldBorderColor.withValues(alpha: .2),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: ThemeProvider.textFieldBorderColor.withValues(alpha: .3), width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: ThemeProvider.textFieldBorderColor.withValues(alpha: .3), width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: ThemeProvider.textFieldBorderColor.withValues(alpha: .3), width: 1.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Button always stays at bottom
                  Obx(() {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: CommonButtonWidget(
                        isLoading: logic.saveLoader.value,
                        onPressed: () {
                          if (logic.noteController.text.trim().isEmpty) {
                            errorToast("Please enter a note");
                          } else {
                            logic.saveLoader.value = true;
                            if (isEditId.isNotEmpty) {
                              logic.updateJournalApi(id: isEditId);
                            } else {
                              logic.createJournalApi();
                            }
                          }
                        },
                        title: "Save",
                        showIcon: true,
                        icon: AssetPath.iconSave,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
