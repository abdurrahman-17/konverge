import 'package:flutter/material.dart';
import 'package:konverge/utilities/title_string.dart';
import 'package:konverge/view/common_widgets/loader.dart';

import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../models/graphql/user_info.dart';
import '../../../models/skills/skills.dart';
import '../../../repository/user_repository.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/app_style.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/common_design_utils.dart';
import '../../../utilities/common_navigation_logics.dart';
import '../../../utilities/size_utils.dart';
import '../../../utilities/styles/common_styles.dart';

import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/match_widget.dart';
import '../../common_widgets/scrollable_widget.dart';
import '../../launch/widgets/confirm_exit_screen.dart';

class ResultScreen extends StatefulWidget {
  static const String routeName = "/result";

  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  double factor = width / height;
  UserInfoModel? user;
  List<Skills> qualitySkillSets = [];
  List<Widget> matchWidgetLists = [];
  AnimationController? _controller;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GraphqlBloc>(context).add(
      const ReadLoggedInUserInfoEvent(),
    );
    _controller = AnimationController(
        duration: const Duration(milliseconds: 350), vsync: this, value: 1);
    animation =
        Tween<double>(begin: 0.0, end: height.toDouble()).animate(_controller!)
          ..addListener(() {
            setState(() {});
          });
  }

  Future<void> readUser() async {
    var userPref = Locator.instance.get<UserRepo>().getCurrentUserData();
    setState(() {
      if (userPref != null) user = userPref;
      // user?.match_code;
      // user?.my_code;
      // user?.qualities;
      qualitySkillSets = [];
      if (user?.qualities != null)
        for (String quality in user?.qualities ?? []) {
          qualitySkillSets.add(Skills(skill: quality));
        }
      if ((user?.match_code ?? []).isNotEmpty) {
        for (String matchCode in user?.match_code ?? []) {
          matchWidgetLists.add(
            Container(
              margin: getMargin(left: 12, right: 12),
              child: MatchWidget(
                matchData: getColorCodeFromPersonalityCode(matchCode, 50),
              ),
            ),
          );
        }
      }
      _controller!.reverse();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonBackground,
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: WillPopScope(
            onWillPop: () async {
              // Custom logic to determine whether to allow back navigation or not
              // Return false to restrict the back button
              //onTapDeny(context);
              confirmExit(context);
              return false;
            },
            child: contents(context),
          ),
          backgroundColor: Colors.transparent,
        ),
        if (isLoading) Loader(),
      ],
    );
  }

  Future<void> confirmExit(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => ConfirmExitScreen(),
    );
  }

  Widget contents(BuildContext context) {
    String warningMessage =
        "${user?.firstname ?? ''}, this is your personality color type";
    return BlocListener<GraphqlBloc, GraphqlState>(
      listener: (BuildContext context, state) async {
        setState(() {
          isLoading = false;
        });
        switch (state.runtimeType) {
          case QueryLoadingState:
            setState(() {
              isLoading = true;
            });
            break;
          case ReadUserSuccessState:
            readUser();
            break;
          case MyQualityOrderUpdateSuccess:
            BlocProvider.of<GraphqlBloc>(context).add(
              const UpdateNavigationStageInfoEvent(
                stage: Constants.navigationStageResultScreenAccepted,
              ),
            );
            break;
          case UserStageUpdateToServerSuccessState:
            if (user != null) {
              user?.stage =
                  (state as UserStageUpdateToServerSuccessState).stage;
              Locator.instance.get<UserRepo>().setCurrentUserData(user!);
              await _controller!.forward();
              readStageOfLoggedInUserAndNavigate(context);
            }
            break;
          case GraphqlErrorState:
            break;
          default:
            print("Unknown state while logging in: $state");
        }
      },
      child: SizedBox(
        // height: getVerticalSize(987),
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedBuilder(
                builder: (context, child) {
                  return Column(
                    children: [
                      Transform.translate(
                        offset: Offset(-animation!.value * factor, 0),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  getPadding(top: 115, left: 70, right: 70),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomRichText(
                                    text: TitleString.titleDescriptionResults,
                                    style: AppStyle.txtPoppinsSemiBold14,
                                    textAlign: TextAlign.left,
                                  ),
                                  Container(
                                    margin: getMargin(top: 12, bottom: 12),
                                    child: MatchWidget(
                                      matchData:
                                          getColorCodeFromPersonalityCode(
                                        user?.my_code ?? "Unknown",
                                        120,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: CustomRichText(
                                      text: warningMessage,
                                      style: TextStyle(
                                        color: AppColors.whiteA700,
                                        fontSize: getFontSize(20),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(top: 23),
                                    child: CustomRichText(
                                      text: "Your perfect matches are",
                                      style: AppStyle
                                          .txtPoppinsRegular13W400WhiteA700,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: getMargin(top: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: matchWidgetLists,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, animation!.value),
                        child: Container(
                          margin: getMargin(top: 16),
                          padding: getPadding(
                              left: 35, top: 28, right: 35, bottom: 28),
                          decoration: AppDecoration.fillBlack9007c.copyWith(
                              borderRadius: BorderRadiusStyle.customBorderTL35),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "My Qualities - ",
                                      style: TextStyle(
                                        color: AppColors.whiteA700,
                                        fontSize: getFontSize(14),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "personality type explained",
                                      style: TextStyle(
                                        color: AppColors.whiteA700,
                                        fontSize: getFontSize(14),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                margin: getMargin(top: 20),
                                child: CustomRichText(
                                  text: TitleString.warningQualityList,
                                  style: AppStyle.txtPoppinsLight12BlueGray300,
                                  textAlign: TextAlign.left,
                                ),
                              ),

                              Visibility(
                                visible: qualitySkillSets.isNotEmpty,
                                child: Padding(
                                  padding: getPadding(top: 25),
                                  child: Container(
                                    height: getVerticalSize(
                                        (41 * qualitySkillSets.length)
                                            .toDouble()),
                                    width: size.width,
                                    color: Colors.transparent,
                                    child: ScrollableWidget(
                                      list: qualitySkillSets,
                                      type: "skills",
                                    ),
                                  ),
                                ),
                              ),
                              // Visibility(
                              //   child: Padding(
                              //     padding: getPadding(top: 25),
                              //     child: ListView.separated(
                              //       physics: const NeverScrollableScrollPhysics(),
                              //       shrinkWrap: true,
                              //       separatorBuilder: (context, index) {
                              //         return SizedBox(height: getVerticalSize(7));
                              //       },
                              //       itemCount: qualitySkillSets.length,
                              //       itemBuilder: (context, index) {
                              //         return ResultItemWidget(
                              //           skill: qualitySkillSets[index],
                              //           index: index + 1,
                              //         );
                              //       },
                              //     ),
                              //   ),
                              // ),
                              CustomButton(
                                text: "Next",
                                enabled: true,
                                margin: getMargin(top: 40),
                                onTap: () {
                                  //readUser();
                                  if(!isLoading)
                                  BlocProvider.of<GraphqlBloc>(context).add(
                                    UpdateMyQualityOrderEvent(
                                      myQualityList: qualitySkillSets,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                animation: animation!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
