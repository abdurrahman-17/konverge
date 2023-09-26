import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:konverge/utilities/title_string.dart';

import '../../../blocs/user_detail/user_detail_bloc.dart';
import '../../../core/app_export.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../models/graphql/interests.dart';
import '../../../main.dart';
import '../../../models/design_models/user.dart';
import '../../../models/graphql/user_info.dart';
import '../../../models/skills/skills.dart';
import '../../../repository/user_repository.dart';
import '../../../utilities/common_design_utils.dart';
import '../../../utilities/common_functions.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/transition_constant.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_message_dialogue.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/match_widget.dart';
import '../../hours_per_week/screens/hours_per_week_screen.dart';
import '../../its_match/screens/its_match_screen.dart';
import '../../launch/widgets/bottom_nav_screen.dart';
import '../../motivation/screens/motivation_screen.dart';
import '../../passion/screens/passion_screen.dart';
import '../../results/widgets/result_item_widget.dart';
import '../widgets/biography__detail_widget.dart';
import '../widgets/progress_bar_widget.dart';
import '../widgets/pie_chart.dart';
import '../widgets/skill_view.dart';
import '../widgets/view_profile_dialogue.dart';
import 'view_profile_screen.dart';

class ViewProfileDetailScreen extends StatefulWidget {
  static const String routeName = "/view_profile_details";
  final UserInfoModel? userData;
  final String from;

  ViewProfileDetailScreen({
    required this.userData,
    this.from = "",
    super.key,
  });

  @override
  State<ViewProfileDetailScreen> createState() =>
      _ViewProfileDetailScreenState();
}

class _ViewProfileDetailScreenState extends State<ViewProfileDetailScreen>
    with TickerProviderStateMixin {
  UserInfoModel? user;
  final activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();
  AnimationController? _controller;
  Animation<double>? animation;

  @override
  void dispose() {
    log('message dispose');
    _controller!.dispose();
    // ModalRoute.of(context)?.removeRouteObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    user = widget.userData;
    _controller = AnimationController(
      duration: const Duration(
          milliseconds:
              TransitionConstant.viewProfileAlertDialogTransitionDuration),
      vsync: this,
    );
    if (mounted) {
      initUser();
    }
  }

  void fetchUserDetail() {
    if (widget.userData!.cognitoId!.isNotEmpty && widget.from == "match") {
      BlocProvider.of<UserDetailBloc>(context).add(
        FetchUserDetailEvent(
            cognitoId: widget.userData!.cognitoId!,
            userId: activeUser!.userId!,
            searchId: widget.userData!.userId!),
      );
    }
  }

  Future<void> initUser() async {
    // var user1 = await Locator.instance
    //     .get<SharedPrefServices>()
    //     .getUserInfoFromSharedPreferences();
    // setState(() {
    //   user = user1;ƒ
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const SizedBox();
    }
    // log("visibility ${user!.profileVisibility!.toJson()}");
    return Stack(
      children: [
        Container(
          decoration: AppDecoration.fillBlackGrad9007c,
          width: double.infinity,
          height: double.infinity,
        ),
        WillPopScope(
          onWillPop: () async {
            // Code to execute when navigating back to the page
            log('message WillPopScope');
            return true; // Return true to allow the back navigation
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: blocData(context),
            appBar: CommonAppBar.appBar(
              context: context,
              text: "View Profile",
              actions: [
                activeUser?.userId != user?.userId
                    ? InkWell(
                        onTap: () async {
                          await _controller!.reverse();
                          setState(() {
                            animation = Tween<double>(
                                    begin:
                                        MediaQuery.of(context).size.width * 0.1,
                                    end: 0.0)
                                .animate(_controller!)
                              ..addListener(() {
                                setState(() {});
                              });
                            _controller!.forward();
                          });
                          // ignore: inference_failure_on_function_invocation
                          showDialog(
                            context: context,
                            builder: (_) => AnimatedBuilder(
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(animation!.value, 0.0),
                                  child: AlertDialog(
                                    content: ViewProfileDialog(
                                      user: user,
                                      matchType: widget.from == "search"
                                          ? Constants.matchTypeManual
                                          : Constants.matchTypeAlgorithm,
                                      from: "detail",
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                );
                              },
                              animation: animation!,
                            ),
                          );
                        },
                        child: Container(
                          margin: getMargin(left: 35, right: 35),
                          child: Icon(
                            Icons.more_vert,
                            color: AppColors.whiteA700,
                            size: getSize(18),
                          ),
                        ),
                      )
                    : CustomLogo(
                        height: getSize(18),
                        width: getSize(18),
                        svgPath: Assets.imgSearchWhiteA700,
                        margin: getMargin(left: 35, right: 35),
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                      ),
              ],
            ),
            backgroundColor: Colors.transparent,
            bottomNavigationBar: widget.from.isNotEmpty
                ? BottomNavScreen(
                    selectedIndex: widget.from == "match"
                        ? 1
                        : widget.from == "search"
                            ? 2
                            : widget.from == "profile"
                                ? 3
                                : 0,
                    onTapHome: () => bottomNavFunction(context, 0),
                    onTapMatch: () => bottomNavFunction(context, 1),
                    onTapSearch: () => bottomNavFunction(context, 2),
                    onTapProfile: () => bottomNavFunction(context, 3),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  bool loading = false;

  Widget blocData(BuildContext context) {
    return BlocConsumer<UserDetailBloc, UserDetailState>(
      listener: (BuildContext context, state) {
        loading = false;
        if (user?.statusData == null) {
          user?.statusData = StatusData();
        }

        if (state is UserMatchedSuccessState) {
          if (state.status == ProviderStatus.loading) {
            loading = true;
          }
          if (state.itsMatch) {
            user?.statusData?.matchStatus = "Matched";
            Navigator.pushNamed(
              context,
              ItsMatchScreen.routeName,
              arguments: {'user': state.user},
            );
          } else if (state.isMatch) {
            viewDialogue("${state.error}");
            user?.statusData?.matchStatus = state.error;
          } else if (state.isMatch == false) {
            dialogueBoxMatch(context, TitleString.un_matched_with_this_user);
          }
        } else if (state is UserBlockedSuccessState) {
          log("state ${state.error} ${state.status}");
          if (state.status == ProviderStatus.loaded ||
              state.status == ProviderStatus.error) {
            viewDialogue(state.error.isEmpty
                ? "You have blocked this user"
                : state.error);
            user?.statusData?.blockStatus = true;
          }
          if (state.status == ProviderStatus.loading) {
            loading = true;
          }
        } else if (state is UserUnBlockedSuccessState) {
          if (state.status == ProviderStatus.loaded) {
            dialogueBoxMatch(context, "You have unblocked this user");
            user?.statusData?.blockStatus = false;
          }
          if (state.status == ProviderStatus.loading) {
            loading = true;
          }
        } else if (state is FetchUserDetailState) {
          setState(() {
            user = state.user;
          });
        }
        // if(state is UserInitialState)
        // {
        //   print("current state $state");
        //   // if (user?.userId == activeUser?.userId) {
        //   //   user = Locator.instance.get<UserRepo>().getCurrentUserData();
        //   // }
        //   setState(() {
        //
        //   });
        // }
      },
      builder: (context, state) {
        if (state is UserDetailInitialState) {
          print("current state $state");
          print(
              "current state ${user!.cognitoId!} active state ${activeUser!.cognitoId!}");
          if (user?.cognitoId == activeUser?.cognitoId) {
            user = Locator.instance.get<UserRepo>().getCurrentUserData();
          }
        }
        return Stack(
          children: [
            contents(context),
            if (loading)
              const Align(
                child: Loader(),
              )
          ],
        );
      },
    );
  }

  void viewDialogue(String message) {
    showGeneralDialog(
      context: context,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        Future.delayed(const Duration(milliseconds: 800), () {
          // Navigator.of(dialogueContext, rootNavigator: true).pop();
          Navigator.of(globalNavigatorKey.currentContext!).pop(true);
        });
        return CommonMessageDialogue(
          message: message,
        );
      },
    );
  }

  Widget contents(BuildContext context) {
    return Container(
      width: size.width,
      decoration: AppDecoration.fillBlack9007c
          .copyWith(borderRadius: BorderRadiusStyle.customBorderTL35),
      height: size.height,
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: getPadding(left: 35, top: 35, right: 35),
                  child: GestureDetector(
                    onVerticalDragUpdate: (dragDetails) {
                      if (dragDetails.delta.dy > 0) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomRichText(
                            text: user?.userId == activeUser?.userId
                                ? "My Qualities"
                                : "Qualities",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtPoppinsMedium14,
                          ),
                          CustomLogo(
                            svgPath: Assets.imgArrowDown,
                            height: getSize(16),
                            width: getSize(16),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: getPadding(left: 35, top: 20, right: 35, bottom: 29),
                child: ListView.separated(
                  itemCount: getQualityLength(),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ResultItemWidget(
                      skill: Skills(
                        skill: user?.qualities?[index] ?? '',
                      ),
                      index: index + 1,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: getVerticalSize(7));
                  },
                ),
              ),
              if (user != null && user?.profileVisibility != null)
                Visibility(
                  visible: user?.userId == activeUser?.userId ||
                      (user!.profileVisibility!.biography &&
                              user?.biography != null
                          ? user!.biography.isNotEmpty
                          : false),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: getPadding(left: 35, right: 35, bottom: 30),
                      child: user!.biography.isNotEmpty &&
                              user?.business_idea == Constants.ideaScreenOption1
                          ? biographyWidget()
                          : BioGraphyDetailWidget(
                              biography: getBiography(user!),
                              context: context,
                              user: user,
                              onTap: () {
                                setState(() {});
                              },
                            ),
                    ),
                  ),
                ),
              if (user?.profileVisibility != null)
                Visibility(
                  visible: user?.userId == activeUser?.userId ||
                      (user!.profileVisibility!.looking_for_skills &&
                          user!.looking_for_skills!.isNotEmpty),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: getPadding(left: 35, right: 35),
                      child: SkillView(
                        title: (user?.userId == activeUser?.userId)
                            ? "Skills I'm looking for"
                            : "Skills looking for",
                        skills: user?.looking_for_skills ?? [],
                        tap: () {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
              if (user?.profileVisibility != null)
                Visibility(
                  visible: (user?.userId == activeUser?.userId) ||
                      user!.profileVisibility!.looking_for_skills,
                  child: Padding(
                    padding: getPadding(top: 31),
                    child: Divider(
                      height: getVerticalSize(1),
                      thickness: getVerticalSize(1),
                      color: AppColors.blueGray700,
                      indent: getHorizontalSize(35),
                      endIndent: getHorizontalSize(35),
                    ),
                  ),
                ),
              if (user?.profileVisibility != null)
                Visibility(
                  visible: getProfileVisibility("motivation"),
                  child: Padding(
                    padding: getPadding(left: 36, top: 25, right: 34),
                    child: InkWell(
                      onTap: () async {
                        if (user?.userId == activeUser?.userId) {
                          await Navigator.pushNamed(
                            context,
                            MotivationScreen.routeName,
                          );
                          setState(() {});
                        }
                      },
                      child: PieChart(
                        total: 100,
                        isCurrentUser: user?.userId == activeUser?.userId,
                        title: "Motivation",
                        subTitle: "for starting a business",
                        motivation: user?.motivation,
                      ),
                    ),
                  ),
                ),
              if (user?.profileVisibility != null)
                Visibility(
                  visible: getProfileVisibility("motivation"),
                  child: Padding(
                    padding: getPadding(top: 31),
                    child: Divider(
                      height: getVerticalSize(1),
                      thickness: getVerticalSize(1),
                      color: AppColors.blueGray700,
                      indent: getHorizontalSize(35),
                      endIndent: getHorizontalSize(35),
                    ),
                  ),
                ),
              if (user?.profileVisibility != null)
                Padding(
                  padding: getPadding(
                    left: 35,
                    top: getTopVisibility() ? 27 : 0,
                    right: 35,
                  ),
                  child: Row(
                    mainAxisAlignment: getProfileVisibility("passion") &&
                            getProfileVisibility("hours")
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: getProfileVisibility("passion"),
                        child: InkWell(
                          onTap: () async {
                            if (user?.userId == activeUser?.userId) {
                              await Navigator.pushNamed(
                                context,
                                PassionScreen.routeName,
                              );
                              setState(() {});
                            }
                          }, //jim
                          child: ProgressBarWidget(
                            title: "Level of passion",
                            subTitle: "I have for starting a business",
                            isCurrentUser: user?.userId == activeUser?.userId,
                            //progress: 0,
                            progress: user?.level_of_passion != null
                                ? user?.level_of_passion?.toDouble() ?? 0
                                : 0,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: getProfileVisibility("hours"),
                        child: InkWell(
                          onTap: () async {
                            if (user!.userId == activeUser!.userId) {
                              await Navigator.pushNamed(
                                context,
                                HoursPerWeekScreen.routeName,
                              );
                              setState(() {});
                            }
                          },
                          child: ProgressBarWidget(
                            percentageToHours: true,
                            title: "Hours",
                            subTitle: "I am able to work \neach week",
                            isCurrentUser: user?.userId == activeUser?.userId,
                            progress: user?.hours_per_week != null
                                ? user?.hours_per_week?.toDouble() ?? 0
                                : 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (user?.profileVisibility != null)
                Visibility(
                  visible: getTopVisibility(),
                  child: Padding(
                    padding: getPadding(top: 31),
                    child: Divider(
                      height: getVerticalSize(1),
                      thickness: getVerticalSize(1),
                      color: AppColors.blueGray700,
                      indent: getHorizontalSize(35),
                      endIndent: getHorizontalSize(35),
                    ),
                  ),
                ),
              if (user?.profileVisibility != null)
                Visibility(
                  visible: (user?.userId == activeUser?.userId ||
                      ((user?.profileVisibility?.interests ?? false) &&
                          user?.personal_interests != null)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: getPadding(left: 35, top: 26, right: 35),
                      child: SkillView(
                        title: (user?.userId == activeUser?.userId)
                            ? "Your interests"
                            : "Interests",
                        tap: () {
                          setState(() {});
                        },
                        skills: Interests.convertInterestsAsSkills(
                            user?.personal_interests),
                      ),
                    ),
                  ),
                ),
              if (user?.profileVisibility != null)
                Visibility(
                  visible: (user?.userId == activeUser?.userId ||
                      ((user?.profileVisibility?.interests ?? false) &&
                          user?.personal_interests != null)),
                  child: Padding(
                    padding: getPadding(top: 35),
                    child: Divider(
                      height: getVerticalSize(1),
                      thickness: getVerticalSize(1),
                      color: AppColors.blueGray700,
                      indent: getHorizontalSize(35),
                      endIndent: getHorizontalSize(35),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: getPadding(left: 35, top: 26),
                  child: Text(
                    (user?.userId == activeUser?.userId)
                        ? "Your perfect matches"
                        : "Perfect matches",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsRegular14WhiteA700,
                  ),
                ),
              ),
              if (user?.match_code != null)
                Padding(
                  padding: getPadding(top: 25, bottom: 30),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Wrap(
                      runSpacing: getVerticalSize(4),
                      spacing: getHorizontalSize(24),
                      children: List<Widget>.generate(
                        user?.match_code?.length ?? 0,
                        (index) => MatchWidget(
                          matchData: getColorCodeFromPersonalityCode(
                            user!.match_code![index],
                            50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool getProfileVisibility(String type) {
    if (user?.profileVisibility == null) return false;
    if (user!.userId == activeUser!.userId) return true;
    switch (type) {
      case "passion":
        return (user?.profileVisibility!.level_of_passion == true &&
            user?.level_of_passion != null &&
            user?.level_of_passion != 0);
      case "hours":
        return (user?.profileVisibility!.hours_per_week == true &&
            user?.hours_per_week != null &&
            user?.hours_per_week != 0);
      case "motivation":
        return (user?.profileVisibility!.motivation == true &&
            getMotivationValue(user?.motivation) != 0);
      default:
        return true;
    }
  }

  bool getTopVisibility() {
    if (user?.profileVisibility == null) return false;
    return (getProfileVisibility("passion") || getProfileVisibility("hours"));
  }

  int getQualityLength() {
    if (user!.qualities != null) {
      if (user!.qualities!.length < 5) {
        return user!.qualities!.length;
      } else {
        return 5;
      }
    }
    return 0;
  }
}

Widget biographyWidget() {
  return Column(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: getPadding(top: 14, right: 25),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: TitleString.businessIdeaTitle,
                  style: TextStyle(
                    color: AppColors.whiteA700,
                    fontSize: getFontSize(13),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: " - ${TitleString.titleIdeaScreenOption1}",
                  style: TextStyle(
                    color: AppColors.whiteA700,
                    fontSize: getFontSize(13),
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    ],
  );
}
