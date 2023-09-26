import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../utilities/date_utils.dart';
import '../../../utilities/transition/shake_widget.dart';
import '../../../utilities/transition_constant.dart';
import '../../common_widgets/common_dialogs.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/snack_bar.dart';
import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../theme/app_style.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/size_utils.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../../utilities/validator.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_textfield.dart';
import 'get_started_screen.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String routeName = 'reset';

  ResetPasswordScreen({
    super.key,
    required this.username,
  });

  final String username;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController otpFieldController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final shakeKey = GlobalKey<ShakeWidgetState>();
  bool isLoading = false;
  bool filled = false;
  bool invalidOtp = false;
  int lastOtpSendTime = 0;
  final FocusNode _focusPasswordText = FocusNode();
  late int cursorPositionPassword = 0;

  @override
  void initState() {
    super.initState();
    lastOtpSendTime = DateTime.now().millisecondsSinceEpoch;
    _focusPasswordText.addListener(() {
      if (!_focusPasswordText.hasFocus) {
        cursorPositionPassword = passwordController.selection.base.offset;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        setState(() {
          isLoading = false;
        });

        switch (state.runtimeType) {
          case LoginLoadingState:
            setState(() {
              isLoading = true;
            });
            break;
          case ResetPasswordSuccessState:
            showInfo(
              context,
              content: TitleString.warningResetPasswordSuccess,
              buttonLabel: TitleString.btnOkay,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  GetStartedScreen.routeName,
                  (Route<dynamic> route) => false,
                );
                Navigator.pushNamed(
                  context,
                  LoginScreen.routeName,
                );
              },
            );
            break;
          case ResetPasswordOtpFailureState:
            setState(() {
              shakeKey.currentState!.shake();
              invalidOtp = true;
            });
            showInfo(
              context,
              title: "Alert",
              content: (state as ResetPasswordOtpFailureState).errorMessage,
              buttonLabel: "Ok",
              onTap: () {
                Navigator.pop(context);
                otpFieldController.clear();
                setState(() {
                  invalidOtp = true;
                });
              },
            );
            break;
          case ForgotPasswordResendRequestSuccessState:
            showInfo(
              context,
              content: "OTP sent successfully",
              buttonLabel: TitleString.btnOkay,
            );
            lastOtpSendTime = DateTime.now().millisecondsSinceEpoch;
            break;
          default:
            print("Unknown state while logging in: $state");
        }
      },
      child: Stack(
        children: [
          commonBackground,
          CommonBgLogo(
            opacity: 0.6,
          ),
          Scaffold(
            resizeToAvoidBottomInset: true,
            body: contents(context),
            appBar: CommonAppBar.appBar(context: context),
            backgroundColor: Colors.transparent,
          ),
          if (isLoading)
            const Positioned(
              child: Loader(),
            )
        ],
      ),
    );
  }

  // ButtonNotifier? buttonEnabled;
  Widget contents(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Form(
        key: _formKey,
        child: SizedBox(
          height: getVerticalSize(999),
          width: double.maxFinite,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Container(
                    padding: getPadding(
                      left: 35,
                      top: 5,
                      right: 35,
                      bottom: 27,
                    ),
                    height: size.height - getVerticalSize(127),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: CustomButton(
                            enabled: true, // value check
                            onTap: () {
                              if (isLoading) {
                                showSnackBar(
                                  message: TitleString.warningAlreadyLoading,
                                );
                              }

                              if (otpFieldController.text.isEmpty ||
                                  otpFieldController.text.length != 6) {
                                showInfo(
                                  context,
                                  content: TitleString.otpFieldIncomplete,
                                  buttonLabel: TitleString.btnOkay,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                );
                              } else if (_formKey.currentState!.validate()) {
                                log("OTP_Length:  ${otpFieldController.text.length}");
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(
                                  ResetPasswordEvent(
                                    userName: widget.username,
                                    confirmationCode: otpFieldController.text,
                                    newPassword: passwordController.text,
                                  ),
                                );
                              }
                            },
                            // height: getVerticalSize(47),
                            text: TitleString.reset,
                            margin: getMargin(top: 20),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: getPadding(top: 20),
                                child: CustomRichText(
                                  text: "Reset Password",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtPoppinsSemiBold20,
                                ),
                              ),
                              Padding(
                                padding: getPadding(top: 20),
                                child: otpField(context),
                              ),
                              Container(
                                width: getHorizontalSize(274),
                                margin: getMargin(top: 12, right: 30),
                                child: CustomRichText(
                                  text: TitleString.passwordInfo,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtPoppinsLight13,
                                ),
                              ),
                              Padding(
                                padding: getPadding(top: 20),
                                child: CustomRichText(
                                  text: "New Password",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtPoppinsMedium14,
                                ),
                              ),
                              CustomTextFormField(
                                focusNode: _focusPasswordText,
                                controller: passwordController,
                                hintText: TitleString.password,
                                margin: getMargin(top: 16),
                                textInputAction: TextInputAction.done,
                                textInputType: TextInputType.visiblePassword,
                                variant: TextFormFieldVariant.outlineBlack90035,
                                fontStyle: TextFormFieldFontStyle
                                    .poppinsMedium14WhiteA700,
                                hintStyle:
                                    TextFormFieldFontStyle.poppinsMedium14,
                                isObscureText: true,
                                validator: (password) =>
                                    Validation.passwordValidation(password),
                                onChanged: (value) {
                                  if (value.contains(' ')) {
                                    // Remove any spaces from the entered text
                                    passwordController.text =
                                        value.replaceAll(' ', '');
                                    // Move the cursor to the end of the text
                                    passwordController.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                        offset: passwordController.text.length,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget otpField(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: getVerticalSize(230),
        width: double.maxFinite,
        child: Stack(
          children: [
            Form(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: CustomRichText(
                      text: "Enter your code",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsMedium14,
                    ),
                  ),
                  Padding(
                    padding: getPadding(top: 9),
                    child: ShakeWidget(
                      key: shakeKey,
                      shakeCount: 5,
                      shakeOffset: 10,
                      shakeDuration: Duration(
                        milliseconds:
                            TransitionConstant.otpShakeTransitionDuration,
                      ),
                      child: PinCodeTextField(
                        controller: otpFieldController,
                        appContext: context,
                        length: 6,
                        obscuringCharacter: '*',
                        keyboardType: TextInputType.number,
                        enableActiveFill: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          bool fillValue = false;
                          if (value.length == 6) {
                            fillValue = true;
                          }

                          if (fillValue != filled) {
                            setState(() {
                              invalidOtp = false;
                              filled = fillValue;
                            });
                          }
                        },
                        textStyle: TextStyle(
                          color: AppColors.whiteA700,
                          fontSize: getFontSize(16),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        pinTheme: PinTheme(
                          fieldHeight: getHorizontalSize(47),
                          fieldWidth: getHorizontalSize(47),
                          shape: PinCodeFieldShape.circle,
                          selectedFillColor: AppColors.blueGray10033,
                          activeFillColor: AppColors.blueGray10033,
                          inactiveFillColor: AppColors.blueGray10033,
                          inactiveColor: invalidOtp
                              ? AppColors.red300
                              : Colors.transparent,
                          selectedColor: Colors.transparent,
                          activeColor: invalidOtp
                              ? AppColors.red300
                              : filled
                                  ? AppColors.tealA400
                                  : AppColors.red300,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        if (isDelayCompletedForResendOtp(lastOtpSendTime)) {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                            ForgotPasswordSendOtpEvent(
                              phoneNumber: widget.username,
                              isResendOTP: true,
                            ),
                          );
                        } else {
                          showSnackBar(
                            message:
                                "Please retry after ${getDelayTimeForResendOtp(lastOtpSendTime)} second",
                          );
                        }
                      },
                      child: CustomRichText(
                        text: TitleString.resend,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtPoppinsLight15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
