import 'package:flutter/material.dart';
import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../core/configurations.dart';
import '../../../utilities/title_string.dart';
import '../../../utilities/validator.dart';
import '../../../core/app_export.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/common_dialogs.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_textfield.dart';
import '../../common_widgets/loader.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = "/change_password";

  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeNewPassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();

  late int _cursorPositionPassword = 0;
  late int _cursorPositionNewPassword = 0;
  late int _cursorPositionConfirmPassword = 0;

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _focusNodePassword.addListener(() {
      if (!_focusNodePassword.hasFocus) {
        _cursorPositionPassword = passwordController.selection.base.offset;
      }
    });

    _focusNodeNewPassword.addListener(() {
      if (!_focusNodeNewPassword.hasFocus) {
        _cursorPositionNewPassword =
            newPasswordController.selection.base.offset;
      }
    });

    _focusNodeConfirmPassword.addListener(() {
      if (!_focusNodeConfirmPassword.hasFocus) {
        _cursorPositionConfirmPassword =
            confirmPasswordController.selection.base.offset;
      }
    });

    passwordController = TextEditingController.fromValue(
      TextEditingValue(
        text: passwordController.text,
        selection: TextSelection(
          baseOffset: _cursorPositionPassword,
          extentOffset: _cursorPositionPassword,
        ),
      ),
    );

    passwordController = TextEditingController.fromValue(
      TextEditingValue(
        text: passwordController.text,
        selection: TextSelection(
          baseOffset: _cursorPositionNewPassword,
          extentOffset: _cursorPositionNewPassword,
        ),
      ),
    );

    confirmPasswordController = TextEditingController.fromValue(
      TextEditingValue(
        text: newPasswordController.text,
        selection: TextSelection(
          baseOffset: _cursorPositionConfirmPassword,
          extentOffset: _cursorPositionConfirmPassword,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonBackground,
        CommonBgLogo(
          opacity: 0.6,
        ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              contents(context),
              if (isLoading) const Loader(),
            ],
          ),
          appBar: CommonAppBar.appBar(context: context),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget contents(BuildContext context) {
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
          case UpdatePasswordSuccessState:
            showInfo(
              context,
              content: TitleString.warningUpdatePasswordSuccess,
              buttonLabel: TitleString.btnOkay,
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
            break;
          case UpdatePasswordErrorState:
            String warning = (state as UpdatePasswordErrorState).warning;
            if (warning.contains("password")) {
              warning = "Old password is incorrect";
            }
            showInfo(
              context,
              content: warning,
              buttonLabel: TitleString.btnOkay,
              onTap: () {
                Navigator.pop(context);
              },
            );
            break;
          default:
            print("Unknown state while logging in: $state");
        }
      },
      child: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewPadding.top -
              MediaQuery.of(context).viewPadding.bottom,
          width: double.maxFinite,
          padding: getPadding(left: 35, right: 35, bottom: 40),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: getPadding(bottom: 15),
                        child: Text(
                          "Change password",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsSemiBold20,
                        ),
                      ),
                      Text(
                        TitleString.warningChangePassword,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtPoppinsLight13WhiteA700,
                      ),
                      Text(
                        "\n${TitleString.passwordInfo}",
                        textAlign: TextAlign.left,
                        style: AppStyle.txtPoppinsLight13WhiteA700,
                      ),
                      Padding(
                        padding: getPadding(top: 20),
                        child: Text(
                          TitleString.currentPassword,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsMedium14,
                        ),
                      ),
                      CustomTextFormField(
                        padding: TextFormFieldPadding.paddingConfirmPassword,
                        focusNode: _focusNodePassword,
                        controller: passwordController,
                        hintText: TitleString.enterCurrentPassword,
                        margin: getMargin(top: 10),
                        variant: TextFormFieldVariant.outlineBlack90035,
                        fontStyle:
                            TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                        validator: (password) =>
                            Validation.passwordValidation(password),
                        hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                        textInputType: TextInputType.visiblePassword,
                        isObscureText: true,
                        onChanged: (value) {
                          if (value.contains(' ')) {
                            // Remove any spaces from the entered text
                            passwordController.text = value.replaceAll(' ', '');
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
                      Padding(
                        padding: getPadding(top: 24),
                        child: Text(
                          TitleString.newPassword,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsMedium14,
                        ),
                      ),
                      CustomTextFormField(
                        padding: TextFormFieldPadding.paddingConfirmPassword,
                        focusNode: _focusNodeNewPassword,
                        controller: newPasswordController,
                        hintText: TitleString.enterNewPassword,
                        margin: getMargin(top: 10),
                        variant: TextFormFieldVariant.outlineBlack90035,
                        fontStyle:
                            TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                        validator: (password) =>
                            Validation.passwordValidation(password),
                        hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                        textInputType: TextInputType.visiblePassword,
                        isObscureText: true,
                        onChanged: (value) {
                          if (value.contains(' ')) {
                            // Remove any spaces from the entered text
                            newPasswordController.text =
                                value.replaceAll(' ', '');
                            // Move the cursor to the end of the text
                            newPasswordController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                offset: newPasswordController.text.length,
                              ),
                            );
                          }
                        },
                      ),
                      Padding(
                        padding: getPadding(top: 24),
                        child: Text(
                          TitleString.confirmNewPassword,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsMedium14,
                        ),
                      ),
                      CustomTextFormField(
                        padding: TextFormFieldPadding.paddingConfirmPassword,
                        focusNode: _focusNodeConfirmPassword,
                        controller: confirmPasswordController,
                        hintText: TitleString.enterConfirmNewPassword,
                        validator: (password) =>
                            Validation.passwordValidation(password),
                        margin: getMargin(top: 10),
                        variant: TextFormFieldVariant.outlineBlack90035,
                        fontStyle:
                            TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                        hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                        textInputType: TextInputType.visiblePassword,
                        isObscureText: true,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          if (value.contains(' ')) {
                            // Remove any spaces from the entered text
                            confirmPasswordController.text =
                                value.replaceAll(' ', '');
                            // Move the cursor to the end of the text
                            confirmPasswordController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                offset: confirmPasswordController.text.length,
                              ),
                            );
                          }
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomButton(
                          //height: getVerticalSize(47),
                          text: TitleString.btnSave,
                          enabled: true,
                          margin: getMargin(top: 30),
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              if (passwordController.text ==
                                  newPasswordController.text) {
                                showInfo(
                                  context,
                                  content:
                                      "Old password and new password cannot be same",
                                  buttonLabel: TitleString.btnOkay,
                                );
                              } else if (newPasswordController.text !=
                                  confirmPasswordController.text) {
                                showInfo(
                                  context,
                                  content: "Passwords does not match",
                                  buttonLabel: TitleString.btnOkay,
                                );
                              } else {
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(
                                  UpdatePasswordEvent(
                                    oldPassword: passwordController.text,
                                    newPassword: newPasswordController.text,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
