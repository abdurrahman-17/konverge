import 'package:flutter/material.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../repository/user_repository.dart';
import '../../../services/amplify/amplify_service.dart';
import '../../../services/shared_preference_service.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/snack_bar.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../core/app_export.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/title_string.dart';
import '../../authentication/screens/get_started_screen.dart';
import '../../common_widgets/custom_buttons.dart';

class ConfirmDeletionScreen extends StatelessWidget {
  static const String routeName = 'confirm_delete_account';

  ConfirmDeletionScreen({super.key});

  final currentUser = Locator.instance.get<UserRepo>().getCurrentUserData();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) async {
        if (state is DeleteUserAccountState) {
          if (state.userDeleteStatus == ApiStatus.success) {
            Locator.instance.get<SharedPrefServices>().clearSharedPref();
            await AmplifyService().signOut();
            Navigator.pushNamedAndRemoveUntil(
              context,
              GetStartedScreen.routeName,
              (Route<dynamic> route) => false,
            );
          } else if (state.userDeleteStatus == ApiStatus.error) {
            Navigator.pop(context);
            showSnackBar(message: state.errorMessage ?? '');
          } else {
            progressDialogue();
          }
        }
      },
      child: Container(
        decoration: profileGradientBg, //commonGradientBg,
        width: double.infinity,
        height: double.infinity,
        child: Scaffold(
          body: Center(
            child: contents(context),
          ),
        ),
      ),
    );
  }

  Widget contents(context) {
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
                        text: TitleString.are_you_sure,
                        style: AppStyle.txtPoppinsBold17,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      CustomRichText(
                        text: TitleString.delete_confirmation,
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
              // BlocProvider.of<AuthenticationBloc>(context).add(SignOutEvent());
              // await Navigator.pushNamed(
              //   context,
              //   LogoutConfirmationScreen.routeName,
              // );
              //fetchData();
              BlocProvider.of<UserBloc>(context).add(
                  DeleteUserAccountEvent(userId: currentUser?.userId ?? ''));
            },
            margin: getMargin(top: 33, bottom: 16.0),
          ),
          CustomButton(
            text: TitleString.cancel,
            variant: ButtonVariant.outlineTealA400,
            fontStyle: ButtonFontStyle.poppinsRegular15WhiteA400,
            enabled: true,
            onTap: () {
              Navigator.of(context).pop();
            },
            margin: getMargin(top: 10, bottom: 16.0),
          ),
        ],
      ),
    );
  }
}
