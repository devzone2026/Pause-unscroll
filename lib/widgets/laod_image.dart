
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/appAssets.dart';

Widget loadImage({required String? image, double? size, String? placeHolder}) {
  return image != null
      ? Image.network(image,
      width: size ?? 95.sp,
      height: size ?? 95.sp,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return CircleAvatar(maxRadius: 22.sp, child: Center(child: CircularProgressIndicator()));
      },
      errorBuilder: (context, error, stackTrace) =>
          CircleAvatar(maxRadius: 95.sp, backgroundImage: AssetImage(placeHolder ?? AssetPath.imgDemo)))
      : CircleAvatar(maxRadius:  95.sp, backgroundImage: AssetImage(placeHolder ?? AssetPath.imgDemo));
}