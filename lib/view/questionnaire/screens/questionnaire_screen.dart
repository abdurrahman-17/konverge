import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utilities/transition_constant.dart';

import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/app_export.dart';
import '../../../core/locator.dart';
import '../../../models/questionnaire/questionnaire.dart';
import '../../../services/api_requests/api_service.dart';
import '../../../services/shared_preference_service.dart';
import '../../../utilities/common_functions.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/common_dialogs.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/slidable_widget.dart';
import '../../launch/widgets/confirm_exit_screen.dart';
import '../../results/screens/result_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  static const String routeName = "/questionnaire";

  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen>
    with TickerProviderStateMixin {
  Questionnaire? question;
  List<Questionnaire> questionnaireList = [];
  int questionNumber = 1;
  bool isLoading = false;
  String answer = "Neutral";
  AnimationController? _controller;
  AnimationController? _controller2;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    if (mounted) readQuestionnaireData();
    _controller = AnimationController(
      duration: const Duration(
          milliseconds: TransitionConstant.questionnaireTransitionDuration),
      vsync: this,
    );
    animation =
        Tween<double>(begin: width.toDouble(), end: 0.0).animate(_controller!)
          ..addListener(
            () {
              setState(() {});
            },
          );
    _controller2 = AnimationController(
        duration: const Duration(
            milliseconds: TransitionConstant.questionnaireTransitionDuration),
        vsync: this,
        value: 1.0);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
    _controller2!.dispose();
  }

  void readQuestionnaireData() {
    BlocProvider.of<GraphqlBloc>(context)
        .add(const ReadQuestionnaireListEvent());
  }

  bool helpVisible = false;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: Stack(
        children: [
          BlocListener<GraphqlBloc, GraphqlState>(
            listener: (BuildContext context, state) {
              setState(() {
                isLoading = false;
              });
              log("state ${state.runtimeType}");
              switch (state.runtimeType) {
                case QueryLoadingState:
                  setState(() {
                    isLoading = true;
                  });
                  break;
                case QuestionnaireReadSuccessState:
                  setState(() {
                    questionnaireList = (state as QuestionnaireReadSuccessState)
                        .questionnaireList;

                    if (questionnaireList.isNotEmpty) {
                      question = questionnaireList.elementAt(0);
                    }
                    questionNumber = 1;
                    Future.delayed(Duration(milliseconds: 100), () {
                      setState(() {
                        _controller!.forward();
                        //  _controller2!.forward();
                        _controller2!
                            .reverse()
                            .then((value) => _controller2!.forward());
                      });
                    });
                  });
                  break;
                case UserStageUpdateToServerSuccessState:
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    ResultScreen.routeName,
                    (Route<dynamic> route) => false,
                  );
                  break;
                case GraphqlErrorState:
                  log("GraphqlErrorState: $state ${(state as GraphqlErrorState).errorMessage}");
                  break;
                default:
                  print("Unknown state while logging in: $state");
              }
            },
            child: Stack(
              children: [
                commonBackground,
                Container(
                  //decoration: commonGradientBg,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ],
            ),
          ),
          CommonBgLogo(
            opacity: 0.6,
            position: CommonBgLogoPosition.bottomLeft,
          ),
          Scaffold(
            resizeToAvoidBottomInset: true,
            body: WillPopScope(
              onWillPop: () async {
                // Custom logic to determine whether to allow back navigation or not
                // Return false to restrict the back button
                //onTapDeny(context);
                if (questionNumber - 1 != 0) {
                  setState(() {
                    _controller!.reverse().then((value) {
                      animation =
                          Tween<double>(begin: -width.toDouble(), end: 0.0)
                              .animate(_controller!);
                      questionNumber--;
                      _controller!.forward();
                    });
                    // questionNumber--;
                    if (questionnaireList.length > (questionNumber - 1)) {
                      question = questionnaireList[questionNumber - 1];
                    }
                  });
                } else {
                  confirmExit(context);
                }
                return false;
              },
              child: Stack(
                children: [
                  contents(context),
                  if (isLoading) const Positioned(child: Loader())
                ],
              ),
            ),
            appBar: CommonAppBar.appBar(
              context: context,
              // canGoBack: questionNumber == 1 ? false : true,
              leading: questionNumber == 1
                  ? null
                  : IconButton(
                      hoverColor: AppColors.transparent,
                      highlightColor: AppColors.transparent,
                      focusColor: AppColors.transparent,
                      splashColor: AppColors.transparent,
                      icon: CustomLogo(
                        svgPath: Assets.imgArrowLeft,
                        width: getHorizontalSize(19),
                        fit: BoxFit.fitWidth,
                        color: AppColors.whiteA700,
                      ),
                      onPressed: () {
                        if (questionNumber - 1 != 0) {
                          setState(() {
                            _controller!.reverse().then((value) {
                              animation = Tween<double>(
                                      begin: -width.toDouble(), end: 0.0)
                                  .animate(_controller!);
                              questionNumber--;
                              _controller!.forward();
                            });
                            if (questionnaireList.length >
                                (questionNumber - 1)) {
                              question = questionnaireList[questionNumber - 1];
                            }
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),

              titleWidget: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Question ",
                      style: TextStyle(
                        color: AppColors.whiteA700,
                        fontSize: getFontSize(14),
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextSpan(
                      text: "$questionNumber/${questionnaireList.length}",
                      style: TextStyle(
                        color: AppColors.whiteA700,
                        fontSize: getFontSize(14),
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  Future<void> confirmExit(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => ConfirmExitScreen(),
    );
  }

  Widget contents(BuildContext context) {
    return Container(
      padding: getPadding(bottom: 70),
      height: size.height,
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: getPadding(left: 35, right: 35),
            child: InkWell(
              onTap: () {
                setState(() {
                  helpVisible = !helpVisible;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: helpVisible,
                    child: Padding(
                      padding: getPadding(right: 15),
                      child: CustomRichText(
                        text:
                            "Slide the slider to represent the extremity of your answer",
                        style: AppStyle.txtPoppinsLight10,
                        //   overflow: TextOverflow.ellipsis,
                        //   textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  CustomLogo(
                    svgPath: Assets.imgQuestion,
                    height: getSize(18),
                    width: getSize(18),
                  ),
                ],
              ),
            ),
          ),
          if (questionnaireList.length > (questionNumber - 1))
            AnimatedBuilder(
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(animation!.value, 0),
                  child: Container(
                    padding: getPadding(left: 35, right: 35),
                    margin: getMargin(top: 57),
                    height: getTextContainHeight(
                      text: getBiggestQuestions(),
                      style: AppStyle.txtPoppinsSemiBoldItalic18,
                      maxWidth: getHorizontalSize(305),
                    ),
                    child: CustomRichText(
                      text: question != null
                          ? questionnaireList[questionNumber - 1].question
                          : "",
                      style: AppStyle.txtPoppinsSemiBoldItalic18,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              animation: animation!,
            ),
          if (questionnaireList.length > (questionNumber - 1))
            SlidableWidget(
              question: questionnaireList[questionNumber - 1],
              onChange: () {
                setState(() {
                  // print("percentage ${ questionnaireList[questionNumber - 1].percentage}");
                });
              },
            ),
          const Spacer(),
          if (questionnaireList.length > (questionNumber - 1))
            Padding(
              padding: getPadding(left: 35, right: 35),
              child: CustomButton(
                text: questionNumber == questionnaireList.length
                    ? "Submit"
                    : "Next",
                // enabled: questionNumber == questionnaireList.length,
                enabled: questionnaireList[questionNumber - 1].percentage != -1,
                onTap: () async {
                  if (questionnaireList[questionNumber - 1].percentage == -1) {
                    showInfo(
                      context,
                      title: TitleString.titleAlert,
                      content: TitleString.pleaseSelectTheAnswer,
                      buttonLabel: TitleString.btnOkay,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    );
                    return;
                  }
                  if (questionNumber < questionnaireList.length) {
                    setState(() {
                      animation =
                          Tween<double>(begin: -width.toDouble(), end: 0.0)
                              .animate(_controller!);
                      _controller!.reverse().then((value) {
                        animation =
                            Tween<double>(begin: width.toDouble(), end: 0.0)
                                .animate(_controller!);
                        HapticFeedback.vibrate();
                        questionNumber++;
                        _controller2!
                            .reverse()
                            .then((value) => _controller2!.forward());
                        _controller!.forward();
                      });
                      log("percentage ${questionnaireList[questionNumber - 1].percentage}");
                      //question = questionnaireList[questionNumber - 1];
                    });
                  } else {
                    var userId =
                        Locator.instance.get<SharedPrefServices>().getUserId();
                    setState(() {
                      isLoading = true;
                    });
                    final matchResponse =
                        await ApiService().submitQuestionnaireData(
                      questions: questionnaireList,
                      userId: userId,
                    );

                    setState(() {
                      isLoading = false;
                    });
                    if (matchResponse != null) {
                      log("${matchResponse.data}");
                      setState(() {
                        isLoading = true;
                      });
                      BlocProvider.of<GraphqlBloc>(context).add(
                        const UpdateNavigationStageInfoEvent(
                          stage:
                              Constants.navigationStageQuestionnaireCompleted,
                        ),
                      );
                    } else {
                      restartQuestionnaire();
                    }
                  }
                },
                variant: ButtonVariant.outlineBlack90035_1,
              ),
            )
        ],
      ),
    );
  }

  void restartQuestionnaire() {
    for (Questionnaire questionnaire in questionnaireList) {
      questionnaire.percentage = 50;
      questionnaire.code = questionnaire.agree?.code ?? '';
    }
    setState(() {
      questionNumber = 1;
    });
  }

  String getBiggestQuestions() {
    String biggest = "";
    for (Questionnaire questionnaire in questionnaireList) {
      if (biggest.length < questionnaire.question.length) {
        biggest = questionnaire.question;
      }
    }
    return biggest;
  }
}
