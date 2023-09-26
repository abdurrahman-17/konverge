import 'package:flutter/material.dart';
import '../../core/app_export.dart';

import '../../utilities/enums.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    super.key,
    this.shape,
    this.padding,
    this.variant,
    this.alignment,
    this.margin,
    this.width,
    this.height,
    this.child,
    this.onTap,
  });

  final IconButtonShape? shape;
  final IconButtonPadding? padding;
  final IconButtonVariant? variant;
  final Alignment? alignment;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Widget? child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildIconButtonWidget(),
          )
        : _buildIconButtonWidget();
  }

  Widget _buildIconButtonWidget() {
    return Container(
      alignment: Alignment.center,
      width: getSize(width ?? 0),
      height: getSize(height ?? 0),
      padding: _setPadding(),
      decoration: _buildDecoration(),
      child: IconButton(
        iconSize: getSize(height ?? 0),
        padding: const EdgeInsets.all(0),
        icon: SizedBox(
          child: child,
        ),
        onPressed: onTap,
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: _setColor(),
      borderRadius: _setBorderRadius(),
    );
  }

  EdgeInsetsGeometry _setPadding() {
    switch (padding) {
      case IconButtonPadding.paddingAll24:
        return getPadding(all: 24);
      case IconButtonPadding.paddingAll0:
        return getPadding(all: 0);
      case IconButtonPadding.paddingAll7:
        return getPadding(all: 0);
      case IconButtonPadding.paddingV5H4:
        return getPadding(left: 4, top: 5, right: 4, bottom: 5);
      default:
        return getPadding(all: 0);
    }
  }

  Color? _setColor() {
    switch (variant) {
      case IconButtonVariant.fillTeal300:
        return AppColors.teal300;
      case IconButtonVariant.fillBlack9007c:
        return AppColors.black9007c;
      default:
        return AppColors.tealA700;
    }
  }

  BorderRadius _setBorderRadius() {
    switch (shape) {
      case IconButtonShape.circleBorder32:
        return BorderRadius.circular(
          getHorizontalSize(32.00),
        );
      case IconButtonShape.roundedBorder14:
        return BorderRadius.circular(
          getHorizontalSize(14.00),
        );
      default:
        return BorderRadius.circular(
          getHorizontalSize(10.00),
        );
    }
  }
}
