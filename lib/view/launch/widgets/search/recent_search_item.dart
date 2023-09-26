import 'package:flutter/material.dart';
import '../../../../models/graphql/user_info.dart';
import '../../../../utilities/common_design_utils.dart';
import '../../../../core/app_export.dart';
import '../../../../utilities/demo_utils/match_data_utils.dart';
import '../../../common_widgets/custom_rich_text.dart';
import '../../../common_widgets/profile_imageItem.dart';

class RecentSearchItem extends StatelessWidget {
  final UserInfoModel user;

  RecentSearchItem({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getHorizontalSize(68),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileImageItem(
            matchData: getColorCodeFromPersonalityCode(user.my_code ?? '', 38),
            height: 61,
            child: profileImageWidget(),
          ),
          Padding(
            padding: getPadding(top: 5),
            child: CustomRichText(
              text: "${user.firstname}",
              style: AppStyle.txtPoppinsSemiBold13,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
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
      margin: const EdgeInsets.all(0),
      color: AppColors.whiteA700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(getSize(38)),
      ),
      child: Container(
        height: getSize(38),
        width: getSize(38),
        decoration: AppDecoration.fillBlack900
            .copyWith(borderRadius: BorderRadiusStyle.circleBorder52),
        child: user.profilePicUrlPath != null && user.profilePicUrlPath != ""
            ? CustomLogo(
                url: Constants.getProfileUrl(user.profilePicUrlPath ?? ''),
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
