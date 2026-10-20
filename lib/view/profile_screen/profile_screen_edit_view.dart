import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pause_and_scroll/utils/constants.dart';
import 'package:pause_and_scroll/widgets/commonButtonWidget.dart';
import 'package:pause_and_scroll/widgets/laod_image.dart';
import '../../backend/models/get_profile.model.dart';
import '../../dialogs/camera.dart';
import '../../utils/appAssets.dart';
import '../../utils/appTheme.dart';
import '../../widgets/commonTextWidget.dart';
import '../../widgets/custom_text_field.dart';
import '../home_screen/home_screen_logic.dart';
import 'profile_screen_logic.dart';


class ProfileScreenEditView extends StatefulWidget {
  const ProfileScreenEditView({super.key});

  @override
  State<ProfileScreenEditView> createState() => _ProfileScreenEditViewState();
}

class _ProfileScreenEditViewState extends State<ProfileScreenEditView> {
  final ProfileScreenLogic logic = Get.put(ProfileScreenLogic(state: Get.find()));
  final HomeScreenLogic homeLogic = Get.find<HomeScreenLogic>();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    logic.nameUpdateController.text = GetProfileModel().data?.name ?? "";
    logic.emailController.text = GetProfileModel().data?.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ThemeProvider.scaffolderColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: ThemeProvider.scaffolderColor,
          centerTitle: true,
          title: CommonTextWidget(
            heading: "Edit Profile",
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: ThemeProvider.greenDarkColor,
          ),
        ),
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [],
                body: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30.sp),
                      padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
                      decoration: BoxDecoration(
                        color: ThemeProvider.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(15.sp)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              GetBuilder<ProfileScreenLogic>(
                                builder: (logic) =>
                                    Container(
                                      height: 95.sp,
                                      width: 95.sp,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipOval(
                                        child: logic.profileImage != null
                                            ? Image.file(
                                          File(logic.profileImage!),
                                          height: 95.sp,
                                          width: 95.sp,
                                          fit: BoxFit.cover,
                                        )
                                            : GetProfileModel().data!.image.isNotEmpty
                                            ? loadImage(image: Constants.baseImageUrl + GetProfileModel().data!.image)
                                            :  Image.asset(
                                          AssetPath.imgDemo,
                                          height: 95.sp,
                                          width: 95.sp,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        ImageSourceActionSheet(
                                          onCameraSelected: () {
                                            logic.selectFromGallery(context, "camera");
                                          },
                                          onGallerySelected: () {
                                            logic.selectFromGallery(context, "gallery");
                                          },
                                        ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    gradient: ThemeProvider.mainGradient,
                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                  ),
                                  child: SvgPicture.asset(AssetPath.iconCamera),
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CommonTextWidget(
                                heading: "Update User Name",
                                fontSize: 16,
                                color: ThemeProvider.blackColor,
                                paddingH: 10,
                              ),
                              CustomTextField(
                                prefixIcon: SvgPicture.asset(AssetPath.iconPerson),
                                hintText: "Enter Name",
                                controller: logic.nameUpdateController,
                                bgColor: ThemeProvider.scaffolderColor,
                              ),
                            ],
                          ),
                          5.verticalSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CommonTextWidget(
                                heading: "Update Email",
                                fontSize: 16,
                                color: ThemeProvider.blackColor,
                                paddingH: 10,
                              ),
                              CustomTextField(
                                prefixIcon: SvgPicture.asset(AssetPath.iconEmail),
                                readOnly: true,
                                controller: logic.emailController,
                                hintText: "Enter Email",
                                bgColor: ThemeProvider.scaffolderColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),


                    Obx(() {
                      return CommonButtonWidget(
                        isLoading: logic.mainLoader.value,
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            logic.mainLoader.value = true;
                            Future.delayed(Duration(seconds: 2), () {
                              logic.updateProfileApi();
                            });
                          }
                        },
                        title: "Save",
                        showIcon: true,
                        icon: AssetPath.iconSave,
                      );
                    }),
                    20.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
