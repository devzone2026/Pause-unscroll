import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../backend/helper/appRoute.dart';
import '../../backend/models/get_profile.model.dart';
import '../../utils/toasts.dart';
import '../home_screen/home_screen_logic.dart';
import 'profile_screen_state.dart';

class ProfileScreenLogic extends GetxController {
  final ProfileScreenState state;

  ProfileScreenLogic({required this.state});

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController nameUpdateController = TextEditingController();

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxBool currentVisible = true.obs;
  RxBool newVisible = true.obs;
  RxBool confirmVisible = true.obs;

  RxBool notification1 =  true.obs;
  RxBool notification2 =  true.obs;
  RxBool notification3 =  true.obs;

  RxBool mainLoader = false.obs;
  XFile? selectedImage;
  String? profileImage;

  // =========================================================
  // Image compression helper
  // =========================================================
  // Resizes the longest side down to [minSize] px and re-encodes
  // as JPEG at [quality]. Returns the compressed File, or the
  // original file if compression fails for any reason (so upload
  // still proceeds rather than breaking the flow).
  Future<File> _compressImage(
      File file, {
        int quality = 60,
        int minWidth = 1080,
        int minHeight = 1080,
      }) async {
    try {
      final originalSizeKb = await file.length() / 1024;

      final Directory tempDir = await getTemporaryDirectory();
      final String targetPath = p.join(
        tempDir.path,
        "compressed_${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      final XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
        format: CompressFormat.jpeg,
      );

      if (compressedXFile == null) {
        debugPrint("Compression returned null, using original file");
        return file;
      }

      final File compressedFile = File(compressedXFile.path);
      final compressedSizeKb = await compressedFile.length() / 1024;

      debugPrint(
        "Image compressed: ${originalSizeKb.toStringAsFixed(0)}KB -> ${compressedSizeKb.toStringAsFixed(0)}KB",
      );

      return compressedFile;
    } catch (e, st) {
      debugPrint("Compression Error: $e");
      debugPrint("$st");
      // Fall back to original file so the user isn't blocked.
      return file;
    }
  }

  // Convenience wrapper: takes the picker's XFile, compresses it,
  // and updates selectedImage / profileImage with the result.
  Future<void> _handlePickedImage(XFile image) async {
    final File compressed = await _compressImage(File(image.path));
    selectedImage = XFile(compressed.path);
    profileImage = compressed.path;
    update();
  }

  Future<void> selectFromGallery(BuildContext context, String kind) async {
    try {
      if (kind == "gallery") {
        final XFile? image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 25,
        );

        if (image != null) {
          await _handlePickedImage(image);
        }
        return;
      }

      // =========================
      // iOS Camera
      // =========================
      if (Platform.isIOS) {
        final XFile? image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.rear,
          imageQuality: 25,
          requestFullMetadata: false,
        );

        if (image == null) {
          final status = await Permission.camera.status;
          debugPrint("iOS Camera Status: $status");

          if (status.isPermanentlyDenied || status.isRestricted) {
            await openAppSettings();
          }
          return;
        }

        await _handlePickedImage(image);
        return;
      }

      // =========================
      // Android Camera (Keep Existing)
      // =========================
      PermissionStatus status = await Permission.camera.status;

      if (status.isDenied) {
        status = await Permission.camera.request();
      }

      if (status.isGranted) {
        final XFile? image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 25,
        );

        if (image != null) {
          await _handlePickedImage(image);
        }
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    } catch (e, st) {
      debugPrint("Camera Error: $e");
      debugPrint("$st");
    }
  }

  Future<void> updateProfileApi() async {
    try {
      Map<String, dynamic> data = {"name": nameUpdateController.text.trim().toString()};

      state
          .updateProfileState(data, selectedImage != null ? File(selectedImage!.path) : null)
          .then((response) {
        if (response != null && response.statusCode == 200) {
          Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
          debugPrint("Update Profile Response :: $myMap");
          GetProfileModel().fromJson(myMap);
          mainLoader.value = false;
          Get.back();
          Future.microtask(() {
            Get.find<HomeScreenLogic>().update();
          });
        }
      })
          .catchError((e) {
        debugPrint("Error: $e");
        mainLoader.value = false;
      });
    } catch (error) {
      errorToast('${'Error signing in with Google'.tr}$error');
      mainLoader.value = false;
    }
  }

  Future<void> changePasswordApi() async {
    try {
      Map<String, dynamic> data = {"oldPassword": currentPasswordController.text.trim(), "password": newPasswordController.text.trim()};

      state
          .changePasswordState(data)
          .then((response) {
        if (response != null && response.statusCode == 200) {
          Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
          debugPrint("Change Password Response :: $myMap");
          mainLoader.value = false;
          Get.back();
        }
      })
          .catchError((e) {
        debugPrint("Error: $e");
        mainLoader.value = false;
      });
    } catch (error) {
      errorToast('${'Error signing in with Google'.tr}$error');
      mainLoader.value = false;
    }
  }

  Future<void> signOutApi() async {
    try {
      state
          .signOutState()
          .then((response) {
        if (response != null && response.statusCode == 200) {
          Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
          debugPrint("SignOut Response :: $myMap");
          state.clearShared();
          mainLoader.value = false;
          Get.offAllNamed(AppRouter.loginScreen);
        }
      })
          .catchError((e) {
        debugPrint("Error: $e");
      });
    } catch (error) {
      errorToast('${'Error signing in with Google'.tr}$error');
    }
  }

  Future<void> deleteApi() async {
    try {
      state.deleteState().then((response) {
        if (response != null && response.statusCode == 200) {
          Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
          debugPrint("SignOut Response :: $myMap");
          state.clearShared();
          mainLoader.value = false;
          Get.offAllNamed(AppRouter.loginScreen);
        }
      });
    } catch (error) {
      errorToast('${'Error signing in with Google'.tr}$error');
    }
  }
}