import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import '../../utilities/colors.dart';
import '../../utilities/enums.dart';
import '../../utilities/size_utils.dart';
import 'custom_rich_text.dart';

///outlined button design
class CustomOutlinedButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Color? buttonBgColor;
  final void Function() onTap;

  const CustomOutlinedButton({
    Key? key,
    required this.title,
    this.height,
    required this.onTap,
    this.width,
    this.textStyle,
    this.buttonBgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onTap,
        style: ButtonStyle(
          side: MaterialStateProperty.all(
            BorderSide(color: buttonBgColor ?? AppColors.kPrimaryColor),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(getHorizontalSize(30)),
            ),
          ),
        ),
        child: Text(
          title,
          maxLines: 1,
          style: textStyle ??
              TextStyle(
                color: Colors.white,
                fontSize: getFontSize(14),
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Color? buttonBgColor;
  final void Function() onTap;

  const CustomElevatedButton({
    Key? key,
    required this.title,
    this.height,
    required this.onTap,
    this.width,
    this.textStyle,
    this.buttonBgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            buttonBgColor ?? AppColors.kPrimaryColor,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                getHorizontalSize(20),
              ),
            ),
          ),
        ),
        child: Text(
          title,
          maxLines: 1,
          style: textStyle ??
              TextStyle(
                color: Colors.white,
                fontSize: getFontSize(17),
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    this.shape,
    this.padding,
    this.variant,
    this.fontStyle,
    this.alignment,
    this.margin,
    this.onTap,
    this.width,
    // this.height,
    this.text,
    this.mainAxis = MainAxisAlignment.center,
    this.prefixWidget,
    this.suffixWidget,
    this.enabled = false,
    this.isVisible = true,
  });

  final bool enabled;
  final bool isVisible;
  final ButtonShape? shape;
  final ButtonPadding? padding;
  final ButtonVariant? variant;
  final ButtonFontStyle? fontStyle;
  final Alignment? alignment;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? width;

  // double? height;
  final String? text;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final MainAxisAlignment mainAxis;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildButtonWidget(),
          )
        : _buildButtonWidget();
  }

  void hideKeyboard() {
    if (globalNavigatorKey.currentContext != null)
      FocusScope.of(globalNavigatorKey.currentContext!).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Widget _buildButtonWidget() {
    if (isVisible) {
      return Padding(
        padding: margin ?? EdgeInsets.zero,
        child: TextButton(
          onPressed: () {
            hideKeyboard();
            if (onTap != null) onTap!();
          },
          style: _buildTextButtonStyle(),
          child: _buildButtonWithOrWithoutIcon(),
        ),
      );
    } else {
      return Padding(
        padding: margin ?? EdgeInsets.zero,
      );
    }
    // return Padding(
    //   padding: margin ?? EdgeInsets.zero,
    // );
    // return Padding(
    //   padding: margin ?? EdgeInsets.zero,
    //   child: TextButton(
    //     onPressed: onTap,
    //     style: _buildTextButtonStyle(),
    //     child: _buildButtonWithOrWithoutIcon(),
    //   ),
    // );
  }

  Widget _buildButtonWithOrWithoutIcon() {
    if (prefixWidget != null || suffixWidget != null) {
      return Row(
        mainAxisAlignment: mainAxis,
        children: [
          prefixWidget ?? const SizedBox(),
          CustomRichText(
            text: text ?? "",
            style: _setFontStyle(),
            textAlign: TextAlign.start,
          ),
          if (suffixWidget != null && mainAxis == MainAxisAlignment.start)
            const Spacer(),
          suffixWidget ?? const SizedBox(),
        ],
      );
    } else {
      return CustomRichText(
        text: text ?? "",
        style: _setFontStyle(),
        textAlign: TextAlign.center,
      );
    }
  }

  ButtonStyle? _buildTextButtonStyle() {
    return TextButton.styleFrom(
      // fixedSize: Size(
      //   width ?? double.maxFinite,
      //   height ?? getVerticalSize(40),
      // ),
      fixedSize: Size.fromWidth(
        width ?? double.maxFinite,
      ),
      padding: _setPadding(),
      backgroundColor: _setColor(),
      shadowColor: _setTextButtonShadowColor(),
      side: _setTextButtonBorder(),
      shape: RoundedRectangleBorder(
        borderRadius: _setBorderRadius(),
      ),
    );
  }

  EdgeInsetsGeometry? _setPadding() {
    switch (padding) {
      case ButtonPadding.paddingH20:
        return getPadding(
          left: 20,
          right: 20,
          top: 12,
          bottom: 12,
        );
      case ButtonPadding.paddingT11:
        return getPadding(
          top: 11,
          right: 11,
          bottom: 11,
          left: 11,
        );
      case ButtonPadding.paddingAll9:
        return getPadding(all: 9);
      case ButtonPadding.paddingAll6:
        return getPadding(all: 6);
      default:
        return getPadding(all: 12);
    }
  }

  Color? _setColor() {
    switch (variant) {
      case ButtonVariant.outlineBlack90035:
        return enabled ? AppColors.tealA400 : AppColors.teal700;
      case ButtonVariant.fillWhiteA700:
        return AppColors.whiteA700;
      case ButtonVariant.fillBlack9007c:
        return AppColors.black9007c;
      case ButtonVariant.outlineTealA400:
      case ButtonVariant.outlineTealA400_1:
        return null;
      case ButtonVariant.transparent:
        return AppColors.transparent;
      default:
        return enabled ? AppColors.tealA400 : AppColors.teal700;
    }
  }

  BorderSide? _setTextButtonBorder() {
    switch (variant) {
      case ButtonVariant.outlineTealA400:
        return BorderSide(
          color: AppColors.tealA400,
          width: getHorizontalSize(1.00),
        );
      case ButtonVariant.outlineTealA400_1:
        return BorderSide(
          color: AppColors.tealA400,
          width: getHorizontalSize(1.00),
        );
      default:
        return null;
    }
  }

  Color? _setTextButtonShadowColor() {
    switch (variant) {
      // case ButtonVariant.outlineBlack90035_1:
      //   return AppColors.black90035;
      case ButtonVariant.outlineTealA400:
        return AppColors.black90035;
      case ButtonVariant.fillGray800:
      case ButtonVariant.outlineTealA400_1:
        return null;
      case ButtonVariant.outlineBlack90035:
        return AppColors.black90035;
      case ButtonVariant.fillWhiteA700:
        return null;
      default:
        return AppColors.black90035;
    }
  }

  BorderRadiusGeometry _setBorderRadius() {
    switch (shape) {
      case ButtonShape.square:
        return BorderRadius.circular(0);
      case ButtonShape.roundedBorder16:
        return BorderRadius.circular(
          getHorizontalSize(16.00),
        );
      case ButtonShape.roundedBorder8:
        return BorderRadius.circular(
          getHorizontalSize(8.00),
        );
      case ButtonShape.roundedBorder13:
        return BorderRadius.circular(
          getHorizontalSize(13.00),
        );
      case ButtonShape.roundedBorder26:
        return BorderRadius.circular(
          getHorizontalSize(26.00),
        );
      default:
        return BorderRadius.circular(
          getHorizontalSize(100),
        );
    }
  }

  TextStyle? _setFontStyle() {
    switch (fontStyle) {
      case ButtonFontStyle.poppinsMedium16:
        return TextStyle(
          color: AppColors.black900,
          fontSize: getFontSize(16),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          // height: getVerticalSize(1.50),
        );
      case ButtonFontStyle.poppinsRegular14:
        return TextStyle(
          color: AppColors.black900,
          fontSize: getFontSize(14),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          // height: getVerticalSize(1.50),
        );
      case ButtonFontStyle.poppinsRegular9:
        return TextStyle(
          color: AppColors.whiteA700,
          fontSize: getFontSize(9),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          // height: getVerticalSize(1.56),
        );
      case ButtonFontStyle.poppinsRegular14WhiteA700:
        return TextStyle(
          color: AppColors.whiteA700,
          fontSize: getFontSize(14),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          // height: getVerticalSize(1.50),
        );
      case ButtonFontStyle.poppinsRegular15WhiteA400:
        return TextStyle(
          color: AppColors.whiteA700,
          fontSize: getFontSize(15),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          // height: getVerticalSize(1.50),
        );
      default:
        return TextStyle(
          color: AppColors.black900,
          fontSize: getFontSize(15),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          // height: getVerticalSize(1.53),
        );
    }
  }
}
