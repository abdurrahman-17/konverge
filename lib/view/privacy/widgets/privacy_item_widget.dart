import 'package:flutter/material.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../models/blocked_user_model.dart';
import '../../../utilities/common_design_utils.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../core/app_export.dart';

import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../repository/user_repository.dart';
import '../../../utilities/enums.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/profile_imageItem.dart';

// ignore: must_be_immutable
class PrivacyItemWidget extends StatelessWidget {
  BlockedUserModel? user;

  PrivacyItemWidget({super.key, required this.user});

  final activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getPadding(
        left: 15,
        right: 15,
        top: 12,
        bottom: 12,
      ),
      decoration: AppDecoration.outlineBlueGray90001.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder23,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfileImageItem(
            matchData: getColorCodeFromPersonalityCode(
                user!.userDetails!.myCode ?? "", 38),
            height: 47,
            child: profileImageWidget(),
          ),
          Container(
            padding: getPadding(left: 19),
            width: getHorizontalSize(144),
            child: Text(
              "${user?.userDetails?.fullName}",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtPoppinsSemiBold13,
            ),
          ),
          const Spacer(),
          CustomButton(
            width: getHorizontalSize(56),
            text: "Unblock",
            onTap: () {
              BlocProvider.of<GraphqlBloc>(context).add(
                UnblockUserEvent(
                  interestedId: user?.userDetails?.iId?.oid ?? '',
                  userId: activeUser?.userId ?? '',
                ),
              );
              BlocProvider.of<GraphqlBloc>(context).add(
                UnblockUserEvent(
                  interestedId: user?.iId?.oid ?? '',
                  userId: activeUser?.userId ?? '',
                ),
              );
            },
            margin: getMargin(left: 10),
            variant: ButtonVariant.outlineTealA400_1,
            shape: ButtonShape.roundedBorder26,
            padding: ButtonPadding.paddingAll6,
            fontStyle: ButtonFontStyle.poppinsRegular9,
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
        borderRadius: BorderRadius.circular(getSize(23.3)),
      ),
      child: Container(
        height: getSize(38),
        width: getSize(38),
        decoration: AppDecoration.fillBlack900
            .copyWith(borderRadius: BorderRadiusStyle.circleBorder52),
        child: user?.userDetails?.profilePic != null
            ? CustomLogo(
                url: Constants.getProfileUrl(
                  user?.userDetails?.profilePic ?? '',
                ),
                height: getSize(104),
                width: getSize(104),
                alignment: Alignment.topCenter,
              )
            : Container(
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
