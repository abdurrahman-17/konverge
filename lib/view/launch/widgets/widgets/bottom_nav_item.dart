import 'package:flutter/material.dart';

import '../../../../theme/app_style.dart';
import '../../../../utilities/colors.dart';
import '../../../../utilities/size_utils.dart';
import '../../../common_widgets/custom_logo.dart';
import '../../../common_widgets/custom_rich_text.dart';

class BottomNavItem extends StatelessWidget {
  final GestureTapCallback? onTap;
  final bool isSelected;
  final String label;
  final String image;

  const BottomNavItem({
    super.key,
    this.onTap,
    required this.label,
    required this.image,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomLogo(
            svgPath: image,
            color: isSelected ? AppColors.tealA400 : AppColors.whiteA700,
            height: getVerticalSize(21),
          ),
          Padding(
            padding: getPadding(top: 6),
            child: CustomRichText(
              text: label,
              style: isSelected
                  ? AppStyle.txtPoppinsRegular10TealA400
                  : AppStyle.txtPoppinsRegular10WhiteA700,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: getPadding(top: 4),
            child: SizedBox(
              width: getHorizontalSize(32),
              child: Divider(
                height: getVerticalSize(1),
                thickness: getVerticalSize(1),
                color: isSelected ? AppColors.tealA400 : AppColors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
