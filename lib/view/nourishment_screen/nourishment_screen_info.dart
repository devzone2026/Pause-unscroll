import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/view/nourishment_screen/nourishment_screen_logic.dart';
import 'package:pause_and_scroll/widgets/button_loader.dart';
import 'package:pause_and_scroll/widgets/commonButtonWidget.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonTextWidget.dart';
import '../../widgets/custom_text_field.dart';

class NourishmentScreenInfo extends StatefulWidget {
  const NourishmentScreenInfo({super.key});

  @override
  State<NourishmentScreenInfo> createState() => _NourishmentScreenInfoState();
}

class _NourishmentScreenInfoState extends State<NourishmentScreenInfo> {
  final NourishmentScreenLogic logic = Get.put(NourishmentScreenLogic(state: Get.find()));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      logic.mainLoader.value = true;
      logic.getNourishmentApi(mood: logic.clickedItem?.id ?? "focus");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: NourishmentScreenLogic(state: Get.find()),
      builder: (_) => Scaffold(
        backgroundColor: ThemeProvider.scaffolderColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.sp),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: ThemeProvider.scaffolderColor,
                  scrolledUnderElevation: 0,
                  elevation: 0,
                  pinned: true,
                  floating: false,
                  expandedHeight: 220.sp,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(20.sp),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.sp),
                      child: CustomTextField(
                        suffixIcon: SvgPicture.asset(AssetPath.iconSearch,height: 15,color: Colors.grey),
                        hintText: "Search...",
                        validator: (value) => null,
                        onChanged: (value) {
                          logic.searchNourishment(value);
                        },
                      ),
                    ),
                  ),

                  // ✅ This collapses when scrolled (title, subtitle, button)
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        40.verticalSpace,
                        Row(
                          children: [
                            CommonButtonWidget(
                              onPressed: () {},
                              title: logic.clickedItem?.title ?? "I'm Tired",
                              fontSize: 12,
                              height: 30.sp,
                              showIcon: true,
                              icon: AssetPath.iconNoti,
                              borderRadius: 12,
                              width: 140.sp,
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        CommonTextWidget(
                          heading: "Nourishment Ideas",
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: ThemeProvider.greenDarkColor,
                          paddingH: 20,
                          textAlign: TextAlign.start,
                        ),
                        5.verticalSpace,
                        CommonTextWidget(
                          heading: "Foods that may help",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ThemeProvider.blackColor,
                          paddingH: 20,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              body: Obx(() {
                return logic.mainLoader.value
                    ? Center(child: ButtonLoader())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: logic.suggestionList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(top: 15.sp),
                                  padding: EdgeInsets.symmetric(vertical: 20.sp),
                                  decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.all(Radius.circular(15.sp))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      spacing: 10.sp,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: ThemeProvider.greenDarkColor,
                                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                              ),
                                              child: SvgPicture.asset(AssetPath.iconMaterial, color: ThemeProvider.whiteColor),
                                            ),

                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                spacing: 5.sp,
                                                children: [
                                                  CommonTextWidget(
                                                    heading: logic.suggestionList[index].title ?? "",
                                                    fontSize: 16,
                                                    color: ThemeProvider.blackColor,
                                                    paddingH: 20,
                                                  ),
                                                  CommonTextWidget(
                                                    heading: logic.suggestionList[index].description ?? "",
                                                    fontWeight: FontWeight.w500,
                                                    maxLine: 3,
                                                    fontSize: 12,
                                                    color: ThemeProvider.blackColor,
                                                    paddingH: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 8.sp),
                                          decoration: BoxDecoration(color: ThemeProvider.scaffolderColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                                          child: RichText(
                                            textAlign: TextAlign.start,
                                            text: TextSpan(
                                              text: "Benefits: ",
                                              style: TextStyle(
                                                color: ThemeProvider.greenDarkColor,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 14.sp,
                                                fontFamily: "inter",
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: logic.suggestionList[index].benefits ?? "",
                                                  style: TextStyle(color: ThemeProvider.greenDarkColor, fontWeight: FontWeight.w500, fontFamily: "inter"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
