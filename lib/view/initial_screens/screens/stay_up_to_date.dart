import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utilities/transition_constant.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/configurations.dart';
import '../../../models/graphql/pre_questionnaire_info_request.dart';
import '../../../view/common_widgets/loader.dart';
import '../../../core/app_export.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../launch/widgets/confirm_exit_screen.dart';
import 'journey_screen.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/custom_buttons.dart';

class StayUpToDate extends StatefulWidget {
  static const String routeName = '/stayUpToDate';

  const StayUpToDate({
    super.key,
  });

  @override
  State<StayUpToDate> createState() => _StayUpToDateState();
}

bool isLoading = false;

class _StayUpToDateState extends State<StayUpToDate>
    with TickerProviderStateMixin {
  double factor = getVerticalSize(226.19) / getHorizontalSize(184);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonBackground,
        AnimatedBuilder(
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(animation2!.value, -animation2!.value * factor),
              child: Stack(
                children: [
                  CommonBgLogo(
                    opacity:
                        1 - (getHorizontalSize(184) / animation2!.value) + 0.6,
                    position: CommonBgLogoPosition.center,
                  ),
                ],
              ),
            );
          },
          animation: animation2!,
        ),
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
            child: BlocListener<GraphqlBloc, GraphqlState>(
              listener: (BuildContext context, state) {
                setState(() {
                  isLoading = false;
                });
                switch (state.runtimeType) {
                  case QueryLoadingState:
                    /* setState(() {
                      isLoading = true;
                    });*/
                    break;
                  case QueryUpdateSuccessState:
                    /*  Navigator.pushNamed(
                      context,
                      YourJourneyScreen.routeName,  arguments: { 'data':widget.username}
                    );*/
                    break;
                  case GraphqlErrorState:
                    print("Graphql error state: $state");
                    break;
                  default:
                    print("Graphql Unknown state while logging in: $state");
                }
              },
              child: contents(context),
            ),
          ),
          //   appBar: CommonAppBar.appBar(context: context),
          backgroundColor: Colors.transparent,
        ),
        if (isLoading) const Positioned(child: Loader())
      ],
    );
  }

  Future<void> confirmExit(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => ConfirmExitScreen(),
    );
  }

  AnimationController? _controller;
  AnimationController? _controller2;
  AnimationController? _controller3;
  Animation<double>? animation;
  Animation<double>? animation2;
  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(
            milliseconds:
                TransitionConstant.stayUpToDatePageTransitionDuration),
        vsync: this,
        value: 1.0);
    _controller2 = AnimationController(
        duration: const Duration(
            milliseconds:
                TransitionConstant.stayUpToDatePageTransitionDuration),
        vsync: this);
    _controller3 = AnimationController(
        duration: const Duration(
            milliseconds:
                TransitionConstant.stayUpToDatePageLogoTransitionDuration),
        vsync: this);
    animation =
        Tween<double>(begin: 0.0, end: -width.toDouble()).animate(_controller2!)
          ..addListener(() {
            setState(() {});
          });
    animation2 = Tween<double>(begin: 0.0, end: getHorizontalSize(184))
        .animate(_controller3!)
      ..addListener(() {
        setState(() {});
      });
    animatedData();
    super.initState();
  }

  Future<void> animatedData() async {
    // _controller2!.forward();
    // await _controller3!.reverse();
    await _controller3!.forward();
    //_controller2!.reverse();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
    _controller2!.dispose();
    _controller3!.dispose();
  }

  Widget contents(BuildContext context) {
    return Container(
      height: size.height,
      width: double.maxFinite,
      margin: getMarginOrPadding(
        left: 35,
        top: 85,
        right: 35,
        bottom: 70,
      ),
      child: AnimatedBuilder(
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(animation!.value, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: CustomRichText(
                    text: "Stay up to date",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsMedium20,
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  margin: getMargin(top: 18),
                  padding: getPadding(
                    left: 115,
                    top: 53,
                    right: 115,
                    bottom: 53,
                  ),
                  decoration: AppDecoration.outlineBlack900351.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder35,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black90035,
                        spreadRadius: getHorizontalSize(0),
                        blurRadius: getHorizontalSize(2),
                        offset: const Offset(
                          0,
                          2,
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: Tween(begin: 0.7, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _controller!,
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: CustomLogo(
                          svgPath: Assets.imgNotification,
                          height: getVerticalSize(79),
                          width: getHorizontalSize(73),
                          margin: getMargin(top: 3),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: getMargin(top: 28),
                  child: CustomRichText(
                    text: "Let's keep you in the loop",
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsMediumTeal13,
                  ),
                ),
                Container(
                  width: getHorizontalSize(285),
                  margin: getMargin(top: 20, right: 19),
                  child: CustomRichText(
                    text:
                        "Be the first to know when our funding rounds open and be notified about your latest matches.",
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsLight13,
                  ),
                ),
                const Spacer(),
                CustomButton(
                  // height: getVerticalSize(47),
                  text: "Allow",
                  enabled: true,
                  onTap: () => onTapAllow(context),
                ),
                SizedBox(
                  height: getVerticalSize(8),
                ),
                CustomButton(
                  // height: getVerticalSize(47),
                  text: "Deny",
                  enabled: true,
                  fontStyle: ButtonFontStyle.poppinsRegular15WhiteA400,
                  variant: ButtonVariant.transparent,
                  onTap: () => onTapDeny(context),
                ),
              ],
            ),
          );
        },
        animation: animation!,
      ),
    );
  }

  Future<void> onTapAllow(BuildContext context) async {
    // BlocProvider.of<GraphqlBloc>(context).add(
    //   UpdateNotificationStatusEvent(
    //     userName: Locator.instance.get<SharedPrefServices>().getUserName(),
    //     isNotificationOn: true,
    //   ),
    // );

    await _controller!.reverse().then((value) => _controller!.forward());
    _controller2!.forward();
    HapticFeedback.vibrate();
    requestPushNotificationPermissionFromOS();
    await Navigator.pushNamed(
      context,
      YourJourneyScreen.routeName,
      arguments: {
        'data': PreQuestionnaireInfoModel(isAllowNotification: true),
      },
    );
    await _controller2!.reverse();
  }

  Future<void> onTapDeny(BuildContext context) async {
    // BlocProvider.of<GraphqlBloc>(context).add(
    //   UpdateNotificationStatusEvent(
    //     userName: Locator.instance.get<SharedPrefServices>().getUserName(),
    //     isNotificationOn: false,
    //   ),
    // );
    await HapticFeedback.vibrate();
    _controller2!.forward();
    Navigator.pushNamed(
      context,
      YourJourneyScreen.routeName,
      arguments: {
        'data': PreQuestionnaireInfoModel(isAllowNotification: false),
      },
    );
    _controller2!.reverse();
  }
}
