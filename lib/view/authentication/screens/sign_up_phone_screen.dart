import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/locator.dart';
import '../../../services/api_requests/api_service.dart';
import '../../../utilities/transition/shake_widget.dart';
import '../../../utilities/transition_constant.dart';
import '../../../core/app_export.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/snack_bar.dart';
import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../models/amplify/sign_up_request.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../../utilities/validator.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/common_dialogs.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_textfield.dart';
import 'account_set_screen.dart';

class SignUpPhoneScreen extends StatefulWidget {
  static const String routeName = '/signUpPhoneInfo';

  SignUpPhoneScreen({
    super.key,
    this.signUpRequestModel,
  });

  final SignUpRequestModel? signUpRequestModel;

  @override
  State<SignUpPhoneScreen> createState() => _SignUpPhoneScreenState();
}

class _SignUpPhoneScreenState extends State<SignUpPhoneScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();
  final shakeKey = GlobalKey<ShakeWidgetState>();
  CountryCode countryCode = CountryCode(dialCode: "+44");
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpEditorController = TextEditingController();
  bool otpFieldVisible = false;
  int lastOtpSendTime = 0;
  Animation<double>? animation;
  AnimationController? animationController;
  bool isLoading = false;
  bool filled = false;
  bool invalidOtp = false;
  final FocusNode _focusPhoneNumber = FocusNode();
  late int cursorPositionPhoneNumber = 0;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration: Duration(
            milliseconds: TransitionConstant.signUpPhoneTransitionDuration));
    animation = Tween<double>(begin: 0.0, end: getHorizontalSize(176))
        .animate(animationController!)
      ..addListener(() {
        setState(() {});
      });
    _focusPhoneNumber.addListener(() {
      if (!_focusPhoneNumber.hasFocus) {
        cursorPositionPhoneNumber = phoneNumberController.selection.base.offset;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonBackground,
        CommonBgLogo(
          opacity: 0.6,
          position: CommonBgLogoPosition.topCenter,
        ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: contents(context),
          appBar: CommonAppBar.appBar(context: context),
          // onPressed:()
          // {
          //   if(otpFieldVisible)
          //     {
          //       setState(() {
          //         otpFieldVisible=false;
          //       });
          //     }
          //   else{
          //     Navigator.pop(context);
          //   }
          //
          // }),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget contents(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: height.toDouble() - getVerticalSize(70),
        padding: getPadding(left: 34, right: 34, bottom: 45),
        width: double.maxFinite,
        child: Stack(
          children: [
            phoneFiled(),
            if (otpFieldVisible)
              AnimatedBuilder(
                animation: animation!,
                builder: (context, child) {
                  return Transform.translate(
                    offset:
                        Offset(getHorizontalSize(176) - animation!.value, 0),
                    child: otpField(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget phoneFiled() {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, state) {
        setState(() {
          isLoading = false;
        });
        switch (state.runtimeType) {
          case LoginLoadingState:
            {
              /*SignUp with aws successful. Need to verify phone number.
                Show enter otp verification section.*/
              setState(() {
                isLoading = true;
              });
              break;
            }
          case SignUpSuccessfulState:
            {
              /*SignUp with aws successful. Need to verify phone number.
                Show enter otp verification section.*/
              if (widget.signUpRequestModel != null) {
                setState(() {
                  otpFieldVisible = true;
                  animationController!.forward();
                  lastOtpSendTime = DateTime.now().millisecondsSinceEpoch;
                });
              }
              break;
            }

          case LoginErrorState:
            /* unexpected error. show dialog message to the user*/
            showInfo(
              context,
              content: (state as LoginErrorState).errorMessage,
              buttonLabel: TitleString.btnOkay,
            );
            break;
          case ResendSignUpOtpSuccess:
            /* unexpected error. show dialog message to the user*/
            showInfo(
              context,
              content: "OTP sent successfully",
              buttonLabel: TitleString.btnOkay,
            );
            lastOtpSendTime = DateTime.now().millisecondsSinceEpoch;
            break;
          case ResendSignUpOtpFailed:
            /* unexpected error. show dialog message to the user*/
            showInfo(
              context,
              content:
                  "OTP send failed.\n${(state as ResendSignUpOtpFailed).errorMessage}",
              buttonLabel: TitleString.btnOkay,
            );
            break;
          case OtpVerificationSuccess:
            /*Otp verification while signUp has been completed.
              * go to data collection screens.*/
            BlocProvider.of<AuthenticationBloc>(context).add(
              SignInWithPhoneAndPasswordEvent(
                phoneNumber: (state as OtpVerificationSuccess).userName,
                password: widget.signUpRequestModel!.password,
              ),
            );

            break;
          case LoginSuccessState:
            Navigator.pushNamedAndRemoveUntil(context,
                AccountSetScreen.routeName, (Route<dynamic> route) => false);
            break;
          case OtpVerificationFailed:
            /*Entered otp is not valid, inform user and ask to retry.*/
            setState(() {
              invalidOtp = true;
            });
            shakeKey.currentState!.shake();
            showInfo(context,
                content: TitleString.invalidOtp,
                buttonLabel: TitleString.btnOkay, onTap: () {
              otpEditorController.clear();
              Navigator.pop(context);
              setState(() {
                invalidOtp = true;
              });
            });
            break;
          default:
            print("On phone fields Unknown state while logging in: $state");
        }
      },
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomRichText(
                    text: TitleString.phoneNumber,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsSemiBold20,
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  margin: getMargin(top: 13),
                  child: CustomRichText(
                    text: TitleString.phoneNumberInfo,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsLight13,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: getPadding(top: 29),
                    child: CustomRichText(
                      text: TitleString.phoneNumberSmall,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsMedium14,
                    ),
                  ),
                ),
                CustomTextFormField(
                  focusNode: _focusPhoneNumber,
                  controller: phoneNumberController,
                  hintText: TitleString.enterYourPhoneNumberHint,
                  margin: getMargin(top: 11),
                  onCountryChanged: (value) {
                    countryCode = value;
                  },
                  variant: TextFormFieldVariant.outlineBlack90035,
                  textInputType: TextInputType.phone,
                  fontStyle: TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                  hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                  validator: (userName) =>
                      Validation.mobileNumberValidation(userName),
                  isEnabled: !otpFieldVisible,
                ),
                CustomButton(
                  // height: getVerticalSize(47),
                  text: TitleString.verify,
                  onTap: () async {
                    if (_formKey.currentState!.validate() && !otpFieldVisible) {
                      setState(() {
                        isLoading = true;
                      });
                      bool? isPhoneNumberUnique = await Locator.instance
                          .get<ApiService>()
                          .checkPhoneNumberExists(
                            phoneNumber: countryCode.toString() +
                                phoneNumberController.text,
                          );
                      setState(() {
                        isLoading = false;
                      });
                      if (isPhoneNumberUnique &&
                          widget.signUpRequestModel != null) {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          SignUpWithPhoneAndPasswordEvent(
                            signUpRequest: widget.signUpRequestModel!,
                            phoneNumber: countryCode.toString() +
                                phoneNumberController.text.toString(),
                          ),
                        );
                      }
                    }
                  },
                  enabled: !otpFieldVisible,
                  margin: getMargin(top: 25),
                ),
                if (otpFieldVisible)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: getPadding(top: 22),
                      child: InkWell(
                        child: CustomRichText(
                          text: TitleString.resendVerificationCode,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsLight15,
                        ),
                        onTap: () {
                          if (isDelayCompletedForResendOtp(lastOtpSendTime)) {
                            BlocProvider.of<AuthenticationBloc>(context).add(
                              ResendSignUpOtpEvent(
                                phoneNumber: countryCode.toString() +
                                    phoneNumberController.text.toString(),
                              ),
                            );
                          } else {
                            showSnackBar(
                              message:
                                  "Please retry after ${getDelayTimeForResendOtp(lastOtpSendTime)} second",
                            );
                          }
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isLoading) const Positioned(child: Loader())
        ],
      ),
    );
  }

  Widget otpField() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: getVerticalSize(221),
        width: double.maxFinite,
        child: Stack(
          children: [
            Form(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomRichText(
                      text: TitleString.enterYourCode,
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
                              TransitionConstant.otpShakeTransitionDuration),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: otpEditorController,
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
                          errorBorderColor: AppColors.red300,
                          activeColor: invalidOtp
                              ? AppColors.red300
                              : filled
                                  ? AppColors.tealA400
                                  : AppColors.red300,
                        ),
                      ),
                    ),
                  ),
                  CustomButton(
                    onTap: () {
                      if (!filled) return;
                      if (otpEditorController.text.length >= 6) {
                        if (!isLoading)
                          BlocProvider.of<AuthenticationBloc>(context).add(
                            VerifyOtpEvent(
                              phoneNumber: countryCode.toString() +
                                  phoneNumberController.text.toString(),
                              otp: otpEditorController.text.toString(),
                            ),
                          );
                      } else {
                        _formKey.currentState!.validate();
                        _otpFormKey.currentState!.validate();
                        showInfo(
                          context,
                          content: "Invalid otp, Enter 6 digits",
                          buttonLabel: TitleString.btnOkay,
                        );
                      }
                    },
                    // height: getVerticalSize(47),
                    text: TitleString.btnContinue,
                    enabled: filled,
                    margin: getMargin(top: 24, bottom: 24),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
