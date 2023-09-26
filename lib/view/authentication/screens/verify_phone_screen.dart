import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../common_widgets/custom_rich_text.dart';
import 'account_set_screen.dart';
import '../../common_widgets/loader.dart';
import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../theme/app_style.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/date_utils.dart';
import '../../../utilities/size_utils.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/common_dialogs.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/snack_bar.dart';

class VerifyPhoneScreen extends StatefulWidget {
  static const String routeName = 'verify_phone';
  final TextEditingController otpFieldController = TextEditingController();

  VerifyPhoneScreen({
    super.key,
    required this.username,
  });

  final String username;

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  TextEditingController otpFieldController = TextEditingController();
  int lastOtpSendTime = 0;

  @override
  Widget build(BuildContext context) {
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
            setState(() {
              otpFieldVisible = true;
            });
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
            /*BlocProvider.of<AuthenticationBloc>(context).add(
              SignInWithPhoneAndPasswordEvent(
                phoneNumber: (state as OtpVerificationSuccess).userName,
                password: widget.signUpRequestModel!.password,
              ),
            );*/
            showInfo(
              context,
              content:
                  "Phone number verification success. Please go back and sign in again",
              buttonLabel: TitleString.btnOkay,
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
            setState(() {
              otpFieldVisible = true;
            });
            break;
          case LoginSuccessState:
            Navigator.pushNamedAndRemoveUntil(context,
                AccountSetScreen.routeName, (Route<dynamic> route) => false);
            break;
          case OtpVerificationFailed:
            /*Entered otp is not valid, inform user and ask to retry.*/
            otpFieldController.clear();
            showInfo(
              context,
              content: TitleString.invalidOtp,
              buttonLabel: TitleString.btnOkay,
            );
            break;
          default:
            print("On phone fields Unknown state while logging in: $state");
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
            body: Stack(
              children: [
                contents(),
                if (isLoading) const Loader(),
              ],
            ),
            appBar: CommonAppBar.appBar(context: context),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget contents() {
    return SingleChildScrollView(
      child: Container(
        height: size.height - getVerticalSize(110),
        padding: getPadding(left: 35, right: 35, bottom: 45),
        width: double.maxFinite,
        child: Stack(children: [phoneField(), if (otpFieldVisible) otpField()]),
      ),
    );
  }

  bool otpFieldVisible = false;
  bool isLoading = false;

  Widget phoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: getPadding(top: 20),
          child: Align(
            alignment: Alignment.topLeft,
            child: CustomRichText(
              text: "Verify Phone Number",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtPoppinsSemiBold20,
            ),
          ),
        ),
        Container(
          width: getHorizontalSize(305),
          margin: getMargin(top: 10),
          child: CustomRichText(
            text:
                "Phone number verification is not completed while you signed up. Please verify your number.",
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsLight13,
          ),
        ),
        Padding(
          padding: getPadding(top: 24),
          child: CustomRichText(
            text: widget.username.replaceRange(
              6,
              widget.username.length - 2,
              '*' * (widget.username.length - 8),
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsMedium15,
          ),
        ),
        CustomButton(
          text: TitleString.sendOTP,
          enabled: otpFieldVisible == false,
          onTap: () {
            BlocProvider.of<AuthenticationBloc>(context).add(
              ResendSignUpOtpEvent(
                phoneNumber: widget.username,
              ),
            );
          },
          margin: getMargin(top: 33),
        ),
        if (otpFieldVisible)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: getPadding(top: 22),
              child: InkWell(
                child: CustomRichText(
                  text: TitleString.resend,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtPoppinsLight15,
                ),
                onTap: () {
                  if (isDelayCompletedForResendOtp(lastOtpSendTime)) {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      ResendSignUpOtpEvent(
                        phoneNumber: widget.username,
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
    );
  }

  bool filled = false;

  Widget otpField() {
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
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: otpFieldController,
                      obscuringCharacter: '*',
                      keyboardType: TextInputType.number,
                      enableActiveFill: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        bool fillValue = false;
                        if (value.length == 6) {
                          fillValue = true;
                        }

                        if (fillValue != filled) {
                          setState(() {
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
                        inactiveColor: Colors.transparent,
                        selectedColor: Colors.transparent,
                        activeColor:
                            filled ? AppColors.tealA400 : AppColors.red300,
                      ),
                    ),
                  ),
                  CustomButton(
                    onTap: () {
                      if (!filled) return;
                      if (otpFieldController.text.length >= 6) {
                        // if (isLoading)return;//disabling multiple click
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(VerifyOtpEvent(
                          phoneNumber: widget.username,
                          otp: otpFieldController.text.toString(),
                        ));
                      } else {
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
