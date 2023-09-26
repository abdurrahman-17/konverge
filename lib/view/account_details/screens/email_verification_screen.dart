import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/locator.dart';
import '../../../repository/user_repository.dart';
import '../../../utilities/transition/shake_widget.dart';
import '../../../utilities/transition_constant.dart';
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
import '../../common_widgets/loader.dart';
import '../../common_widgets/snack_bar.dart';

class VerifyEmailScreen extends StatefulWidget {
  static const String routeName = 'VerifyEmailScreen';
  final TextEditingController otpFieldController = TextEditingController();

  VerifyEmailScreen({
    super.key,
    required this.emailId,
  });

  final String emailId;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen>
    with TickerProviderStateMixin {
  TextEditingController otpFieldController = TextEditingController();
  final shakeKey = GlobalKey<ShakeWidgetState>();
  int lastOtpSendTime = 0;
  bool invalidOtp = false;
  Animation<double>? animation;
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: TransitionConstant.signUpPhoneTransitionDuration,
      ),
    );
    animation = Tween<double>(begin: 0.0, end: getHorizontalSize(176))
        .animate(animationController!)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, state) {
        setState(() {
          isLoading = false;
        });
        switch (state.runtimeType) {
          case LoginLoadingState:
            setState(() {
              isLoading = true;
            });
            break;
          case EmailOtpVerificationTriggerFailed:
            state as EmailOtpVerificationTriggerFailed;
            showInfo(context,
                content: state.message, buttonLabel: TitleString.btnOk);
            otpFieldVisible = false;

            break;
          case EmailOtpVerificationTriggerSuccess:
            otpFieldVisible = true;
            animationController!.forward();
            state as EmailOtpVerificationTriggerSuccess;
            if (state.isResendOTP)
              showInfo(
                context,
                content: "OTP sent successfully",
                buttonLabel: TitleString.btnOkay,
              );
            lastOtpSendTime = DateTime.now().millisecondsSinceEpoch;
            break;
          case EmailOtpValidationFailed:
            state as EmailOtpValidationFailed;
            setState(() {
              shakeKey.currentState!.shake();
              invalidOtp = true;
            });
            showInfo(context,
                content: state.message,
                buttonLabel: TitleString.btnOk, onTap: () {
              Navigator.pop(context);
              otpFieldController.clear();
              setState(() {
                invalidOtp = true;
              });
            });
            break;
          case EmailOtpValidationSuccess:
            state as EmailOtpValidationSuccess;
            showInfo(
              context,
              content: state
                  .message /*TitleString.messageEmailIdVerificationSuccess*/,
              buttonLabel: TitleString.btnOk,
              onTap: () {
                var user =
                    Locator.instance.get<UserRepo>().getCurrentUserData();
                user?.isEmailVerified = true;
                Locator.instance.get<UserRepo>().setCurrentUserData(user);
                Navigator.pop(context, true);
                Navigator.pop(context, true);
              },
            );
            break;
          default:
            print(
                "On email verification screen Unknown state while logging in: $state");
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
        child: Stack(
          children: [
            phoneField(),
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
            child: Text(
              "Verify Email Address",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtPoppinsSemiBold20,
            ),
          ),
        ),
        Container(
          width: getHorizontalSize(305),
          margin: getMargin(top: 10),
          child: Text(
            "An OTP will be sent to your email id. Please enter the OTP to verify your email address.",
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsLight13,
          ),
        ),
        Padding(
          padding: getPadding(top: 24),
          child: Text(
            widget.emailId.toString(),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsMedium15,
          ),
        ),
        CustomButton(
          text: TitleString.sendOTP,
          enabled: otpFieldVisible == false,
          onTap: () {
            if (otpFieldVisible) return;
            BlocProvider.of<AuthenticationBloc>(context).add(
              StartEmailVerificationEvent(
                email: widget.emailId,
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
                child: Text(
                  TitleString.resend,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtPoppinsLight15,
                ),
                onTap: () {
                  if (isDelayCompletedForResendOtp(lastOtpSendTime)) {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      StartEmailVerificationEvent(
                          email: widget.emailId, isResendOtp: true),
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
                    child: Text(
                      TitleString.enterYourCode,
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
                        controller: otpFieldController,
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
                  CustomButton(
                    onTap: () {
                      if (!filled) return;
                      if (otpFieldController.text.length >= 6) {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          StartEmailOtpVerificationEvent(
                            otp: otpFieldController.text.toString(),
                          ),
                        );
                      } else {
                        showInfo(
                          context,
                          content: "Invalid otp, Enter 6 digits",
                          buttonLabel: TitleString.btnOkay,
                        );
                      }
                    },
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
