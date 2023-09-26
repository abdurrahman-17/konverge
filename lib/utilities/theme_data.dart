import 'package:flutter/material.dart';
import 'colors.dart';

final themData = ThemeData(
  primarySwatch: AppColors.kPrimaryMaterialColor,
);

final themeData = ThemeData(
  primarySwatch: AppColors.kPrimaryMaterialColor,
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(AppColors.grey929292)
  ),
  dialogTheme: DialogTheme(
    // Set the background color of AlertDialog
    backgroundColor: AppColors.black900,
  ),
  // remove ripple effect
  hoverColor: AppColors.transparent,
  highlightColor: AppColors.transparent,
  focusColor: AppColors.transparent,
  splashColor: AppColors.transparent,
);
