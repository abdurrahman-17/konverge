import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utilities/common_functions.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/loader.dart';
import 'reset_password_screen.dart';
import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../theme/app_style.dart';
import '../../../utilities/size_utils.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/custom_buttons.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = 'forgot';
  final TextEditingController otpFieldController = TextEditingController();

  ForgotPasswordScreen({
    super.key,
    required this.username,
  });

  final String username;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  DateTime? firstClickTime;
  bool otpFieldVisible = false;
  bool isLoading = false;
  bool isButtonDisabled = false;
  Timer? timer;

  @override
  void dispose() {
    timer!.cancel();
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
          case ForgotPasswordRequestSuccessState:
            setState(() {
              otpFieldVisible = true;
            });
            Navigator.pushNamed(
              context,
              ResetPasswordScreen.routeName,
              arguments: {
                'username': widget.username,
              },
            );
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
            body: contents(),
            appBar: CommonAppBar.appBar(context: context),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget contents() {
    return Container(
      height: size.height,
      padding: getPadding(left: 35, right: 35, bottom: 45),
      width: double.maxFinite,
      child: Stack(
        children: [
          phoneField(),
          if (isLoading) Loader(),
        ],
      ),
    );
  }

  Widget phoneField() {
    return Column(
      children: [
        Padding(
          padding: getPadding(top: 20),
          child: Align(
            alignment: Alignment.topLeft,
            child: CustomRichText(
              text: "Forgot your password?",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtPoppinsSemiBold20,
            ),
          ),
        ),
        Container(
          margin: getMargin(top: 10),
          child: CustomRichText(
            text:
                "Don't worry, it happens to the best of us. Just request your one time passcode below to reset your password.",
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsLight13,
          ),
        ),
        Padding(
          padding: getPadding(top: 24),
          child: Align(
            alignment: Alignment.topLeft,
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
        ),
        CustomButton(
          text: TitleString.sendOTP,
          enabled: !isButtonDisabled,
          onTap: () {
            if (!isButtonDisabled &&
                !isRedundantClick(firstClickTime, DateTime.now())) {
              setState(() {
                isLoading = true;
                isButtonDisabled = true;
                firstClickTime = DateTime.now();
              });
              BlocProvider.of<AuthenticationBloc>(context).add(
                ForgotPasswordSendOtpEvent(
                  phoneNumber: widget.username,
                ),
              );

              // Enable the button after one minute
              timer = Timer(Duration(minutes: 1), () {
                setState(() {
                  isButtonDisabled = false;
                });
              });
            } else {
              isRedundantClick(firstClickTime, DateTime.now());
            }
          },
          margin: getMargin(top: 33),
        ),
      ],
    );
  }
}
