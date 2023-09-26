import 'package:flutter/material.dart';

import '../../theme/app_decoration.dart';
import '../../theme/app_style.dart';
import '../../utilities/assets.dart';
import '../../utilities/colors.dart';
import '../../utilities/common_design_utils.dart';

import '../../utilities/demo_utils/match_data_utils.dart';
import '../../utilities/size_utils.dart';
import '../common_widgets/custom_logo.dart';
import '../common_widgets/custom_rich_text.dart';
import '../common_widgets/profile_imageItem.dart';

class CometChatConversationListItem extends StatelessWidget {
  final Widget? avatarWidget;
  final Color themeColor;
  final String name;
  final Widget? recentChat;
  final Widget? countWidget;
  final String? personalityCode;
  final Widget? dateWidget;

  CometChatConversationListItem(
    this.avatarWidget,
    this.themeColor,
    this.name,
    this.countWidget,
    this.recentChat,
    this.personalityCode,
    this.dateWidget,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: getMargin(top: 20),
      padding: getPadding(left: 15, top: 12, right: 15, bottom: 12),
      decoration: AppDecoration.outlineBlueGray90001
          .copyWith(borderRadius: BorderRadiusStyle.roundedBorder23),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ProfileImageItem(
                matchData: getColorCodeFromColors(themeColor, 38),
                height: getVerticalSize(38),
                child: profileImageWidget(),
              ),
              Padding(
                padding: getPadding(left: 20, top: 10),
                child: SizedBox(
                  width: getHorizontalSize(205),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomRichText(
                            text: name.length > 15
                                ? name.substring(0, 15) + '...'
                                : name,
                            style: AppStyle.txtPoppinsSemiBold16,
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: getPadding(left: 10),
                            child: dateWidget,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: getPadding(top: 0),
                            child: recentChat,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: getPadding(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: getPadding(
                      top: 0,
                      right: getHorizontalSize(10),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      child: countWidget ?? SizedBox(),
                    ),
                  ),
                  CustomLogo(
                    svgPath: Assets.imgArrowRightTealA400,
                    color: AppColors.whiteA700,
                    height: getVerticalSize(10),
                    width: getHorizontalSize(5),
                    margin: getMargin(right: 0, bottom: 0.0),
                  ),
                ],
              ),
            ),
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
    );
  }
}
