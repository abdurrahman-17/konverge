import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utilities/common_functions.dart';
import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../core/configurations.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/app_style.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/common_navigation_logics.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/size_utils.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../../utilities/validator.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_dialogs.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_logo.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/custom_textfield.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/snack_bar.dart';
import '../widgets/carousel_slide_view.dart';
import 'forgot_password_screen.dart';
import 'verify_phone_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  CountryCode countryCode = CountryCode(dialCode: "+44");

  final FocusNode _focusPhoneNumber = FocusNode();
  final FocusNode _focusPassword = FocusNode();

  // ignore: unused_field
  late int _cursorPositionLogin = 0;

  // ignore: unused_field
  late int _cursorPositionPassword = 0;

  var selectedCountry = "GB";
  TextEditingController passwordOneController = TextEditingController();
  TextEditingController phoneNumberOneController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusPhoneNumber.addListener(() {
      if (!_focusPhoneNumber.hasFocus) {
        _cursorPositionLogin = phoneNumberOneController.selection.base.offset;
      }
    });

    _focusPassword.addListener(() {
      if (!_focusPassword.hasFocus) {
        _cursorPositionPassword = passwordOneController.selection.base.offset;
      }
    });
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
          Container(
            //decoration: commonGradientBg,
            width: double.infinity,
            height: double.infinity,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: contents(context),
              appBar: CommonAppBar.appBar(context: context),
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget contents(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (BuildContext context, state) {
        setState(() {
          isLoading = false;
        });
        switch (state.runtimeType) {
          case UserLastLoginTimeUpdateState:
            setState(() {
              isLoading = true;
              readStageOfLoggedInUserAndNavigate(context);
            });
            break;
        }
      },
      child: BlocListener<GraphqlBloc, GraphqlState>(
        listener: (BuildContext context, state) {
          setState(() {
            isLoading = false;
          });
          switch (state.runtimeType) {
            case GraphqlErrorState:
              print("GraphqlErrorState");
              break;
            case QueryLoadingState:
              setState(() {
                isLoading = true;
              });
              break;
            case ReadUserSuccessState:
              /*BlocProvider.of<UserBloc>(context).add(
                const UserLastLoginTimeUpdateEvent(),
              );*/
              addPlayerId(context);

              break;
            default:
              print("Unknown state while graphql: $state");
          }
        },
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (BuildContext context, state) {
            setState(() {
              isLoading = false;
            });
            switch (state.runtimeType) {
              case LoginSuccessState:
                BlocProvider.of<GraphqlBloc>(context).add(
                  const ReadLoggedInUserInfoEvent(),
                );
                break;
              case ReadUserSuccessState:
                readStageOfLoggedInUserAndNavigate(context);
                break;
              case LoginConfirmAccountState:
                /*username and password auth successful,
                but user has not verified his phone number.
                So navigate to phone number verification screen.*/
                showInfo(
                  context,
                  content: (state as LoginConfirmAccountState).warning!,
                  buttonLabel: TitleString.btnOk,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      VerifyPhoneScreen.routeName,
                      arguments: {
                        'username': (state).userName,
                      },
                    );
                  },
                );

                break;
              case ForgotPasswordRequestSuccessState:
                /*Phone number identified on phone*/
                /*Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName,
                    arguments: {
                      'username':
                      countryCode.dialCode.toString()+phoneNumberOneController.text.toString()
                    });*/
                break;
              case LoginLoadingState:
                //show loading widget.
                setState(() {
                  isLoading = true;
                });
                break;
              case LoginErrorState:
                /* unexpected error while logging in show dialog
                message to the user*/

                showInfo(
                  context,
                  title: "Alert",
                  content: (state as LoginErrorState).errorMessage,
                  buttonLabel: "Ok",
                  onTap: () {
                    Navigator.pop(context);
                  },
                );
                break;
              case ValidatedState:
                isEnabled = (state as ValidatedState).isValid;
                break;
              default:
                print("Unknown state while logging in: $state");
            }
          },
          child: Stack(
            children: [
              Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: getVerticalSize(
                      745 +
                          MediaQuery.of(context).viewPadding.bottom +
                          (Platform.isAndroid ? 20 : 0),
                    ),
                    width: double.maxFinite,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: getPadding(top: 30),
                            child: Column(
                              children: [
                                CustomLogo(
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
                          child: Container(
                            padding: getPadding(
                              left: 35,
                              top: 35,
                              right: 35,
                              bottom: 35,
                            ),
                            decoration: AppDecoration.fillBlack9007c.copyWith(
                              borderRadius: BorderRadiusStyle.customBorderTL35,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomRichText(
                                  text: TitleString.phoneNumberSmall,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtPoppinsMedium14,
                                ),
                                CustomTextFormField(
                                  focusNode: _focusPhoneNumber,
                                  controller: phoneNumberOneController,
                                  hintText: TitleString.enterPhoneNumber,
                                  margin: getMargin(top: 11),
                                  variant:
                                      TextFormFieldVariant.outlineBlack90035,
                                  fontStyle: TextFormFieldFontStyle
                                      .poppinsMedium14WhiteA700,
                                  textInputAction: TextInputAction.next,
                                  hintStyle:
                                      TextFormFieldFontStyle.poppinsMedium14,
                                  textInputType: TextInputType.phone,
                                  onChanged: (value) {
                                    buttonEnabledChecking(context);
                                  },
                                  onCountryChanged: (value) {
                                    countryCode = value;
                                  },
                                  validator: (userName) =>
                                      Validation.mobileNumberValidation(
                                          userName),
                                ),
                                Padding(
                                  padding: getPadding(top: 20),
                                  child: CustomRichText(
                                    text: TitleString.password,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtPoppinsMedium14,
                                  ),
                                ),
                                CustomTextFormField(
                                  focusNode: _focusPassword,
                                  controller: passwordOneController,
                                  hintText: TitleString.enterPassword,
                                  margin: getMargin(top: 11),
                                  textInputAction: TextInputAction.done,
                                  variant:
                                      TextFormFieldVariant.outlineBlack90035,
                                  fontStyle: TextFormFieldFontStyle
                                      .poppinsMedium14WhiteA700,
                                  hintStyle:
                                      TextFormFieldFontStyle.poppinsMedium14,
                                  textInputType: TextInputType.visiblePassword,
                                  isObscureText: true,
                                  onChanged: (value) {
                                    if (value.contains(' ')) {
                                      // Remove any spaces from the entered text
                                      passwordOneController.text =
                                          value.replaceAll(' ', '');
                                      // Move the cursor to the end of the text
                                      passwordOneController.selection =
                                          TextSelection.fromPosition(
                                        TextPosition(
                                          offset:
                                              passwordOneController.text.length,
                                        ),
                                      );
                                    }
                                    // buttonEnabledChecking(context);
                                  },
                                  validator: (password) =>
                                      Validation.passwordValidation(
                                    password,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (isLoading) {
                                      showSnackBar(
                                        message: "Loading...",
                                      );
                                    }
                                    String? isValid =
                                        Validation.mobileNumberValidation(
                                      phoneNumberOneController.text,
                                    );
                                    if (isValid == null) {
                                      //need to check and make sure that user exists on our system.
                                      /*BlocProvider.of<AuthenticationBloc>(context)
                                        .add(ForgotPasswordSendOtpEvent(
                                      phoneNumber: countryCode.dialCode.toString()+phoneNumberOneController.text,
                                    ));*/
                                      Navigator.pushNamed(
                                        context,
                                        ForgotPasswordScreen.routeName,
                                        arguments: {
                                          'username':
                                              "${countryCode.dialCode}${phoneNumberOneController.text}",
                                        },
                                      );
                                    } else {
                                      HapticFeedback.vibrate();
                                      _focusPhoneNumber.requestFocus();
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      showSnackBar(
                                        duration: Duration(milliseconds: 1000),
                                        message:
                                            "Please enter valid phone number",
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: getPadding(top: 26),
                                    width: double.maxFinite,
                                    child: CustomRichText(
                                      text: TitleString.forgotPassword,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: AppStyle.txtPoppinsRegular14,
                                    ),
                                  ),
                                ),
                                CustomButton(
                                  text: TitleString.loginButtonName,
                                  margin: getMargin(top: 20),
                                  enabled: isEnabled,
                                  //variant: ButtonVariant.outlineBlack90035,
                                  onTap: () {
                                    /*CODE-YELLOW*/
                                    if (formKey.currentState!.validate()) {
                                      var phoneNumber =
                                          "${countryCode.dialCode}${phoneNumberOneController.text}";
                                      BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .add(
                                        SignInWithPhoneAndPasswordEvent(
                                          phoneNumber: phoneNumber,
                                          password: passwordOneController.text
                                              .toString(),
                                        ),
                                      );
                                    } else {
                                      print("vibrating");
                                      HapticFeedback.vibrate();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading)
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Loader(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapImgArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }

  bool isEnabled = true;

  void buttonEnabledChecking(BuildContext context) {
    // if (formKey.currentState!.validate()) {
    //   if (isEnabled != true) {
    //
    //     setState(() {
    //       isEnabled=true;
    //     });
    //   }
    // } else {
    //   if (isEnabled) {
    //     setState(() {
    //       isEnabled=false;
    //     });
    //   }
    // }
  }
}
