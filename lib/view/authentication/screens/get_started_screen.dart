import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../utilities/transition_constant.dart';
import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../services/shared_preference_service.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/common_navigation_logics.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/size_utils.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/app_style.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_logo.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/snack_bar.dart';
import '../widgets/carousel_slide_view.dart';
import '../widgets/tos_privacy_link.dart';
import 'login_screen.dart';
import 'sign_up_screen.dart';

class GetStartedScreen extends StatefulWidget {
  static const String routeName = '/get_started_screen';

  const GetStartedScreen({
    super.key,
  });

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with TickerProviderStateMixin {
  void seLoading(bool value) {
    value ? progressDialogue() : Navigator.pop(context);
  }

  Animation<double>? animation;
  AnimationController? animationController;

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: TransitionConstant.getStartedTransitionDuration),
    );

    animation = Tween<double>(begin: 0.0, end: -getVerticalSize(106))
        .animate(animationController!)
      ..addListener(() {
        setState(() {
          opacity = 1;
          // - (animationController!.value / 1.2);
          log("opacity $opacity");
        });
      });

    super.initState();
  }

  double opacity = 1;

  @override
  Widget build(BuildContext context) {
    print("factor ${getHorizontalSize(95)}");
    double factor1 = 1.5;
    double factor2 = 3.6;
    return BlocListener<GraphqlBloc, GraphqlState>(
      listener: (context, state) async {
        switch (state.runtimeType) {
          case ReadUserSuccessState:
            seLoading(false);
            CommonStaticValues.isAfterSignUp = true;
            readStageOfLoggedInUserAndNavigate(context);
            break;
          case QueryLoadingState:
            // seLoading(true);
            break;
          case GraphqlErrorState:
            log("GraphqlErrorState ${(state as GraphqlErrorState).errorMessage}");
            seLoading(false);
            showSnackBar(message: "Data fetching failed");
            FlutterError.onError = (details, {bool forceReport = true}) async {
              await Sentry.captureException(
                "GetStartedScreen -> Login -> GraphqlErrorState ${state.errorMessage}",
                stackTrace: details.stack,
              );
            };
            break;
          default:
            log("Unknown state while logging in: $state");
        }
      },
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          log("state:$state");

          if (state is LoginLoadingState &&
              state.loginType != LoginType.usernameAndPassword) {
            seLoading(true);
          } else if (state is LoginSuccessState &&
              state.loginType != LoginType.usernameAndPassword) {
            // seLoading(false);
            //setting login type to shared pref
            Locator.instance
                .get<SharedPrefServices>()
                .setLoginType(state.loginType);
            //check whether the user is already added data to db
            BlocProvider.of<GraphqlBloc>(context)
                .add(const ReadLoggedInUserInfoEvent());
          } else if (state is LoginErrorState &&
              state.loginType != LoginType.usernameAndPassword) {
            seLoading(false);
            // showSnackBar(message: state.errorMessage);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.black9004c,
          body: Stack(
            children: [
              commonBackground,
              Container(
                height: size.height,
                width: double.maxFinite,
                //decoration: commonGradientBg,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: getPadding(left: 95, top: 106, right: 95),
                        child: Column(
                          children: [
                            animation != null
                                ? AnimatedBuilder(
                                    animation: animation!,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(
                                            animation!.value * factor1,
                                            animation!.value),
                                        child: Opacity(
                                          opacity: opacity,
                                          child: CustomLogo(
                                            svgPath: Assets.logoSvg,
                                            height: getVerticalSize(103),
                                            width: getHorizontalSize(107),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : CustomLogo(
                                    svgPath: Assets.logoSvg,
                                    height: getVerticalSize(103),
                                    width: getHorizontalSize(107),
                                  ),
                            Padding(
                              padding: getPadding(top: 10),
                              child: Text(
                                Constants.appName.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtPoppinsExtraBoldItalic20,
                              ),
                            ),
                            CarouselSlideView(
                              sliderContent: TitleString.sliderContent,
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedBuilder(
                        animation: animation!,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -animation!.value * factor2),
                            child: Container(
                              padding: getPadding(
                                left: 35,
                                top: 31,
                                right: 35,
                                bottom: 31,
                              ),
                              height: getVerticalSize(395),
                              decoration: AppDecoration.fillBlack9007c.copyWith(
                                borderRadius:
                                    BorderRadiusStyle.customBorderLR62,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomButton(
                                    onTap: () async {
                                      animationController!.forward();
                                      await Navigator.pushNamed(
                                        context,
                                        SignUpScreen.routeName,
                                      );
                                      animationController!.reverse();
                                      // animationController!.reset();
                                    },
                                    enabled: true,
                                    text: TitleString.getStarted,
                                    variant: ButtonVariant.outlineBlack90035,
                                  ),
                                  Container(
                                    margin: getPadding(top: 12),
                                    child: CustomRichText(
                                      text: TitleString.or,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtPoppinsLight12,
                                    ),
                                  ),
                                  Container(
                                    margin: getPadding(bottom: 10),
                                    child: CustomRichText(
                                      text: TitleString.signUpFaster,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtPoppinsMedium14,
                                    ),
                                  ),

                                  ///APPLE SIGN-IN
                                  CustomButton(
                                    onTap: () {
                                      BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .add(SignInWithAppleEvent());
                                    },
                                    mainAxis: MainAxisAlignment.start,
                                    text: TitleString.signUpWithApple,
                                    margin: getMargin(top: 7),
                                    variant: ButtonVariant.fillWhiteA700,
                                    padding: ButtonPadding.paddingH20,
                                    fontStyle: ButtonFontStyle.poppinsMedium16,
                                    isVisible: !Platform.isAndroid,
                                    prefixWidget: Container(
                                      margin: getMargin(right: 20),
                                      child: CustomLogo(
                                        svgPath: Assets.imgApple,
                                        width: getHorizontalSize(19),
                                        height: getVerticalSize(28),
                                      ),
                                    ),
                                  ),

                                  ///GOOGLE SIGN-IN
                                  CustomButton(
                                    onTap: () async {
                                      BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .add(SignInWithGoogleEvent());
                                    },
                                    mainAxis: MainAxisAlignment.start,
                                    // height: getVerticalSize(47),
                                    text: TitleString.signUpWithGoogle,
                                    margin: getMargin(top: 14),
                                    variant: ButtonVariant.fillWhiteA700,
                                    padding: ButtonPadding.paddingH20,
                                    fontStyle: ButtonFontStyle.poppinsMedium16,
                                    prefixWidget: Container(
                                      margin: getMargin(right: 20),
                                      child: CustomLogo(
                                        svgPath: Assets.imgGoogle,
                                        width: getHorizontalSize(19),
                                        height: getVerticalSize(28),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      animationController!.forward();
                                      await Navigator.pushNamed(
                                        context,
                                        LoginScreen.routeName,
                                      );
                                      animationController!.reverse();
                                    },
                                    child: Container(
                                      margin: getPadding(top: 22),
                                      child: CustomRichText(
                                        text: TitleString.iAlreadyHaveAnAccount,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtPoppinsRegular14,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  const TOSPrivacyLink(),
                                  // if (!Platform.isIOS)
                                  //   SizedBox(height: getVerticalSize(20)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
