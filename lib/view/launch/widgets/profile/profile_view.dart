import 'package:flutter/material.dart';
import 'package:konverge/blocs/user/user_bloc.dart';

import '../../../../core/configurations.dart';
import '../../../../core/locator.dart';
import '../../../../models/graphql/user_info.dart';
import '../../../../core/app_export.dart';
import '../../../../models/design_models/user.dart';
import '../../../../models/skills/skills.dart';
import '../../../../repository/user_repository.dart';
import '../../../../utilities/enums.dart';
import '../../../search_for_skills/screens/search_for_skills.dart';
import '../../../common_widgets/custom_buttons.dart';
import '../../../view_profile/screens/view_profile_details_screen.dart';
import '../../widgets/profile/profile_basic.dart';
import 'biography_widget.dart';
import 'chip_view_group.dart';

class ProfileView extends StatefulWidget {
  final UserInfoModel? user;
  final String from;
  final VoidCallback? onTapProfile;
  final bool? isFromMatchesScreen;

  ProfileView({
    super.key,
    required this.user,
    this.onTapProfile,
    required this.from,
    this.isFromMatchesScreen = false,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();

  double getBiographyPadding(Biography biography) {
    if (biography.subTitle.toLowerCase() == 'no idea yet') {
      if (biography.biography.toString().isEmpty) {
        return 54;
      }
      return 25;
    } else {
      return 25;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        switch (state.runtimeType) {
          case UserImageSaveState:
            state as UserImageSaveState;
            if (state.status == ProviderStatus.loaded) {
              setState(() {});
            }
        }
      },
      child: Container(
        padding: getMargin(left: 35, top: 10, right: 35),
        width: width.toDouble(),
        color: Colors.transparent,
        child: Container(
          height: getVerticalSize(600),
          decoration: widget.isFromMatchesScreen ?? false
              ? AppDecoration.backgroundForMatchesSwipeView
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder14)
              : AppDecoration.outlineBlueGray70003
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder14),
          child: SingleChildScrollView(
            child: Padding(
              padding: getPadding(top: 29, bottom: 29),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: getPadding(left: 25, right: 25),
                    child: ProfileBasic(user: widget.user!),
                  ),
                  Padding(
                    padding: getPadding(top: 13),
                    child: Divider(
                      height: getVerticalSize(1),
                      thickness: getVerticalSize(1),
                      color: AppColors.blueGray700,
                    ),
                  ),
                  BioGraphyWidget(
                    biography: getBiography(widget.user!),
                  ),
                  Padding(
                    padding: getPadding(
                      top: getBiographyPadding(getBiography(widget.user!)),
                    ),
                    child: Divider(
                      height: getVerticalSize(1),
                      thickness: getVerticalSize(1),
                      color: AppColors.blueGray700,
                    ),
                  ),
                  Padding(
                    padding: getPadding(left: 25, top: 12, right: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Skills",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsMedium13,
                        ),
                        if (widget.user?.userId == activeUser?.userId)
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                SearchForSkillsScreen.routeName,
                              );
                            },
                            child: Padding(
                              padding: getPadding(top: 3, bottom: 3),
                              child: Text(
                                "Add or change my skills",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtPoppinsLight9,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: getPadding(left: 24, top: 20, right: 24),
                      child: Wrap(
                        runSpacing: getVerticalSize(5),
                        spacing: getHorizontalSize(5),
                        children: List<Widget>.generate(
                          widget.user?.personal_skills?.length ?? 0,
                          (index) => ChipViewGroup(
                            skill: Skills(
                              skill:
                                  widget.user?.personal_skills?[index].skill ??
                                      '',
                            ),
                            onTap: () {
                              // setState(() {
                              //   selectedSkillSets.remove(
                              //       selectedSkillSets[
                              //       index]);
                              // });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onVerticalDragUpdate: (dragDetails) async {
                      if (dragDetails.delta.dy < 0) {
                        final status = await Navigator.pushNamed(
                          context,
                          ViewProfileDetailScreen.routeName,
                          arguments: {
                            "user": widget.user,
                            "from": widget.from,
                          },
                        );

                        // await getData();
                        if (widget.onTapProfile != null && status == true) {
                          widget.onTapProfile!();
                        }
                      }
                    },
                    child: CustomButton(
                      onTap: () async {
                        final status = await Navigator.pushNamed(
                          context,
                          ViewProfileDetailScreen.routeName,
                          arguments: {
                            "user": widget.user,
                            "from": widget.from,
                          },
                        );

                        // await getData();
                        if (widget.onTapProfile != null && status == true) {
                          widget.onTapProfile!();
                        }
                      },
                      text: widget.user?.userId == activeUser?.userId
                          ? "My Qualities"
                          : "Qualities",
                      variant: ButtonVariant.fillBlack9007c,
                      fontStyle: ButtonFontStyle.poppinsRegular14WhiteA700,
                      padding: ButtonPadding.paddingAll12,
                      shape: ButtonShape.roundedBorder8,
                      mainAxis: MainAxisAlignment.start,
                      margin: getMargin(left: 24, top: 31, right: 24),
                      suffixWidget: Container(
                        height: getVerticalSize(16),
                        margin: getMargin(right: 1),
                        child: CustomLogo(
                          svgPath: Assets.imgUploadWhiteA700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
