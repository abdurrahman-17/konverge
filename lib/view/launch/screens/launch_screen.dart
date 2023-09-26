import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../blocs/remote_config/remote_config_bloc.dart';
import '../../../models/app_update_model.dart';
import '../../../repository/user_repository.dart';

import '../../../services/amplify/amplify_service.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../core/app_export.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../models/graphql/user_info.dart';
import '../../../utilities/AppLifecycleObserver.dart';
import '../../../utilities/common_design_utils.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../match_notification/screens/match_notification_screen.dart';
import '../widgets/bottom_nav_screen.dart';
import '../widgets/side_menu.dart';
import 'home/home_screen.dart';
import 'match/your_matches_screen.dart';
import 'profile/profile_screen.dart';
import 'search/search_screen.dart';

class LaunchScreen extends StatefulWidget {
  static const String routeName = "/launch";

  const LaunchScreen({
    super.key,
    this.tab = 0,
  });

  final int? tab;

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  UserInfoModel? user;
  final zoomDrawerController = ZoomDrawerController();
  int selectedIndex = 0;
  late AppLifecycleObserver _lifecycleObserver;
  int notificationCount = 0;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  void readNotificationCount() {
    BlocProvider.of<GraphqlBloc>(context).add(
      ReadMatchCountEvent(),
    );
  }

  @override
  void initState() {
    readNotificationCount();
    super.initState();
    readUser();
    _lifecycleObserver = AppLifecycleObserver(
      onResumeCallback: () {
        //here you can manage when the app resumes
        log(" On resume");
      },
    );
    WidgetsBinding.instance.addObserver(_lifecycleObserver);

    if (mounted) {
      setState(() {
        selectedIndex = widget.tab ?? 0;
      });

      BlocProvider.of<GraphqlBloc>(context).add(
        const ReadLoggedInUserInfoEvent(),
      );
    }
    BlocProvider.of<RemoteConfigBloc>(context).add(RemoteConfigLoginTypesEvent());
  }

  Future<void> readUser() async {
    var userPref = Locator.instance.get<UserRepo>().getCurrentUserData();
    if (userPref != null) {
      user = userPref;
      // activeUser = userPref;
      // currentUser = User.fromUserInfoModel(user as UserInfoModel);
      getData();
    }
    // setState(() {
    //   if (userPref != null) {
    //     user = userPref;
    //     // activeUser = userPref;
    //     // currentUser = User.fromUserInfoModel(user as UserInfoModel);
    //     getData();
    //   }
    // });
  }

  Future<void> getData() async {
    final activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();
    if (activeUser == null) {
      return;
    }
    final path = await AmplifyService()
        .getStoragePath(activeUser.profilePicUrlPath ?? "");
    if (path[0].isNotEmpty) {
      // currentUser.profileImageUrl = path[0];
      activeUser.profileImageUrl = path[0];
      Locator.instance.get<UserRepo>().setCurrentUserData(activeUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RemoteConfigBloc, RemoteConfigState>(
      listener: (context, state) {
        if (state is RemoteConfigLoginTypeState) {
          if (state.status == ProviderStatus.loaded) {
            WidgetsBinding.instance.addPostFrameCallback(
                  (_) async {
                final configModel = state.remoteConfigModel;
                if (configModel != null) {
                  AppUpdateModel updateModel = configModel.updateModel;
                  launchForceUpdate(updateModel);
                }
              },
            );
          }
        }
      },
      child: BlocListener<GraphqlBloc, GraphqlState>(
        listener: (BuildContext context, state) {
          switch (state.runtimeType) {
            case ReadMatchCountSuccessState:
              state as ReadMatchCountSuccessState;
              setState(() {
                notificationCount = state.count;
              });
              break;
          }
        },
        child: Stack(
          children: [
            commonBackground,
            ZoomDrawer(
              androidCloseOnBackTap: true,
              mainScreenTapClose: true,
              borderRadius: 42.0,
              overlayBlur: 0,
              angle: 0.0,
              disableDragGesture: true,
              //shrinkMainScreen: true,
              controller: zoomDrawerController,
              menuBackgroundColor: AppColors.black9007c,
              drawerShadowsBackgroundColor: Colors.black.withOpacity(0.68),
              slideWidth:
                  getHorizontalSize(MediaQuery.of(context).size.width) * 0.65,
              openCurve: Curves.fastOutSlowIn,
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.2),
              //     offset: const Offset(-3, 3),
              //     blurRadius: 4,
              //     spreadRadius: 4,
              //   ),
              // ],
              closeCurve: Curves.bounceIn,
              moveMenuScreen: false,
              mainScreenScale: 0.20,
              mainScreen: Stack(
                children: [
                  commonBackground,
                  Scaffold(
                    resizeToAvoidBottomInset: true,
                    body: contents(context),
                    bottomNavigationBar: BottomNavScreen(
                      selectedIndex: selectedIndex,
                      onTapHome: () => seIndex(0),
                      onTapMatch: () => seIndex(1),
                      onTapSearch: () => seIndex(2),
                      onTapProfile: () => seIndex(3),
                    ),
                    appBar: CommonAppBar.appBar(
                      context: context,
                      svgPath: Assets.imgMenuIcon,
                      text: selectedIndex == 1
                          ? "Your Matches"
                          : selectedIndex == 2
                              ? "Search"
                              : selectedIndex == 3
                                  ? "Your Profile"
                                  : "",
                      actions: selectedIndex == 1
                          ? [
                              InkWell(
                                onTap: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    MatchNotificationScreen.routeName,
                                  );
                                  readNotificationCount();
                                },
                                child: CustomLogo(
                                  height: getSize(18),
                                  width: getSize(18),
                                  svgPath: (notificationCount <= 0)
                                      ? Assets.imgNoNotification
                                      : Assets.imgActiveNotification,
                                  margin: getMargin(
                                    left: 35,
                                    top: 1,
                                    right: 35,
                                    bottom: 1,
                                  ),
                                ),
                              ),
                            ]
                          : selectedIndex == 3
                              ? [
                                  CustomLogo(
                                    height: getSize(18),
                                    width: getSize(18),
                                    svgPath: Assets.imgSearchWhiteA700,
                                    margin: getMargin(
                                        left: 35, top: 1, right: 35, bottom: 1),
                                    onTap: () {
                                      zoomDrawerController.toggle?.call();
                                    },
                                  ),
                                ]
                              : [],
                      leading: Container(
                        margin: getMarginOrPadding(left: 20),
                        child: IconButton(
                          hoverColor: AppColors.transparent,
                          highlightColor: AppColors.transparent,
                          focusColor: AppColors.transparent,
                          splashColor: AppColors.transparent,
                          icon: CustomLogo(
                            svgPath: Assets.imgMenuIcon,
                            width: getHorizontalSize(19),
                            fit: BoxFit.fitWidth,
                            color: AppColors.whiteA700,
                          ),
                          onPressed: () {
                            zoomDrawerController.toggle?.call();
                          },
                        ),
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
              menuScreen: SideMenu(
                user: user,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void seIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget contents(BuildContext context) {
    return selectedIndex == 0
        ? HomeScreen(
            zoomDrawerController: zoomDrawerController,
          )
        : selectedIndex == 1
            ? const YourMatchesScreen()
            : selectedIndex == 2
                ? SearchScreen()
                : ProfileScreen(
                    onTapProfile: () {
                      zoomDrawerController.toggle?.call();
                    },
                  );
  }
}
