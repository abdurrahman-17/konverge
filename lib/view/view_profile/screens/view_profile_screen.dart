import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../blocs/search_user/search_user_bloc.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../main.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/loader.dart';
import '../../../core/configurations.dart';
import '../../../models/graphql/user_info.dart';
import '../../../theme/app_style.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/common_functions.dart';
import '../../../utilities/transition_constant.dart';
import '../../common_widgets/common_message_dialogue.dart';
import '../../its_match/screens/its_match_screen.dart';
import '../../launch/screens/launch_screen.dart';
import '../../launch/widgets/profile/profile_view.dart';
import 'view_profile_details_screen.dart';
import '../../launch/widgets/bottom_nav_screen.dart';
import '../../../utilities/size_utils.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_app_bar.dart';
import '../widgets/view_profile_dialogue.dart';

class ViewProfileScreen extends StatefulWidget {
  static const String routeName = "/view_profile";
  final String cognitoId;
  final String from;
  final String userId;
  final String currentUserId;

  const ViewProfileScreen({
    super.key,
    required this.cognitoId,
    required this.currentUserId,
    required this.userId,
    this.from = "",
  });

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen>
    with TickerProviderStateMixin {
  bool firstTime = true;
  AnimationController? _controller;
  Animation<double>? animation;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(
        milliseconds:
            TransitionConstant.viewProfileAlertDialogTransitionDuration,
      ),
      vsync: this,
    );
    fetchUserDetail();
    super.initState();
  }

  void fetchUserDetail() {
    if (widget.cognitoId.isNotEmpty) {
      BlocProvider.of<UserBloc>(context).add(
        FetchUserDetailEvent(
          cognitoId: widget.cognitoId,
          userId: widget.currentUserId,
          searchId: widget.userId,
        ),
      );
    }
  }

  @override
  void dispose() {
    //UserBloc().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [commonBackground, blocData(context)],
    );
  }

  UserInfoModel? user;

  bool loading = false;
  String error = "";

  Widget blocData(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (BuildContext context, state) async {
        log("state $state");
        if (state is UserMatchedSuccessState) {
          log("status:${state.status}/t match:${state.itsMatch} match/reject:${state.isMatch}");
          if (state.status == ProviderStatus.loaded) {
            if (state.itsMatch) {
              await Navigator.pushNamed(
                context,
                ItsMatchScreen.routeName,
                arguments: {
                  'user': state.user,
                },
              );
              user?.statusData?.matchStatus = "Matched";
            } else if (state.isMatch) {
              // NOTE: Match request already sent! - changed data coming from server.
              dialogueBoxMatch(context, "${state.error}!");
              user?.statusData?.matchStatus = "${state.error}";
            } else if (state.isMatch == false) {
              dialogueBoxMatch(context, "TitleString.un_matched_with_this_user");
              fetchUserDetail();
            }
          }
        } else if (state is UserBlockedSuccessState) {
          if (mounted) {
            if (state.status == ProviderStatus.loaded) {
              dialogueBoxMatch(context, "You have blocked this user");
              user?.statusData?.blockStatus = true;
            }
          }
        } else if (state is UserUnBlockedSuccessState) {
          if (mounted) {
            if (state.status == ProviderStatus.loaded) {
              dialogueBoxMatch(context, "You have unblocked this user");
              user?.statusData?.blockStatus = false;
            }
          }
        }
      },
      builder: (context, state) {
        loading = false;
        if (state is FetchUserDetailState) {
          switch (state.status) {
            case ProviderStatus.loading:
              loading = true;
              break;
            case ProviderStatus.loaded:
              user = state.user;
              if (state.user == null) {
                BlocProvider.of<SearchUserBloc>(context).add(
                  DeleteRecentSearchEvent(cognitoId: widget.cognitoId),
                );
              }
              firstTime = true;
              break;
            case ProviderStatus.error:
              error = state.error;
              break;
            default:
              break;
          }
        }
        if (state is UserMatchedSuccessState) {
          log("status:${state.status}/t match:${state.itsMatch} match/reject:${state.isMatch}");
          if (state.status == ProviderStatus.loading) {
            loading = true;
          }
        } else if (state is UserBlockedSuccessState) {
          if (state.status == ProviderStatus.loading) {
            loading = true;
          }
        } else if (state is UserUnBlockedSuccessState) {
          if (state.status == ProviderStatus.loading) {
            loading = true;
          }
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: CommonAppBar.appBar(
            showAppBar: widget.from == "notificationBackground",
            context: context,
            text: "View Profile",
            onTapLeading: () {
              if (widget.from == "notificationBackground")
                Navigator.pushReplacementNamed(context, LaunchScreen.routeName);
              else
                Navigator.pop(context);
            },
            actions: [
              InkWell(
                onTap: () async {
                  if (user != null) {
                    await _controller!.reverse();
                    setState(() {
                      animation = Tween<double>(
                              begin: MediaQuery.of(context).size.width * 0.1,
                              end: 0.0)
                          .animate(_controller!)
                        ..addListener(() {
                          setState(() {});
                        });
                      _controller!.forward();
                    });
                    showDialog(
                      context: context,
                      builder: (_) => AnimatedBuilder(
                        builder: (context, child) {
                          return AlertDialog(
                            content: Transform.translate(
                              offset: Offset(animation!.value, 0.0),
                              child: ViewProfileDialog(
                                user: user,
                                matchType: widget.from == "search"
                                    ? Constants.matchTypeManual
                                    : Constants.matchTypeAlgorithm,
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                          );
                        },
                        animation: animation!,
                      ),
                    );
                  }
                },
                child: Container(
                  margin: getMarginOrPadding(right: 20),
                  child: Icon(
                    Icons.more_vert,
                    color: AppColors.whiteA700,
                    size: getSize(18),
                  ),
                ),
              ),
            ],
          ),
          body: firstTime && loading
              ? const SizedBox(
                  child: Loader(),
                )
              : Stack(
                  children: [
                    if (loading)
                      const SizedBox(
                        child: Loader(),
                      ),
                    user != null && user?.deleted == false
                        ? contents(context, user!)
                        : Center(
                            child: SizedBox(
                              child: Text(
                                user == null
                                    ? error.isNotEmpty
                                        ? error
                                        : TitleString.warningNoUserResult
                                    : user?.deleted == true
                                        ? TitleString.warningDeletedUserResult
                                        : TitleString.warningNoUserResult,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: AppStyle.txtPoppinsBoldItalic20,
                              ),
                            ),
                          ),
                  ],
                ),
          backgroundColor: Colors.transparent,
          bottomNavigationBar: widget.from.isNotEmpty
              ? BottomNavScreen(
                  selectedIndex: widget.from == "match" ||
                          widget.from == "notification" ||
                          widget.from == "notificationBackground"
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
        );
      },
    );
  }

  Widget contents(BuildContext context, UserInfoModel user) {
    return ProfileView(
      user: user,
      from: widget.from,
      onTapProfile: () async {
        await Navigator.pushNamed(
          context,
          ViewProfileDetailScreen.routeName,
          arguments: {
            "user": user,
            "from": widget.from,
          },
        );
      },
    );
  }
}

void dialogueBoxMatch(BuildContext context, String message) {
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
