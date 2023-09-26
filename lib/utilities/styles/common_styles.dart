import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/app_export.dart';

final headingStyle = TextStyle(
  color: Colors.black,
  fontSize: getFontSize(25),
  fontWeight: FontWeight.bold,
);

final BoxDecoration commonBgBackgroundGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.black9004c,
      AppColors.indigo90001,
      AppColors.cyan900,
      AppColors.cyan90001,
    ],
  ),
);
final appBarTextStyle = TextStyle(
  color: Colors.white,
  fontSize: getFontSize(20),
);

final forgotStyle = TextStyle(
  fontSize: getFontSize(15),
  fontWeight: FontWeight.w500,
  color: Colors.black,
);
Widget? commonBackgroundImage;
Widget commonBackground = Container(
  width: double.infinity,
  height: double.infinity,
  child: SvgPicture.asset(
    Assets.backgroundImage,
    fit: BoxFit.cover,
  ),
  // commonBackgroundImage??Image.asset(
  //   Assets.backgroundImagePng,
  //   fit: BoxFit.cover,
  // ),
);

BoxDecoration commonGradientBg = BoxDecoration(
  // color: AppColors.black9004c,
  // image: const DecorationImage(
  //   image: AssetImage(
  //     Assets.backgroundImagePng,
  //   ),
  //   fit: BoxFit.cover,
  // ),
  //   gradient: LinearGradient(
  //     begin: Alignment(0.00, -1.00),
  //     end: Alignment(0, 1),
  //     colors: [Color(0xFF181440), Color(0xFF073045)],
  //   )
  gradient:  LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [Color(0xFF110e2d), Color(0xFF091f30), Color(0xFF091f30), Color(0xFF032330)],
  ),

  // gradient: LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [
  //     AppColors.black9004c,
  //     AppColors.indigo90001,
  //     AppColors.cyan900,
  //     AppColors.cyan90001,
  //   ],
  // ),
);

BoxDecoration profileGradientBg = BoxDecoration(
  color: AppColors.black9004c,
  // image: const DecorationImage(
  //   image: AssetImage(
  //     Assets.blueGradientOne,
  //   ),
  //   fit: BoxFit.cover,
  // ),
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.black9004c,
      AppColors.indigo90001,
      AppColors.cyan900,
      AppColors.cyan90001,
    ],
  ),
);
