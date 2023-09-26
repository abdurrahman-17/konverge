import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../core/app_export.dart';
import '../../../core/locator.dart';
import '../../../models/graphql/user_info.dart';
import '../../../repository/user_repository.dart';
import '../../../services/shared_preference_service.dart';
import '../../../services/amplify/amplify_service.dart';
import '../../../utilities/common_design_utils.dart';
import '../../../utilities/enums.dart';
import '../../account_details/screens/account_details_screen.dart';
import '../../authentication/screens/logout_confirmation.dart';
import '../../authentication/screens/get_started_screen.dart';
import '../../change_password/screens/change_password_screen.dart';
import '../../common_widgets/custom_icon_button.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/profile_imageItem.dart';
import '../../common_widgets/snack_bar.dart';
import '../../edit_profile/screens/edit_profile_image_screen.dart';
import '../../edit_profile/screens/edit_profile_screen.dart';
import '../../legal/screens/legal_screen.dart';
import '../../privacy/screens/privacy_screen.dart';
import '../../support/screens/support_screen.dart';
import 'widgets/side_menu_item.dart';
import 'confirm_deletion_screen.dart';

class SideMenu extends StatefulWidget {
  final UserInfoModel? user;

  const SideMenu({
    super.key,
    required this.user,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  var activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();
  final LoginType loginType =
      Locator.instance.get<SharedPrefServices>().getLoginType();

  double? getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  @override
  void initState() {
    // fetchData();
    super.initState();
  }

  AmplifyService amplifyService = AmplifyService();

  Future<void> fetchData() async {
    if (mounted) {
      setState(() {
        activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();
      });
    }
  }

  void setLoading(bool value) {
    value ? progressDialogue() : Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (activeUser == null) {
      return const SizedBox();
    }
    return Scaffold(
      backgroundColor: AppColors.black9007c.withOpacity(0.68),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is SignOutState) {
            if (state.signOutStatus == ApiStatus.success) {
              setLoading(false);
              Navigator.pushNamedAndRemoveUntil(
                context,
                GetStartedScreen.routeName,
                (Route<dynamic> route) => false,
              );
            } else if (state.signOutStatus == ApiStatus.error) {
              setLoading(false);
              showSnackBar(message: "Logout failed");
            } else {
              setLoading(true);
            }
          }
        },
        builder: (context, state) {
          if (state is LoginInitialState) {
            activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();
            //print("listener state user");
          }
          return SingleChildScrollView(
            child: Container(
              height: getDeviceHeight(context),
              padding: getPadding(left: 60, top: 110, bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              final imagePath = await Navigator.pushNamed(
                                context,
                                EditProfileImageScreen.routeName,
                                arguments: {
                                  "key": activeUser?.profilePicUrlPath ?? "",
                                },
                              );

                              if (imagePath != null) {
                                setState(() {
                                  activeUser?.profilePicUrlPath = "$imagePath";
                                });
                              }
                            },
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                ProfileImageItem(
                                  matchData: getColorCodeFromPersonalityCode(
                                    activeUser?.my_code ?? 'Unknown',
                                    67,
                                  ),
                                  height: getSize(90),
                                  child: activeUser?.profilePicUrlPath != null
                                      ? profileImageWidget()
                                      : emptyProfileImageWidget(),
                                ),
                                if (widget.user?.image == null &&
                                    widget.user?.userId == activeUser?.userId)
                                  CustomIconButton(
                                    height: getSize(19),
                                    width: getSize(19),
                                    padding: IconButtonPadding.paddingV5H4,
                                    variant: IconButtonVariant.fillTeal300,
                                    shape: IconButtonShape.roundedBorder14,
                                    alignment: Alignment.bottomCenter,
                                    child: CustomLogo(
                                      svgPath: Assets.imgCamera,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: getHorizontalSize(138),
                        margin: getMargin(top: 5),
                        child: Text(
                          "Hello,  ",
                          style: TextStyle(
                            color: AppColors.blue600,
                            fontSize: getFontSize(15),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        width: getHorizontalSize(138),
                        margin: getMargin(top: 5),
                        child: Text(
                          "${activeUser?.firstname}",
                          style: TextStyle(
                            color: AppColors.whiteA700,
                            fontSize: getFontSize(16),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 22),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Divider(
                            height: getVerticalSize(1),
                            thickness: getVerticalSize(1),
                            color: AppColors.blueGray600,
                          ),
                        ),
                      ),
                      SideMenuItem(
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            EditProfileScreen.routeName,
                          );
                          fetchData();
                        },
                        padding: getPadding(top: 37),
                        label: "Edit Profile",
                      ),
                      SideMenuItem(
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            AccountDetailScreen.routeName,
                          );
                          fetchData();
                        },
                        padding: getPadding(top: 22),
                        label: "Account Details",
                      ),
                      SideMenuItem(
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            PrivacyScreen.routeName,
                          );
                          setState(() {});
                        },
                        padding: getPadding(top: 22),
                        label: "Privacy",
                      ),
                      SideMenuItem(
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            LegalScreen.routeName,
                          );
                        },
                        padding: getPadding(top: 22),
                        label: "Legal",
                      ),
                      SideMenuItem(
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            SupportScreen.routeName,
                          );
                        },
                        padding: getPadding(top: 22),
                        label: "Support",
                      ),
                      if (loginType == LoginType.usernameAndPassword)
                        SideMenuItem(
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              ChangePasswordScreen.routeName,
                            );
                            fetchData();
                          },
                          padding: getPadding(top: 22),
                          label: "Change Password",
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      SideMenuItem(
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            LogoutConfirmationScreen.routeName,
                          );
                          fetchData();
                        },
                        padding: getPadding(top: 5, bottom: 5),
                        label: "Log out",
                      ),
                      const SizedBox(height: 10),
                      SideMenuItem(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ConfirmDeletionScreen.routeName,
                          );
                          // showDialog<void>(
                          //   context: context,
                          //   builder: (_) => ConfirmDeletionScreen(),
                          // );
                        },
                        padding: getPadding(top: 5, bottom: 5),
                        label: "Delete Account",
                        style: AppStyle.txtPoppinsRegular14Red700,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget emptyProfileImageWidget() {
    return SizedBox(
      height: getSize(67),
      width: getSize(67),
      child: Card(
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
          decoration: AppDecoration.fillBlack900
              .copyWith(borderRadius: BorderRadiusStyle.circleBorder52),
          child: CustomLogo(
            svgPath: Assets.imgUserTealA400,
            height: getVerticalSize(22),
            width: getHorizontalSize(22),
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }

  Widget profileImageWidget() {
    return SizedBox(
      height: getSize(67),
      width: getSize(67),
      child: Card(
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
          decoration: AppDecoration.fillBlack900
              .copyWith(borderRadius: BorderRadiusStyle.circleBorder52),
          child: Stack(
            children: [
              activeUser?.profilePicUrlPath != null &&
                      activeUser?.profilePicUrlPath != ''
                  ? CustomLogo(
                      url: Constants.getProfileUrl(
                        activeUser?.profilePicUrlPath ?? '',
                      ),
                      height: getSize(104),
                      width: getSize(104),
                      alignment: Alignment.topCenter,
                    )
                  : emptyProfileImageWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
