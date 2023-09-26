import 'dart:developer';

import 'package:flutter/material.dart';

import '../colors.dart';
import '../enums.dart';
import '../size_utils.dart';

class TextFormFieldStyles {
  InputDecoration buildDecoration({
    required String? hintText,
    required String? counterText,
    required Widget? prefix,
    required Widget? suffix,
    required BoxConstraints? prefixConstraints,
    required BoxConstraints? suffixConstraints,
    required TextFormFieldShape? shape,
    required TextFormFieldPadding? padding,
    required TextFormFieldVariant? variant,
    required TextFormFieldFontStyle? hintStyle,
    required TextFormFieldVariant? focusedInputBorder,
    TextFormFieldVariant focus = TextFormFieldVariant.outlineTealA400,
    TextFormFieldVariant errorVariant = TextFormFieldVariant.outlineRedA4000_1,
    bool isEnabled = true,
  }) {
    return InputDecoration(
      counterText: counterText ?? "",
      hintText: hintText ?? "",
      hintStyle: setFontStyle(
        isEnabled ? hintStyle : TextFormFieldFontStyle.poppinsMedium14Disabled,
      ),
      errorStyle: setFontStyle(
        TextFormFieldFontStyle.poppinsMedium14Error,
      ),
      prefix: Padding(
        padding: _setPrefixPadding(padding),
      ),
      border: _setBorderStyle(shape, variant),
      enabledBorder: _setBorderStyle(shape, variant),
      errorBorder: _setBorderStyle(shape, errorVariant),
      focusedBorder: _setBorderStyle(shape, focusedInputBorder),
      disabledBorder: _setBorderStyle(shape, variant),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      fillColor: _setFillColor(variant),
      filled: _setFilled(variant),
      isDense: true,
      contentPadding: _setPadding(padding),
      labelStyle: TextStyle(
        color: isEnabled ? null : Colors.grey,
        fontSize: 18,
      ),
    );
  }

  TextStyle setFontStyle(TextFormFieldFontStyle? fontStyle) {
    switch (fontStyle) {
      case TextFormFieldFontStyle.poppinsMedium14Disabled:
        log('$fontStyle');
        return TextStyle(
          color: AppColors.grey929292,
          fontSize: getFontSize(14),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(1.50),
        );
      case TextFormFieldFontStyle.poppinsMedium14Error:
        log('$fontStyle');
        return TextStyle(
          color: Colors.red[700],
          fontSize: getFontSize(14),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(1.50),
        );
      case TextFormFieldFontStyle.poppinsMedium14:
        return TextStyle(
          color: AppColors.gray50001,
          fontSize: getFontSize(14),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(1.50),
        );
      case TextFormFieldFontStyle.poppinsRegular10:
        return TextStyle(
          color: AppColors.whiteA700,
          fontSize: getFontSize(10),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(1.50),
        );
      case TextFormFieldFontStyle.poppinsMedium14WhiteA700:
        return TextStyle(
          color: AppColors.whiteA700,
          fontSize: getFontSize(14),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(1.50),
        );
      case TextFormFieldFontStyle.poppinsMedium14WhiteA700PasswordDot:
        return TextStyle(
          color: AppColors.whiteA700,
          fontSize: getFontSize(14),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(1.50),
        );
      case TextFormFieldFontStyle.poppinsMedium14Black900:
        return TextStyle(
          color: AppColors.black900,
          fontSize: getFontSize(14),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(1.50),
        );
      case TextFormFieldFontStyle.poppinsLight13:
        return TextStyle(
          color: AppColors.whiteA700,
          fontSize: getFontSize(13),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300,
          height: getVerticalSize(1.54),
        );
      case TextFormFieldFontStyle.poppinsLight14:
        return TextStyle(
          color: AppColors.blueGray400,
          fontSize: getFontSize(14),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300,
          height: getVerticalSize(1.50),
        );
      case TextFormFieldFontStyle.poppinsRegular12WhiteA7007f:
        return TextStyle(
          color: AppColors.whiteA700,
          fontSize: getFontSize(12),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(1.50),
        );
      case TextFormFieldFontStyle.poppinsMedium13:
        return TextStyle(
          color: AppColors.gray50001,
          fontSize: getFontSize(13),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(1.54),
        );
      case TextFormFieldFontStyle.poppinsLight14WhiteA700:
        return TextStyle(
          color: AppColors.whiteA700,
          fontSize: getFontSize(14),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300,
          height: getVerticalSize(1.50),
        );

      default:
        return TextStyle(
          color: AppColors.tealA400,
          fontSize: getFontSize(12),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(1.50),
        );
    }
  }

  BorderRadius _setOutlineBorderRadius(TextFormFieldShape? shape) {
    switch (shape) {
      case TextFormFieldShape.roundedBorder12:
        return BorderRadius.circular(
          getHorizontalSize(12.00),
        );
      case TextFormFieldShape.roundedBorder14:
        return BorderRadius.circular(
          getHorizontalSize(14.00),
        );
      case TextFormFieldShape.roundedBorder8:
        return BorderRadius.circular(
          getHorizontalSize(8.00),
        );
      case TextFormFieldShape.roundedBorder3:
        return BorderRadius.circular(
          getHorizontalSize(3.00),
        );
      case TextFormFieldShape.roundedBorder50:
        return BorderRadius.circular(
          getHorizontalSize(50.00),
        );
      default:
        return BorderRadius.circular(
          getHorizontalSize(4.00),
        );
    }
  }

  InputBorder? _setBorderStyle(
      TextFormFieldShape? shape, TextFormFieldVariant? variant) {
    switch (variant) {
      case TextFormFieldVariant.outlineBlack90035:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(shape),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.outlineBlack90035_2:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(shape),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.outlineTealA400:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(shape),
          borderSide: BorderSide(
            color: AppColors.tealA400,
          ),
        );
      case TextFormFieldVariant.outlineRedA4000_1:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(shape),
          borderSide: BorderSide(
            color: AppColors.red30001,
          ),
        );
      case TextFormFieldVariant.outlineTealA400_1:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(shape),
          borderSide: BorderSide(
            color: AppColors.tealA400,
          ),
        );
      case TextFormFieldVariant.outlineBlueGray70001:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(shape),
          borderSide: BorderSide(
            color: AppColors.blueGray70001,
          ),
        );
      case TextFormFieldVariant.outlineBlack90035_1:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(shape),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.outlineTealA400_2:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(shape),
          borderSide: BorderSide(
            color: AppColors.tealA400,
          ),
        );
      case TextFormFieldVariant.fillBlack9007c:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(shape),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.none:
        return InputBorder.none;
      default:
        return UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.gray40033,
          ),
        );
    }
  }

  Color? _setFillColor(TextFormFieldVariant? variant) {
    switch (variant) {
      case TextFormFieldVariant.outlineBlack90035:
        return AppColors.blueGray10033;
      case TextFormFieldVariant.outlineTealA400:
        return AppColors.blueGray10033;
      case TextFormFieldVariant.outlineBlack90035_1:
        return AppColors.tealA400;
      case TextFormFieldVariant.outlineBlack90035_2:
        return AppColors.blueGray10033;
      case TextFormFieldVariant.outlineBlack90035_3:
        return AppColors.black90066;
      case TextFormFieldVariant.outlineTealA400_2:
        return AppColors.blueGray10033;
      case TextFormFieldVariant.fillBlack9007c:
        return AppColors.black9007c;
      default:
        return null;
    }
  }

  bool _setFilled(TextFormFieldVariant? variant) {
    switch (variant) {
      case TextFormFieldVariant.underLineGray40033:
        return false;
      case TextFormFieldVariant.outlineBlack90035:
        return true;
      case TextFormFieldVariant.outlineBlack90035_3:
        return true;
      case TextFormFieldVariant.outlineTealA400:
        return true;
      case TextFormFieldVariant.outlineTealA400_1:
        return false;
      case TextFormFieldVariant.outlineBlack90035_1:
        return true;
      case TextFormFieldVariant.outlineBlack90035_2:
        return true;
      case TextFormFieldVariant.outlineTealA400_2:
        return true;
      case TextFormFieldVariant.fillBlack9007c:
        return true;
      case TextFormFieldVariant.none:
        return false;
      default:
        return false;
    }
  }

  EdgeInsetsGeometry _setPadding(TextFormFieldPadding? padding) {
    switch (padding) {
      case TextFormFieldPadding.paddingT1:
        return getPadding(
          top: 1,
          bottom: 1,
        );
      case TextFormFieldPadding.paddingAll7:
        return getPadding(all: 7);
      case TextFormFieldPadding.paddingT36:
        return getPadding(
          left: 0,
          top: 36,
          right: 15,
          bottom: 36,
        );
      case TextFormFieldPadding.paddingSignUpTextField:
        return getPadding(
          left: 0,
          top: 13,
          right: 26,
          bottom: 13,
        );
      case TextFormFieldPadding.paddingConfirmPassword:
        return getPadding(
          left: 0,
          top: 13,
          right: 13,
          bottom: 13,
        );
      case TextFormFieldPadding.paddingT36_1:
        return getPadding(
          left: 0,
          top: 36,
          right: 12,
          bottom: 36,
        );
      case TextFormFieldPadding.paddingT10:
        return getPadding(
          left: 0,
          top: 10,
          bottom: 10,
        );
      case TextFormFieldPadding.paddingV12H15:
        return getPadding(
          left: 0,
          right: 15,
          top: 12,
          bottom: 12,
        );
      case TextFormFieldPadding.paddingV15H25:
        return getPadding(
          left: 0,
          right: 25,
          top: 15,
          bottom: 15,
        );
      case TextFormFieldPadding.paddingT0:
        return getPadding(
          left: 0,
          top: 13,
          right: 12,
          bottom: 13,
        );
      default:
        return getPadding(
          left: 0,
          top: 13,
          right: 12,
          bottom: 13,
        );
    }
  }

  EdgeInsetsGeometry _setPrefixPadding(TextFormFieldPadding? padding) {
    switch (padding) {
      case TextFormFieldPadding.paddingT1:
        return getPadding(all: 0);
      case TextFormFieldPadding.paddingAll7:
        return getPadding(all: 7);
      case TextFormFieldPadding.paddingT36:
        return getPadding(
          left: 15,
        );
      case TextFormFieldPadding.paddingSignUpTextField:
        return getPadding(
          left: 13,
        );
      case TextFormFieldPadding.paddingConfirmPassword:
        return getPadding(
          left: 13,
        );
      case TextFormFieldPadding.paddingT36_1:
        return getPadding(
          left: 13,
        );
      case TextFormFieldPadding.paddingT10:
        return getPadding(
          left: 10,
        );
      case TextFormFieldPadding.paddingV12H15:
        return getPadding(
          left: 15,
        );
      case TextFormFieldPadding.paddingV15H25:
        return getPadding(
          left: 15,
        );
      case TextFormFieldPadding.paddingT0:
        return getPadding(
          left: 0,
        );
      default:
        return getPadding(left: 13);
    }
  }
}
