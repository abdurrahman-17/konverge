import 'package:flutter/material.dart';
import '../../../../models/graphql/user_info.dart';
import '../../../../utilities/transition_constant.dart';
import '../../../../utilities/common_design_utils.dart';
import '../../../../utilities/constants.dart';
import '../../../../utilities/demo_utils/match_data_utils.dart';
import '../../../common_widgets/profile_imageItem.dart';

import '../../../../theme/app_decoration.dart';
import '../../../../theme/app_style.dart';
import '../../../../utilities/assets.dart';
import '../../../../utilities/colors.dart';
import '../../../../utilities/size_utils.dart';
import '../../../common_widgets/custom_logo.dart';

class SearchItem extends StatefulWidget {
  final UserInfoModel user;
  final int userIndex;

  const SearchItem({
    super.key,
    required this.user,
    required this.userIndex,
  });

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  bool startAnimation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: getMargin(top: 10),
      padding: getPadding(left: 15, top: 12, right: 15, bottom: 12),
      decoration: AppDecoration.outlineBlueGray90001
          .copyWith(borderRadius: BorderRadiusStyle.roundedBorder23),
      duration: Duration(
          milliseconds: TransitionConstant.searchItemTransitionDuration +
              (widget.userIndex * 30)),
      curve: Curves.easeIn,
      transform: Matrix4.translationValues(
          startAnimation ? 0 : MediaQuery.of(context).size.width, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfileImageItem(
            matchData:
                getColorCodeFromPersonalityCode(widget.user.my_code!, 38),
            height: 38,
            child: widget.user.profilePicUrlPath != null &&
                    widget.user.profilePicUrlPath != ''
                ? profileImageWidget()
                : emptyProfileImageWidget(),
          ),
          Padding(
            padding: getPadding(left: 19),
            child: SizedBox(
              width: getHorizontalSize(190),
              child: Text(
                "${widget.user.fullname}",
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
        child: widget.user.profilePicUrlPath != null &&
                widget.user.profilePicUrlPath != ""
            ? CustomLogo(
                url: Constants.getProfileUrl(
                    widget.user.profilePicUrlPath ?? ''),
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
