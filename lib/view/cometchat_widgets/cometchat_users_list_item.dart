import 'package:flutter/material.dart';

import '../../theme/app_decoration.dart';
import '../../theme/app_style.dart';
import '../../utilities/assets.dart';
import '../../utilities/colors.dart';
import '../../utilities/common_design_utils.dart';

import '../../utilities/demo_utils/match_data_utils.dart';
import '../../utilities/size_utils.dart';
import '../common_widgets/custom_logo.dart';
import '../common_widgets/profile_imageItem.dart';

class CometChatUserListItem extends StatelessWidget {
  final Widget? avatarWidget;
  final Color themeColor;
  final String name;

  CometChatUserListItem(
    this.avatarWidget,
    this.themeColor,
    this.name,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: getMargin(top: 20),
      padding: getPadding(left: 15, top: 12, right: 15, bottom: 12),
      decoration: AppDecoration.outlineBlueGray90001
          .copyWith(borderRadius: BorderRadiusStyle.roundedBorder23),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfileImageItem(
            matchData: getColorCodeFromColors(themeColor, 38),
            height: getVerticalSize(38),
            child: profileImageWidget(),
          ),
          Padding(
            padding: getPadding(left: 19),
            child: SizedBox(
              width: getHorizontalSize(190),
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppStyle.txtPoppinsSemiBold13,
              ),
            ),
          ),
          const Spacer(),
          CustomLogo(
            svgPath: Assets.imgArrowRightTealA400,
            color: AppColors.whiteA700,
            height: getVerticalSize(10),
            width: getHorizontalSize(5),
            margin: getMargin(right: 10),
          ),
        ],
      ),
    );
  }

  Widget profileImageWidget() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: AppColors.black900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          getSize(matchDataBlueSearchProfile.radius),
        ),
      ),
      child: Container(
        height: getSize(matchDataBlueSearchProfile.radius),
        width: getSize(matchDataBlueSearchProfile.radius),
        decoration: AppDecoration.fillBlack900
            .copyWith(borderRadius: BorderRadiusStyle.circleBorder52),
        child: avatarWidget,
      ),
      // ),
    );
  }

  Widget emptyProfileImageWidget() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: AppColors.black900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          getSize(matchDataBlueSearchProfile.radius),
        ),
      ),
      child: Container(
        height: getSize(matchDataBlueSearchProfile.radius),
        width: getSize(matchDataBlueSearchProfile.radius),
        padding: getPadding(all: 10),
        decoration: AppDecoration.fillBlack900
            .copyWith(borderRadius: BorderRadiusStyle.circleBorder52),
        child: CustomLogo(
          svgPath: Assets.imgUserTealA400,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
