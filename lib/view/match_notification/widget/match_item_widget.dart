import 'package:flutter/material.dart';

import '../../../models/notification/notification_model.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/app_style.dart';
import '../../../../utilities/assets.dart';
import '../../../../utilities/colors.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/common_design_utils.dart';
import '../../../utilities/date_utils.dart';
import '../../../utilities/demo_utils/match_data_utils.dart';
import '../../../../utilities/size_utils.dart';
import '../../common_widgets/custom_logo.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/profile_imageItem.dart';

class MatchItemWidget extends StatelessWidget {
  final NotificationModel notification;

  MatchItemWidget({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: getMargin(top: 10),
          padding: getPadding(left: 13, top: 12, right: 13, bottom: 12),
          decoration: AppDecoration.outlineBlueGray90001
              .copyWith(borderRadius: BorderRadiusStyle.roundedBorder23),
          child: Row(
            children: [
              ProfileImageItem(
                matchData: getColorCodeFromPersonalityCode(
                  notification.myCode.toString(),
                  38,
                ),
                height: 47,
                child: profileImageWidget(),
              ),
              Padding(
                padding: getPadding(left: 10, top: 12, bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomRichText(
                      text: (notification.fullName?.length ?? 0) > 20
                          ? (notification.fullName ?? '').substring(0, 20) +
                              '...'
                          : notification.fullName ?? '',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsSemiBold13,
                    ),
                    Padding(
                      padding: getPadding(top: 4),
                      child: CustomRichText(
                        text: notification.message ?? '',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtPoppinsLightItalic10,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CustomLogo(
                svgPath: Assets.imgArrowRightTealA400,
                color: AppColors.whiteA700,
                height: getVerticalSize(10),
                width: getHorizontalSize(5),
                margin: getMargin(top: 18, right: 10, bottom: 18),
              ),
            ],
          ),
        ),
        Padding(
          padding: getPadding(left: 4, top: 4),
          child: CustomRichText(
            text: getExpireTime(notification.createdAt!).toLowerCase(),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsLightItalic10,
          ),
        ),
      ],
    );
  }

  Widget profileImageWidget() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      color: AppColors.whiteA700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          getSize(matchDataBlueSearchProfile.radius),
        ),
      ),
      child: Container(
        height: getSize(matchDataBlueSearchProfile.radius),
        width: getSize(matchDataBlueSearchProfile.radius),
        decoration: AppDecoration.fillBlack9004c
            .copyWith(borderRadius: BorderRadiusStyle.circleBorder52),
        child: notification.profilePic != null &&
                notification.profilePic != "" &&
                notification.profilePic != "${Constants.s3BaseUrl}/public/" &&
                notification.profilePic != "${Constants.s3BaseUrl}/"
            ? CustomLogo(
                url: Constants.getProfileUrl(notification.profilePic ?? ''),
                height: getSize(104),
                width: getSize(104),
                alignment: Alignment.topCenter,
              )
            : Container(
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
      ),
    );
  }
}
