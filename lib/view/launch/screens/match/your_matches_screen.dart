import 'dart:developer';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../services/shared_preference_service.dart';
import '../../../../blocs/graphql/graphql_event.dart';
import '../../../../blocs/graphql/graphql_state.dart';
import '../../../../blocs/graphql/graphql_bloc.dart';
import '../../../../core/app_export.dart';
import '../../../../core/locator.dart';
import '../../../../models/graphql/user_info.dart';
import '../../../../repository/user_repository.dart';
import '../../../its_match/screens/its_match_screen.dart';
import '../../../common_widgets/loader.dart';
import '../../../search_for_skills/screens/search_for_skills.dart';
import '../../widgets/profile/profile_view.dart';

class YourMatchesScreen extends StatefulWidget {
  const YourMatchesScreen({super.key});

  static const String routeName = 'your_match/';

  @override
  State<YourMatchesScreen> createState() => _YourMatchesScreenState();
}

class _YourMatchesScreenState extends State<YourMatchesScreen> {
  //User user = users[0];
  int matchSwipeCount = 0;
  int selectedIndex = 0;
  List<UserInfoModel> matches = [];
  AppinioSwiperController controller = AppinioSwiperController();
  List<UserInfoModel> alreadySwiped = [];

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();

  @override
  void initState() {
    skip = 0;
    matchSwipeCount =
        Locator.instance.get<SharedPrefServices>().getMatchCardSwipeCount();
    refreshData();
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => checkLookingForSkillsUpdated());
  }

  Future<void> checkLookingForSkillsUpdated() async {
    if (activeUser?.looking_for_skills == null ||
        activeUser!.looking_for_skills!.isEmpty) {
      var isSkillsUpdated = await Navigator.pushNamed(
        context,
        SearchForSkillsScreen.routeName,
        arguments: {
          'isSecondTime': true,
        },
      );
      if (isSkillsUpdated != null) {
        refreshData();
      }
    }
  }

  double width = 0;
  DragStartDetails? startHorizontalDragDetails;
  DragUpdateDetails? updateHorizontalDragDetails;
  String? swipeDirection;
  bool initialLoaded = false;

  void refreshData() {
    if (activeUser != null) {
      BlocProvider.of<GraphqlBloc>(context).add(
        FetchMatchUserListEvent(userId: activeUser!.userId!, skip: skip),
      );
    }
  }

  bool switched = true;
  bool loading = true;
  int skip = 0;
  String error = "";

  List<UserInfoModel> removeUnWantedItem(List<UserInfoModel> users) {
    matches = [];
    List<UserInfoModel> matchData = [];
    for (int i = 0; i < users.length; i++) {
      if (!inList(users[i])) matchData.add(users[i]);
    }
    return matchData;
  }

  bool inList(UserInfoModel model) {
    for (UserInfoModel user in alreadySwiped) {
      if (user.cognitoId
          .toString()
          .trim()
          .contains(model.cognitoId.toString().trim())) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // print("state ${controller.e}");
    return BlocConsumer<GraphqlBloc, GraphqlState>(
      listener: (BuildContext context, state) async {
        if (state is MatchSuccessState) {
          if (mounted) {
            if (state.itsMatch) {
              await Navigator.pushNamed(
                context,
                ItsMatchScreen.routeName,
                arguments: {'user': state.user},
              );
              refreshData();
            }
          }
        }
      },
      builder: (BuildContext context, state) {
        //   loading = false;
        if (state is FetchMatchesState) {
          print("wipe items ${state.matches}");
          loading = false;
          initialLoaded = true;
          matches = removeUnWantedItem(state.matches);
        } else if (state is MatchLoadingState) {
          loading = true;
        } else if (state is MatchSuccessState) {
          loading = false;
        } else if (state is MatchErrorState) {
          loading = false;
          error = state.errorMessage;
          print("error $state $error");
        } else if (state is GraphqlInitialState) {
          loading = false;
          print("error $state $error");
        } else {
          loading = false;
        }

        return Stack(
          children: [
            if (matches.isNotEmpty)
              AppinioSwiper(
                controller: controller,
                threshold: 100,
                backgroundCardsCount: 0,
                swipeOptions: AppinioSwipeOptions.symmetric(horizontal: true),
                padding: EdgeInsets.zero,
                onEnd: () {
                  print("on end");
                  loading = true;
                  matches = [];
                  skip = skip + Constants.matchItemInEachPage;
                  refreshData();
                },
                onSwipe: (index, direction) {
                  selectedIndex = index - 1;
                  if (!inList(matches[selectedIndex])) {
                    alreadySwiped.add(matches[selectedIndex]);
                  }

                  if (direction == AppinioSwiperDirection.right) {
                    Locator.instance
                        .get<SharedPrefServices>()
                        .setMatchCardSwipeCount(matchSwipeCount + 1);
                    matchSwipeCount = Locator.instance
                        .get<SharedPrefServices>()
                        .getMatchCardSwipeCount();
                    log("user ${matches[selectedIndex].interested_on_me}");
                    BlocProvider.of<GraphqlBloc>(context).add(
                      MatchUserEvent(
                        userId: activeUser!.userId!,
                        user: matches[selectedIndex],
                        matchType: Constants.matchTypeAlgorithm,
                        isMatch: true,
                      ),
                    );
                    if (matches.isEmpty) {
                      skip = skip + Constants.matchItemInEachPage;
                      refreshData();
                    }
                  } else if (direction == AppinioSwiperDirection.left) {
                    Locator.instance
                        .get<SharedPrefServices>()
                        .setMatchCardSwipeCount(matchSwipeCount + 1);
                    matchSwipeCount = Locator.instance
                        .get<SharedPrefServices>()
                        .getMatchCardSwipeCount();
                    BlocProvider.of<GraphqlBloc>(context).add(
                      MatchUserEvent(
                        userId: activeUser!.userId!,
                        user: matches[selectedIndex],
                        matchType: Constants.matchTypeAlgorithm,
                        isMatch: false,
                      ),
                    );
                  }
                },
                cardsBuilder: (BuildContext context, int index) {
                  return ProfileView(
                    user: matches[index],
                    from: "match",
                    isFromMatchesScreen: true,
                  );
                },
                cardsCount: matches.length,
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                visible: (matches.isNotEmpty && matchSwipeCount == 0),
                child: Padding(
                  padding: getPadding(bottom: 15, left: 35, right: 35),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xff104b71),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text(
                      "Swipe right to match, swipe left if not interested",
                      textAlign: TextAlign.center,
                      style: AppStyle.txtPoppinsLightItalic10,
                    ),
                  ),
                ),
              ),
            ),
            if ((matches.isEmpty) && loading == false && initialLoaded)
              Center(
                child: Container(
                  //  padding: getPadding(top: 250),
                  child: Text(
                    error.isNotEmpty ? error : "No Matches Found!",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: AppStyle.txtPoppinsBoldItalic20,
                  ),
                ),
              ),
            if ((loading || initialLoaded == false) && matches.isEmpty)
              Container(
                child: const Loader(),
              )
          ],
        );
      },
    );
  }
}
