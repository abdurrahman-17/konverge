import 'package:flutter/material.dart';
import '../../../core/locator.dart';
import '../../../models/graphql/user_info.dart';
import '../../../repository/user_repository.dart';
import '../../../utilities/title_string.dart';
import '../../biography/screens/biography_screen.dart';

import '../../../../core/app_export.dart';
import '../../../../models/design_models/user.dart';
import '../../common_widgets/custom_rich_text.dart';

class BioGraphyDetailWidget extends StatelessWidget {
  final Biography? biography;
  final BuildContext context;
  final UserInfoModel? user;
  final GestureTapCallback? onTap;

  BioGraphyDetailWidget({
    super.key,
    this.biography,
    required this.user,
    required this.context,
    this.onTap,
  });

  final activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();

  @override
  Widget build(BuildContext context) {
    return (biography != null &&
            biography?.biography != null &&
            biography?.biography.trim() != '')
        ? biographyWidget(biography!)
        : emptyBiographyWidget();
  }

  Widget emptyBiographyWidget() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            TitleString.biography,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsMedium14w400,
          ),
        ),
        if (user == activeUser)
          Align(
            child: InkWell(
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  BiographyScreen.routeName,
                );
                if (onTap != null) {
                  onTap!();
                }
              },
              child: Padding(
                padding: getPadding(top: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Complete your profile",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsLight10,
                    ),
                    CustomLogo(
                      svgPath: Assets.imgEditWhiteA700,
                      height: getVerticalSize(9),
                      width: getHorizontalSize(10),
                      margin: getMargin(left: 15),
                    )
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget biographyWidget(Biography biography) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CustomRichText(
            text: TitleString.biography,
            style: TextStyle(
              color: AppColors.whiteA700,
              fontSize: getFontSize(13),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          width: getHorizontalSize(293),
          margin: getMargin(top: 10, right: 10),
          child: Text(
            biography.biography,
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsLight10,
          ),
        ),
      ],
    );
  }
}
