import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../repository/user_repository.dart';
import '../../../utilities/transition_constant.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../models/graphql/pre_questionnaire_info_request.dart';
import '../../../models/graphql/user_info.dart';
import '../../../utilities/title_string.dart';
import '../../../core/app_export.dart';
import 'almost_there_screen.dart';
import '../widgets/idea_item.dart';

import '../../../models/ideas/ideas.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/common_dialogs.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/loader.dart';

// ignore_for_file: must_be_immutable
class IdeasScreen extends StatefulWidget {
  static const String routeName = '/idea_screen';
  PreQuestionnaireInfoModel? requestModel;

  IdeasScreen({super.key, this.requestModel});

  @override
  State<IdeasScreen> createState() => _IdeasScreenState();
}

class _IdeasScreenState extends State<IdeasScreen>
    with TickerProviderStateMixin {
  TextEditingController conceptController = TextEditingController();
  TextEditingController launchController = TextEditingController();
  TextEditingController alreadyController = TextEditingController();
  GlobalKey<FormState> conceptGlobalKey = GlobalKey<FormState>();
  GlobalKey<FormState> launchGlobalKey = GlobalKey<FormState>();
  GlobalKey<FormState> alreadyGlobalKey = GlobalKey<FormState>();
  List<Ideas> ideas = [];
  Ideas? selected;
  bool isLoading = false;
  bool isFromSettings = false;
  UserInfoModel? user;
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(
            milliseconds: TransitionConstant.ideaScreenTransitionDuration),
        vsync: this,
        reverseDuration: Duration.zero);
    ideas = [
      Ideas(
          id: Constants.ideaScreenOption1,
          title: TitleString.titleIdeaScreenOption1,
          hint: ""),
      Ideas(
          id: Constants.ideaScreenOption2,
          title: TitleString.titleIdeaScreenOption2,
          globalKey: conceptGlobalKey,
          hint: "Describe your idea in a couple of sentences",
          controller: conceptController),
      Ideas(
          id: Constants.ideaScreenOption3,
          title: TitleString.titleIdeaScreenOption3,
          globalKey: launchGlobalKey,
          hint: "Describe your idea in a couple of sentences",
          controller: launchController),
      Ideas(
          id: Constants.ideaScreenOption4,
          title: TitleString.titleIdeaScreenOption4,
          globalKey: alreadyGlobalKey,
          hint: "Describe your idea in a couple of sentences",
          controller: alreadyController)
    ];
    selected = ideas[0]; //setting first option as default selection.
    if (widget.requestModel ==
        null) //checking weather the screen is part of sign up process or from settings page.
    {
      isFromSettings = true;
      readUser();
    }

    super.initState();
  }

  Future<void> readUser() async {
    var userPref = Locator.instance.get<UserRepo>().getCurrentUserData();
    setState(() {
      if (userPref != null) user = userPref;
      log("user ${user!.business_idea}");
      if (user != null && user?.business_idea != null) {
        switch (user?.business_idea) {
          case Constants.ideaScreenOption1:
            selected = ideas[0];
            break;
          case Constants.ideaScreenOption2:
            conceptController.text = user?.business_idea_info ?? '';
            selected = ideas[1];
            _controller!.reverse().then((value) {
              setState(() {
                _controller!.forward();
              });
            });
            break;
          case Constants.ideaScreenOption3:
            launchController.text = user?.business_idea_info ?? '';
            selected = ideas[2];
            _controller!.reverse().then((value) {
              setState(() {
                _controller!.forward();
              });
            });
            break;
          case Constants.ideaScreenOption4:
            alreadyController.text = user?.business_idea_info ?? '';
            selected = ideas[3];
            _controller!.reverse().then((value) {
              setState(() {
                _controller!.forward();
              });
            });
            break;
          default:
            print("preselected option default");
            selected = ideas[0];
        }
      }
    });
    if (selected!.title != ideas[0].title) {
      selected!.controller!.addListener(() {
        if (selected!.controller!.text.length < 50) {
          setState(() {});
        }
        if (selected!.controller!.text.length >= 50) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: Stack(
        children: [
          commonBackground,
          CommonBgLogo(
            opacity: 0.6,
            position: CommonBgLogoPosition.bottomRight,
          ),
          Scaffold(
            resizeToAvoidBottomInset: true,
            body: BlocListener<GraphqlBloc, GraphqlState>(
                listener: (BuildContext context, state) {
                  setState(() {
                    isLoading = false;
                  });

                  switch (state.runtimeType) {
                    case QueryLoadingState:
                      log("UI query loading");
                      setState(() {
                        isLoading = true;
                      });
                      break;
                    case QueryUpdateSuccessState:
                      HapticFeedback.vibrate();
                      Navigator.pushNamed(
                        context,
                        AlmostThereScreen.routeName,
                      );
                      break;
                    case SaveBusinessStageSuccessState:
                      user?.business_idea =
                          (state as SaveBusinessStageSuccessState).ideaStage;
                      user?.business_idea_info =
                          (state as SaveBusinessStageSuccessState).moreInfo;
                      Locator.instance
                          .get<UserRepo>()
                          .setCurrentUserData(user!);
                      Navigator.pop(context);
                      break;
                    case GraphqlErrorState:
                      log("Graphql error state: $state");
                      break;
                    default:
                      log("Graphql Unknown state while logging in: $state");
                  }
                },
                child: contents(context)),
            appBar: CommonAppBar.appBar(context: context),
            backgroundColor: Colors.transparent,
          ),
          if (isLoading) const Positioned(child: Loader())
        ],
      ),
    );
  }

  Widget contents(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Container(
          height: height - getVerticalSize(80),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: getPadding(left: 35, right: 35),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: getMargin(top: 10),
                        child: Text(
                          TitleString.titleIdeaScreen,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsSemiBold20,
                        ),
                      ),
                      Container(
                        margin: getMargin(top: 14),
                        child: Text(
                          TitleString.descriptionIdeaScreen,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsLight13,
                        ),
                      ),
                      Container(
                        margin: getMargin(top: 13),
                        child: ListView.builder(
                          itemCount: ideas.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (ideas[index] != selected) {
                                  setState(() {
                                    if (index != 0) {
                                      _controller!.reverse().then((value) {
                                        setState(() {
                                          selected = ideas[index];
                                          selected!.controller!.addListener(() {
                                            if (selected!.controller!.text.length <
                                                50) {
                                              setState(() {});
                                            }
                                            if (selected!.controller!.text.length >=
                                                50) {
                                              setState(() {});
                                            }
                                          });
                                          _controller!.forward();
                                        });
                                      });
                                    } else {
                                      selected = ideas[index];
                                    }
                                  });
                                }
                              },
                              child: IdeaItem(
                                idea: ideas[index],
                                isSelected: ideas[index] == selected,
                                animationController: _controller,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                  // height: getVerticalSize(47),
                  text: isFromSettings
                      ? TitleString.btnSave
                      : TitleString.btnNext,
                  enabled: selected!.controller == null
                      ? true
                      : selected!.controller!.text.length >= 50,
                  margin: getMargin(
                    bottom: 80,
                    left: 35,
                    right: 35,
                  ),
                  onTap: () {
                    //checking any options selected by the user.
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    if (selected != null) {
                      //selected.
                      HapticFeedback.vibrate();
                      String ideaStage = selected?.id ?? '';
                      String moreInfo = "";
                      if (selected!.globalKey != null) {
                        if (!selected!.globalKey!.currentState!.validate()) {
                          return;
                        }
                      }
                      if (selected?.controller != null) {
                        /*the selected item is not the first one.
                            So text should not be empty*/
                        moreInfo = selected?.controller?.text.toString() ?? '';

                        if (moreInfo.length <= 1) {
                          showInfo(
                            context,
                            content:
                                "Please enter some info about your business",
                            buttonLabel: TitleString.btnOkay,
                          );
                          return;
                        }
                      }
                      if (widget.requestModel != null) {
                        //this screen is showing as the part of signup process.

                        widget.requestModel?.businessStage = ideaStage;
                        widget.requestModel?.businessStageMoreInfo = moreInfo;
                        log("Calling update prequ from signup flow");
                        BlocProvider.of<GraphqlBloc>(context).add(
                          UpdatePreQuestionnaireInfoEvent(
                            requestModel: widget.requestModel!,
                          ),
                        );
                      } else {
                        //Screen is loaded from settings page.
                        log("Calling update prequ from settings flow");
                        log("ideaStage $ideaStage morr:$moreInfo");
                        user!.business_idea = ideaStage;
                        BlocProvider.of<GraphqlBloc>(context).add(
                          UpdateBusinessStageEvent(
                            ideaStage: ideaStage,
                            moreInfo: moreInfo,
                          ),
                        );
                      }
                    } else {
                      //no item is selected by the user.
                      showInfo(
                        context,
                        content:
                            "Select any one option from the list. and try again",
                        buttonLabel: TitleString.btnOkay,
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetData(BuildContext context) {
    return SizedBox(
      height: size.height,
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: size.height,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                // height: getVerticalSize(47),
                text:
                    isFromSettings ? TitleString.btnSave : TitleString.btnNext,
                enabled: true,
                margin: getMargin(
                  bottom: 30,
                  left: 35,
                  right: 35,
                ),
                onTap: () {
                  //checking any options selected by the user.
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  if (selected != null) {
                    //selected.
                    HapticFeedback.vibrate();
                    String ideaStage = selected?.id ?? '';
                    String moreInfo = "";
                    if (selected?.controller != null) {
                      /*the selected item is not the first one.
                          So text should not be empty*/
                      moreInfo = selected?.controller?.text.toString() ?? '';

                      if (moreInfo.length <= 1) {
                        showInfo(
                          context,
                          content: "Please enter some info about your business",
                          buttonLabel: TitleString.btnOkay,
                        );
                        selected?.globalKey?.currentState?.validate();
                        return;
                      }
                    }
                    if (widget.requestModel != null) {
                      //this screen is showing as the part of signup process.

                      widget.requestModel?.businessStage = ideaStage;
                      widget.requestModel?.businessStageMoreInfo = moreInfo;
                      log("Calling update prequ from signup flow");
                      BlocProvider.of<GraphqlBloc>(context).add(
                        UpdatePreQuestionnaireInfoEvent(
                          requestModel: widget.requestModel!,
                        ),
                      );
                    } else {
                      //Screen is loaded from settings page.
                      log("Calling update prequ from settings flow");
                      log("ideaStage $ideaStage morr:$moreInfo");
                      user!.business_idea = ideaStage;
                      BlocProvider.of<GraphqlBloc>(context).add(
                        UpdateBusinessStageEvent(
                          ideaStage: ideaStage,
                          moreInfo: moreInfo,
                        ),
                      );
                    }
                  } else {
                    //no item is selected by the user.
                    showInfo(
                      context,
                      content:
                          "Select any one option from the list. and try again",
                      buttonLabel: TitleString.btnOkay,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
