import 'package:flutter/material.dart';

import '../../../../core/locator.dart';
import '../../../../models/graphql/user_info.dart';
import '../../../../repository/user_repository.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/app_style.dart';
import '../../../../utilities/assets.dart';
import '../../../../utilities/colors.dart';
import '../../../../utilities/common_design_utils.dart';
import '../../../../utilities/constants.dart';
import '../../../../utilities/size_utils.dart';
import '../../../../utilities/date_utils.dart';

import '../../../edit_profile/screens/edit_profile_image_screen.dart';
import '../../../common_widgets/custom_logo.dart';
import '../../../common_widgets/profile_imageItem.dart';

class ProfileBasic extends StatefulWidget {
  final UserInfoModel user;

  ProfileBasic({
    super.key,
    required this.user,
  });

  @override
  State<ProfileBasic> createState() => _ProfileBasicState();
}

class _ProfileBasicState extends State<ProfileBasic> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: getSize(115),
          width: getSize(115),
          child: ProfileImageItem(
            matchData: getColorCodeFromPersonalityCode(
              widget.user.my_code ?? '',
              90,
            ),
            height: getSize(115),
            child: widget.user.profilePicUrlPath != null
                ? profileImageWidget()
                : emptyProfileImageWidget(),
          ),
        ),
        Padding(
          padding: getPadding(top: 12),
          child: Text(
            "${widget.user.firstname} ${widget.user.lastname}",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppStyle.txtPoppinsMedium20,
          ),
        ),
        Text(
          widget.user.city ?? '',
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppStyle.txtPoppinsGrayishBlueRegular14,
        ),
        Padding(
          padding: getPadding(top: 3),
          child: Text(
            calculateAge(widget.user.dob ?? "").toString(),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppStyle.txtPoppinsRegular11,
          ),
        ),
      ],
    );
  }
Future<void> updateProfilePic() async {
  var currentUser =
  Locator.instance.get<UserRepo>().getCurrentUserData();
  if (currentUser != null &&
      widget.user.userId == currentUser.userId) {
    final imagePath = await Navigator.pushNamed(
      context,
      EditProfileImageScreen.routeName,
      arguments: {
        "key": widget.user.profilePicUrlPath ?? "",
      },
    );

    if (imagePath != null) {
      setState(() {
        widget.user.profilePicUrlPath = "$imagePath";
      });
    }
  }
}

  Widget emptyProfileImageWidget() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      color: AppColors.black900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(getHorizontalSize(52)),
      ),
      child: InkWell(
        onTap: () async {
          await updateProfilePic();
        },
        child: Container(
          height: getSize(90),
          width: getSize(90),
          padding: getPadding(all: 29),
          decoration: AppDecoration.fillBlack900
              .copyWith(borderRadius: BorderRadiusStyle.circleBorder52),
          child: Stack(
            children: [
               CustomLogo(
                  svgPath: Assets.imgUserTealA400,
                  height: getVerticalSize(39),
                  width: getHorizontalSize(46),
                  alignment: Alignment.topCenter,
                ),

            ],
          ),
        ),
      ),
    );
  }

  Widget profileImageWidget() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      color: AppColors.black900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(getHorizontalSize(52)),
      ),
      child: Container(
        height: getSize(90),
        width: getSize(90),
        // padding:
        // getPadding(all: 29),
        decoration: AppDecoration.fillBlack900
            .copyWith(borderRadius: BorderRadiusStyle.circleBorder52),
        child: Stack(
          children: [
            widget.user.profilePicUrlPath != ''
                ? CustomLogo(
                    url: Constants.getProfileUrl(
                        widget.user.profilePicUrlPath ?? ''),
                    height: getSize(104),
                    width: getSize(104),
                    alignment: Alignment.topCenter,
                    onTap: () async {await updateProfilePic();
                    },
                  )
                : emptyProfileImageWidget(),
          ],
        ),
      ),
    );
  }
}
