import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/search_user/search_user_bloc.dart';
import '../../../core/locator.dart';
import '../../../repository/user_repository.dart';
import '../../../utilities/common_functions.dart';
import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../theme/app_style.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/size_utils.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/snack_bar.dart';
import 'get_started_screen.dart';

// ignore: must_be_immutable
class LogoutConfirmationScreen extends StatefulWidget {
  static const String routeName = 'logout';
  bool signOutApi = true;
  TextEditingController otpFieldController = TextEditingController();

  LogoutConfirmationScreen({super.key, required this.signOutApi});

  @override
  State<LogoutConfirmationScreen> createState() => _LogoutConfirmationScreen();
}

class _LogoutConfirmationScreen extends State<LogoutConfirmationScreen> {
  void setLoading(bool value) {
    value ? progressDialogue() : Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is SignOutState && !widget.signOutApi) {
          if (state.signOutStatus == ApiStatus.success) {
            setLoading(false);
            Navigator.pushNamedAndRemoveUntil(
              context,
              GetStartedScreen.routeName,
              (Route<dynamic> route) => false,
            );
          } else if (state.signOutStatus == ApiStatus.error) {
            setLoading(false);
            showSnackBar(message: "Logout failed");
          } else {
            setLoading(true);
          }
        }

        switch (state.runtimeType) {
          // case LoginLoadingState:
          //   setState(() {
          //     isLoading = true;
          //   });
          //   break;
          // case ForgotPasswordRequestSuccessState:
          //   /*setState(() {
          //     otpFieldVisible = true;
          //   });*/
          //   Navigator.pushNamed(context, ResetPasswordScreen.routeName,
          //       arguments: {'username': widget.username});
          //   break;
          default:
            print("Unknown state while logging in: $state");
        }
      },
      child: Stack(
        children: [
          Container(
            decoration: profileGradientBg, //commonGradientBg,
            width: double.infinity,
            height: double.infinity,
          ),
          Scaffold(
            body: Center(child: logoutConfirmation()),
          ),
        ],
      ),
    );
  }

  // bool otpFieldVisible = false;
  // bool isLoading = false;

  Widget logoutConfirmation() {
    return Container(
      decoration: profileGradientBg,
      height: size.height,
      padding: getPadding(left: 35, right: 35, bottom: 45),
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: double.maxFinite,
                height: getVerticalSize(280),
                decoration: BoxDecoration(
                  color: Color.fromARGB(136, 0, 0, 0),
                  borderRadius: BorderRadius.circular(33.0),
                ),
                child: Padding(
                  padding: getPadding(left: 25, right: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomRichText(
                        text: 'Logout?',
                        style: AppStyle.txtPoppinsBold17,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      CustomRichText(
                        text: TitleString.logout_confirmation,
                        style: AppStyle.txtPoppinsItalic14,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomButton(
            text: TitleString.confirm,
            enabled: true,
            onTap: () async {
              BlocProvider.of<SearchUserBloc>(context).add(
                DeleteRecentSearchListEvent(),
              );
              BlocProvider.of<AuthenticationBloc>(context).add(SignOutEvent());
              final activeUser =
                  Locator.instance.get<UserRepo>().getCurrentUserData();
              if (activeUser != null && activeUser.userId != null)
                deletePlayerId(context, activeUser.userId!);
              await Navigator.pushNamed(
                context,
                LogoutConfirmationScreen.routeName,
              );
              //fetchData();
            },
            margin: getMargin(top: 33, bottom: 16),
          ),
          CustomButton(
            text: TitleString.cancel,
            variant: ButtonVariant.outlineTealA400,
            fontStyle: ButtonFontStyle.poppinsRegular15WhiteA400,
            enabled: true,
            onTap: () {
              Navigator.of(context).pop();
            },
            margin: getMargin(top: 10, bottom: 16),
          ),
        ],
      ),
    );
  }
}
