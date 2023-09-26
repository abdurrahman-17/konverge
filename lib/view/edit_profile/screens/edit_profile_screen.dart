import 'package:flutter/material.dart';

import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/app_export.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../models/design_models/profile_visible_data.dart';
import '../../../models/graphql/user_info.dart';
import '../../../repository/user_repository.dart';
import '../../../utilities/demo_utils/profile_visible_data.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../authentication/screens/privacy_policy.dart';
import '../../biography/screens/biography_screen.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/loader.dart';
import '../../hours_per_week/screens/hours_per_week_screen.dart';
import '../../motivation/screens/motivation_screen.dart';
import '../../my_qualities_screen/screens/edit_quality_screen.dart';
import '../../passion/screens/passion_screen.dart';
import '../../search_for_interests/screens/search_for_interests.dart';
import '../../search_for_skills/screens/search_for_skills.dart';
import '../../search_for_skills/screens/ideas_screen.dart';
import '../widgets/edit_profile_item_widget.dart';
import 'edit_profile_image_screen.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = "/edit_profile";

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = false;
  UserInfoModel? user;
  List<ProfileVisibleData> profileVisibleList = [];

  @override
  void initState() {
    super.initState();
    profileVisibleList = profileVisible;
    readUser();
  }

  Future<void> readUser() async {
    final currentUser = Locator.instance.get<UserRepo>().getCurrentUserData();
    setState(() {
      if (currentUser != null) {
        user = currentUser;
        if (user?.profileVisibility != null) {
          profileVisibleList = [
            ProfileVisibleData(
              name: Constants.editProfileBiography,
              visibility: user?.profileVisibility?.biography ?? false,
            ),
            ProfileVisibleData(
              name: Constants.editProfileSkills,
              visibility: user?.profileVisibility?.skills ?? false,
              toggleShow: false,
            ),
            ProfileVisibleData(
              name: Constants.editProfileQualities,
              visibility: user?.profileVisibility?.qualities ?? false,
              toggleShow: false,
            ),
            ProfileVisibleData(
              name: Constants.editProfileSkillsLookingFor,
              visibility: user?.profileVisibility?.looking_for_skills ?? false,
            ),
            ProfileVisibleData(
              name: Constants.editProfileBusinessIdea,
              visibility: user?.profileVisibility?.business_idea ?? false,
              toggleShow: false,
            ),
            ProfileVisibleData(
              name: Constants.editProfileMotivation,
              visibility: user?.profileVisibility?.motivation ?? false,
            ),
            ProfileVisibleData(
              name: Constants.editProfilePassion,
              visibility: user?.profileVisibility?.level_of_passion ?? false,
            ),
            ProfileVisibleData(
              name: Constants.editProfileInterests,
              visibility: user?.profileVisibility?.interests ?? false,
            ),
            ProfileVisibleData(
              name: Constants.editProfileHoursPerWeek,
              visibility: user?.profileVisibility?.hours_per_week ?? false,
            ),
          ];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonBackground,
        CommonBgLogo(
          opacity: 0.6,
          position: CommonBgLogoPosition.bottomRight,
        ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              contents(context),
              if (isLoading) Loader(),
            ],
          ),
          appBar: CommonAppBar.appBar(context: context),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget contents(BuildContext context) {
    return BlocListener<GraphqlBloc, GraphqlState>(
      listener: (BuildContext context, state) {
        setState(() {
          isLoading = false;
        });
        switch (state.runtimeType) {
          case QueryLoadingState:
            setState(() {
              isLoading = true;
            });
            break;
          case QueryUpdateSuccessState:
            break;
          case SaveProfileVisibilityListSuccessState:
            user?.profileVisibility =
                (state as SaveProfileVisibilityListSuccessState)
                    .profileVisibility;
            Locator.instance.get<UserRepo>().setCurrentUserData(user!);
            Navigator.pop(context);
            break;
          case GraphqlErrorState:
            print("Graphql error state: $state");
            break;
          default:
            print("Graphql Unknown state while edit profile: $state");
        }
      },
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: getPadding(left: 35, right: 35, bottom: 46),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomRichText(
                        text: "Edit profile",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtPoppinsSemiBold20,
                      ),
                      Container(
                        margin: getMargin(top: 8),
                        child: CustomRichText(
                          text:
                              "Make changes and toggle the visibility of profile details. We recommend adding as many as possible for the best results.",
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsLight13,
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 19),
                        child: Divider(
                          height: getVerticalSize(1),
                          thickness: getVerticalSize(1),
                          color: AppColors.gray50033,
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        padding: getPadding(top: 10),
                        child: CustomRichText(
                          text: "Make visible",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: AppStyle.txtPoppinsLight10,
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 14, right: 2),
                        child: EditProfileItemWidget(
                          data: ProfileVisibleData(
                            name: Constants.editProfilePicture,
                            visibility: true,
                            toggleShow: false,
                          ),
                          onTapRowEdit: () async {
                            final imagePath = await Navigator.pushNamed(
                              context,
                              EditProfileImageScreen.routeName,
                              arguments: {
                                "key": user?.profilePicUrlPath ?? "",
                              },
                            );
                            if (imagePath != null) {
                              setState(() {
                                user?.profilePicUrlPath = "$imagePath";
                              });
                            }
                          },
                          onToggle: null,
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 14, right: 2),
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: getVerticalSize(18),
                            );
                          },
                          itemCount: profileVisibleList.length,
                          itemBuilder: (context, index) {
                            ProfileVisibleData data = profileVisibleList[index];
                            return EditProfileItemWidget(
                              data: data,
                              onTapRowEdit: () {
                                switch (data.name) {
                                  case Constants.editProfileBiography:
                                    Navigator.pushNamed(
                                      context,
                                      BiographyScreen.routeName,
                                    );
                                    break;
                                  case Constants.editProfileMotivation:
                                    Navigator.pushNamed(
                                      context,
                                      MotivationScreen.routeName,
                                    );
                                    break;
                                  case Constants.editProfileBusinessIdea:
                                    {
                                      Navigator.pushNamed(
                                        context,
                                        IdeasScreen.routeName,
                                      );
                                      break;
                                    }
                                  case Constants.editProfilePassion:
                                    Navigator.pushNamed(
                                      context,
                                      PassionScreen.routeName,
                                    );
                                    break;
                                  case Constants.editProfileInterests:
                                    Navigator.pushNamed(
                                      context,
                                      SearchForInterest.routeName,
                                    );
                                    break;
                                  case Constants.editProfileQualities:
                                    Navigator.pushNamed(
                                      context,
                                      EditQualityScreen.routeName,
                                    );
                                    break;
                                  case Constants.editProfileHoursPerWeek:
                                    Navigator.pushNamed(
                                      context,
                                      HoursPerWeekScreen.routeName,
                                    );
                                    break;
                                  case Constants.editProfileSkills:
                                    Navigator.pushNamed(
                                      context,
                                      SearchForSkillsScreen.routeName,
                                    );
                                    break;
                                  case Constants.editProfileSkillsLookingFor:
                                    Navigator.pushNamed(
                                      context,
                                      SearchForSkillsScreen.routeName,
                                      arguments: {
                                        'isSecondTime': true,
                                      },
                                    );
                                    break;
                                  default:
                                    Navigator.pushNamed(
                                      context,
                                      BiographyScreen.routeName,
                                    );
                                    break;
                                }
                              },
                              onToggle: data.toggleShow
                                  ? (value) {
                                      data.visibility = value;
                                    }
                                  : null,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 116),
                        child: Divider(
                          height: getVerticalSize(1),
                          thickness: getVerticalSize(1),
                          color: AppColors.gray50033,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PrivacyPolicyScreen.routeName,
                          );
                        },
                        child: Padding(
                          padding: getPadding(top: 24),
                          child: CustomRichText(
                            text: "Privacy Policy",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtPoppinsRegular13,
                          ),
                        ),
                      ),
                      CustomButton(
                        // height: getVerticalSize(47),
                        text: TitleString.btnSave,
                        enabled: true,
                        margin: getMargin(top: 29, bottom: 23),
                        onTap: () {
                          ProfileVisibility request = ProfileVisibility(
                            biography: profileVisibleList[0].visibility,
                            // skills: profileVisibleList[1].visibility,
                            skills: true,
                            // qualities: profileVisibleList[2].visibility,
                            qualities: true,
                            looking_for_skills:
                                profileVisibleList[3].visibility,
                            // business_idea: profileVisibleList[4].visibility,
                            business_idea: true,
                            motivation: profileVisibleList[5].visibility,
                            level_of_passion: profileVisibleList[6].visibility,
                            hours_per_week: profileVisibleList[8].visibility,
                            interests: profileVisibleList[7].visibility,
                          );
                          BlocProvider.of<GraphqlBloc>(context).add(
                            UpdateProfileVisibilityListEvent(
                              profileVisibility: request,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
