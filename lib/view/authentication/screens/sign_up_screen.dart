import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../core/configurations.dart';
import '../../../services/amplify/amplify_service.dart';
import '../../../utilities/common_navigation_logics.dart';
import '../../../utilities/transition_constant.dart';
import '../../common_widgets/common_dialogs.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/snack_bar.dart';

import '../../../core/app_export.dart';
import '../../../core/locator.dart';
import '../../../models/amplify/sign_up_request.dart';
import '../../../services/api_requests/api_service.dart';
import '../../../services/shared_preference_service.dart';
import '../../../utilities/validator.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_textfield.dart';
import '../../common_widgets/loader.dart';
import 'account_set_screen.dart';
import 'logout_confirmation.dart';
import 'sign_up_phone_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signUp';

  const SignUpScreen({
    super.key,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final FocusNode _focusFirstName = FocusNode();
  final FocusNode _focusLastName = FocusNode();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusDateOfBirth = FocusNode();
  final FocusNode _focusCity = FocusNode();
  final FocusNode _focusPassword = FocusNode();
  final FocusNode _focusPhoneNumber = FocusNode();

  late int cursorPositionFirstName = 0;
  late int cursorPositionLastName = 0;
  late int cursorPositionEmail = 0;
  late int cursorPositionPhoneNumber = 0;
  late int cursorPositionDateOfBirth = 0;
  late int cursorPositionCity = 0;
  late int cursorPassword = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CountryCode countryCode = CountryCode(dialCode: "+44");
  List<TextEditingController> controllers = [];
  bool isEnabled = false;
  bool isEmailIdEnabled = true;
  LoginType loginType =
      Locator.instance.get<SharedPrefServices>().getLoginType();
  String cognitoId = '';

  @override
  void initState() {
    _focusFirstName.addListener(() {
      if (!_focusFirstName.hasFocus) {
        cursorPositionFirstName = firstNameController.selection.base.offset;
      }
    });
    _focusLastName.addListener(() {
      if (!_focusLastName.hasFocus) {
        cursorPositionLastName = lastNameController.selection.base.offset;
      }
    });
    _focusEmail.addListener(() {
      if (!_focusEmail.hasFocus) {
        cursorPositionEmail = emailAddressController.selection.base.offset;
      }
    });
    _focusPhoneNumber.addListener(() {
      if (!_focusPhoneNumber.hasFocus) {
        cursorPositionPhoneNumber = phoneNumberController.selection.base.offset;
      }
    });
    _focusDateOfBirth.addListener(() {
      if (!_focusDateOfBirth.hasFocus) {
        cursorPositionDateOfBirth = dateOfBirthController.selection.base.offset;
      }
    });
    _focusCity.addListener(() {
      if (!_focusCity.hasFocus) {
        cursorPositionCity = cityController.selection.base.offset;
      }
    });

    _focusPassword.addListener(() {
      if (!_focusCity.hasFocus) {
        cursorPositionCity = passwordController.selection.base.offset;
      }
    });

    controllers = [passwordController];
    animationController = AnimationController(
        vsync: this,
        duration: Duration(
            milliseconds: TransitionConstant.signUpTransitionDuration));
    animation = Tween<double>(begin: 0.0, end: getHorizontalSize(176))
        .animate(animationController!)
      ..addListener(() {
        setState(() {});
      });
    if (loginType != LoginType.usernameAndPassword) {
      autoPopulate();
    }
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  void seLoading(bool value) {
    value ? progressDialogue() : Navigator.pop(context);
  }

  void autoPopulate() async {
    setState(() {
      isLoading = true;
      isEmailIdEnabled = false;
    });
    final result = await Locator.instance.get<AmplifyService>().getTokens();
    if (result != null) {
      firstNameController.text = result.idToken.givenName ?? '';
      lastNameController.text = result.idToken.familyName ?? '';
      emailAddressController.text = result.idToken.email ?? '';
      cognitoId = result.userId;
      if (result.idToken.email == null || result.idToken.email!.isEmpty) {
        showInfo(context,
            content: TitleString.emailIdNotAvailableFromSocialLogin,
            buttonLabel: TitleString.btnOk, onTap: () {
          Navigator.pop(context);
        });
      }
    }
    isLoading = false;
    setState(() {});
  }

  Animation<double>? animation;
  AnimationController? animationController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        log(state.toString());
        if (state is CreateUserAccountState) {
          if (state.userCreateStatus == ApiStatus.success) {
            seLoading(false);
            CommonStaticValues.isAfterSignUp = true;
            Navigator.pushNamedAndRemoveUntil(context,
                AccountSetScreen.routeName, (Route<dynamic> route) => false);
          } else if (state.userCreateStatus == ApiStatus.error) {
            seLoading(false);
            showSnackBar(message: state.errorMessage ?? "SignUp failed");
          } else {
            seLoading(true);
          }
        }
      },
      child: Stack(
        children: [
          commonBackground,
          AnimatedBuilder(
              animation: animation!,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(-getHorizontalSize(176) + animation!.value, 0),
                  child: Stack(
                    children: [
                      CommonBgLogo(
                        opacity: 0.6,
                        position: CommonBgLogoPosition.topCenter,
                      ),
                    ],
                  ),
                );
              }),
          // CommonBgLogo(
          //   opacity: 0.6,
          // ),
          Scaffold(
            resizeToAvoidBottomInset: true,
            body: contents(context),
            appBar: CommonAppBar.appBar(
                context: context,
                showAppBar: true,
                onTapLeading: () async {
                  if (loginType != LoginType.usernameAndPassword) {
                    await Navigator.pushNamed(
                        context, LogoutConfirmationScreen.routeName,
                        arguments: {"isSignOut": false});
                  } else {
                    Navigator.pop(context);
                  }
                }),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  // ButtonNotifier? buttonEnabled;

  Widget contents(BuildContext context) {
    return AnimatedBuilder(
        animation: animation!,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(-animation!.value * 2, 0),
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: Form(
                key: _formKey,
                child: SizedBox(
                  height: getVerticalSize(999),
                  width: double.maxFinite,
                  child: Stack(
                    children: [
                      Align(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    width: getHorizontalSize(375),
                                    padding: getPadding(
                                      left: 35,
                                      right: 35,
                                      bottom: 27,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomRichText(
                                          text: TitleString.yourDetails,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtPoppinsSemiBold20,
                                        ),
                                        Container(
                                          padding: getPadding(top: 12),
                                          child: CustomRichText(
                                            text: TitleString.userInfoHeader,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtPoppinsLight13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: getPadding(
                                        left: 35, right: 35, bottom: 82),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomRichText(
                                          text: TitleString.firstName,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtPoppinsMedium14,
                                        ),
                                        CustomTextFormField(
                                          padding: TextFormFieldPadding
                                              .paddingSignUpTextField,
                                          focusNode: _focusFirstName,
                                          controller: firstNameController,
                                          hintText: TitleString.enterFirstName,
                                          variant: TextFormFieldVariant
                                              .outlineBlack90035,
                                          fontStyle: TextFormFieldFontStyle
                                              .poppinsMedium14WhiteA700,
                                          hintStyle: TextFormFieldFontStyle
                                              .poppinsMedium14,
                                          margin: getMargin(top: 11),
                                          onChanged: buttonEnabledChecking,
                                          validator: (firstName) =>
                                              Validation.nameValidation(
                                            firstName,
                                            TitleString.firstName,
                                            2,
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(top: 22),
                                          child: CustomRichText(
                                            text: TitleString.lastName,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtPoppinsMedium14,
                                          ),
                                        ),
                                        CustomTextFormField(
                                          padding: TextFormFieldPadding
                                              .paddingSignUpTextField,
                                          focusNode: _focusLastName,
                                          controller: lastNameController,
                                          hintText: TitleString.enterLastName,
                                          variant: TextFormFieldVariant
                                              .outlineBlack90035,
                                          textInputAction: TextInputAction.next,
                                          fontStyle: TextFormFieldFontStyle
                                              .poppinsMedium14WhiteA700,
                                          hintStyle: TextFormFieldFontStyle
                                              .poppinsMedium14,
                                          margin: getMargin(
                                            top: 11,
                                          ),
                                          onChanged: buttonEnabledChecking,
                                          validator: (lastName) =>
                                              Validation.nameValidation(
                                            lastName,
                                            TitleString.lastName,
                                            2,
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(top: 22),
                                          child: CustomRichText(
                                            text: TitleString.emailAddress,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtPoppinsMedium14,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (!isEmailIdEnabled)
                                              showInfo(
                                                context,
                                                content:
                                                    "Sorry, unable to edit your email address at this time",
                                                buttonLabel: TitleString.btnOk,
                                              );
                                          },
                                          child: CustomTextFormField(
                                            focusNode: _focusEmail,
                                            isEnabled: isEmailIdEnabled,
                                            controller: emailAddressController,
                                            hintText: TitleString.enterEmailId,
                                            margin: getMargin(top: 11),
                                            textInputAction:
                                                TextInputAction.next,
                                            padding: TextFormFieldPadding
                                                .paddingSignUpTextField,
                                            variant: TextFormFieldVariant
                                                .outlineBlack90035,
                                            fontStyle: TextFormFieldFontStyle
                                                .poppinsMedium14WhiteA700,
                                            hintStyle: TextFormFieldFontStyle
                                                .poppinsMedium14,
                                            textInputType:
                                                TextInputType.emailAddress,
                                            onChanged: buttonEnabledChecking,
                                            validator: (email) =>
                                                Validation.emailValidation(
                                                    email),
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(top: 22),
                                          child: CustomRichText(
                                            text: TitleString.dateOfBirth,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtPoppinsMedium14,
                                          ),
                                        ),
                                        CustomTextFormField(
                                          padding: TextFormFieldPadding
                                              .paddingSignUpTextField,
                                          focusNode: _focusDateOfBirth,
                                          controller: dateOfBirthController,
                                          hintText: TitleString.hintDateOfBirth,
                                          variant: TextFormFieldVariant
                                              .outlineBlack90035,
                                          fontStyle: TextFormFieldFontStyle
                                              .poppinsMedium14WhiteA700,
                                          hintStyle: TextFormFieldFontStyle
                                              .poppinsMedium14,
                                          textInputType: TextInputType.datetime,
                                          margin: getMargin(top: 11),
                                          onChanged: (value) {
                                            List<String> spittedValue =
                                                value.split('');
                                            if (spittedValue.length == 3 &&
                                                !spittedValue.contains('/')) {
                                              dateOfBirthController.text =
                                                  '${spittedValue[0]}${spittedValue[1]}/${spittedValue[2]}';
                                              dateOfBirthController.selection =
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                  offset: dateOfBirthController
                                                      .text.length,
                                                ),
                                              );
                                            } else if (spittedValue.length ==
                                                    6 &&
                                                spittedValue[5] != '/') {
                                              dateOfBirthController.text =
                                                  '${spittedValue[0]}${spittedValue[1]}/${spittedValue[3]}${spittedValue[4]}/${spittedValue[5]}';
                                              dateOfBirthController.selection =
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                  offset: dateOfBirthController
                                                      .text.length,
                                                ),
                                              );
                                            } else if (value.length >= 10) {
                                              dateOfBirthController.text =
                                                  '${spittedValue[0]}${spittedValue[1]}/${spittedValue[3]}${spittedValue[4]}/${spittedValue[6]}${spittedValue[7]}${spittedValue[8]}${spittedValue[9]}';
                                              dateOfBirthController.selection =
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                  offset: dateOfBirthController
                                                      .text.length,
                                                ),
                                              );
                                            }
                                            buttonEnabledChecking(value);
                                          },
                                          validator: (dateOfBirth) =>
                                              Validation.validateDateOfBirth(
                                            dateOfBirth,
                                          ),
                                        ),
                                        Padding(
                                          padding: getPadding(top: 23),
                                          child: CustomRichText(
                                            text: TitleString.city,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtPoppinsMedium14,
                                          ),
                                        ),
                                        CustomTextFormField(
                                          padding: TextFormFieldPadding
                                              .paddingSignUpTextField,
                                          focusNode: _focusCity,
                                          controller: cityController,
                                          variant: TextFormFieldVariant
                                              .outlineBlack90035,
                                          fontStyle: TextFormFieldFontStyle
                                              .poppinsMedium14WhiteA700,
                                          hintStyle: TextFormFieldFontStyle
                                              .poppinsMedium14,
                                          hintText: TitleString.enterCityName,
                                          margin: getMargin(top: 10),
                                          onChanged: buttonEnabledChecking,
                                          validator: (cityName) =>
                                              Validation.nameValidation(
                                            cityName,
                                            TitleString.city,
                                            2,
                                          ),
                                        ),
                                        if (loginType ==
                                            LoginType.usernameAndPassword) ...[
                                          Padding(
                                            padding: getPadding(top: 45),
                                            child: CustomRichText(
                                              text: TitleString.setPassword,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style:
                                                  AppStyle.txtPoppinsSemiBold20,
                                            ),
                                          ),
                                          Container(
                                            width: double.maxFinite,
                                            margin: getMargin(top: 10),
                                            child: CustomRichText(
                                              text: TitleString.passwordInfo,
                                              textAlign: TextAlign.left,
                                              style: AppStyle.txtPoppinsLight13,
                                            ),
                                          ),
                                          CustomTextFormField(
                                            padding: TextFormFieldPadding
                                                .paddingSignUpTextField,
                                            focusNode: _focusPassword,
                                            controller: passwordController,
                                            hintText: TitleString.password,
                                            margin: getMargin(top: 16),
                                            textInputAction:
                                                TextInputAction.done,
                                            textInputType:
                                                TextInputType.visiblePassword,
                                            variant: TextFormFieldVariant
                                                .outlineBlack90035,
                                            fontStyle: TextFormFieldFontStyle
                                                .poppinsMedium14WhiteA700,
                                            hintStyle: TextFormFieldFontStyle
                                                .poppinsMedium14,
                                            isObscureText: true,
                                            validator: (password) =>
                                                Validation.passwordValidation(
                                                    password),
                                            onChanged: (value) {
                                              if (value.contains(' ')) {
                                                // Remove any spaces from the entered text
                                                passwordController.text =
                                                    value.replaceAll(' ', '');
                                                // Move the cursor to the end of the text
                                                passwordController.selection =
                                                    TextSelection.fromPosition(
                                                  TextPosition(
                                                    offset: passwordController
                                                        .text.length,
                                                  ),
                                                );
                                              }
                                              buttonEnabledChecking(value);
                                            },
                                          ),
                                        ] else ...[
                                          Padding(
                                            padding: getPadding(top: 23),
                                            child: CustomRichText(
                                              text:
                                                  TitleString.phoneNumberSmall,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style:
                                                  AppStyle.txtPoppinsMedium14,
                                            ),
                                          ),
                                          CustomTextFormField(
                                            focusNode: _focusPhoneNumber,
                                            controller: phoneNumberController,
                                            hintText: TitleString
                                                .enterYourPhoneNumberHint,
                                            margin: getMargin(top: 11),
                                            onChanged: (value) {
                                              buttonEnabledChecking(value);
                                            },
                                            onCountryChanged: (value) {
                                              countryCode = value;
                                            },
                                            variant: TextFormFieldVariant
                                                .outlineBlack90035,
                                            textInputType: TextInputType.phone,
                                            fontStyle: TextFormFieldFontStyle
                                                .poppinsMedium14WhiteA700,
                                            hintStyle: TextFormFieldFontStyle
                                                .poppinsMedium14,
                                            validator: (userName) => Validation
                                                .mobileNumberValidation(
                                                    userName),
                                          ),
                                        ],
                                        CustomButton(
                                          enabled: isEnabled,
                                          onTap: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              HapticFeedback.vibrate();
                                              setState(() {
                                                isLoading = true;
                                              });
                                              bool? emailDuplicateStatus =
                                                  await Locator.instance
                                                      .get<ApiService>()
                                                      .checkEmailExists(
                                                          email:
                                                              emailAddressController
                                                                  .text);

                                              setState(() {
                                                isLoading = false;
                                              });

                                              if (loginType ==
                                                      LoginType
                                                          .usernameAndPassword &&
                                                  emailDuplicateStatus) {
                                                await animationController!
                                                    .forward();
                                                await Navigator.pushNamed(
                                                  context,
                                                  SignUpPhoneScreen.routeName,
                                                  arguments: {
                                                    'data': SignUpRequestModel(
                                                      email:
                                                          emailAddressController
                                                              .text
                                                              .toString(),
                                                      password:
                                                          passwordController
                                                              .text
                                                              .toString(),
                                                      firstName:
                                                          firstNameController
                                                              .text
                                                              .toString(),
                                                      lastName:
                                                          lastNameController
                                                              .text
                                                              .toString(),
                                                      birthDate:
                                                          dateOfBirthController
                                                              .text,
                                                      city: cityController.text
                                                          .toString(),
                                                    ),
                                                  },
                                                );
                                                animationController!.reverse();
                                              } else if (emailDuplicateStatus) {
                                                //save data to  DB
                                                log("save data to  DB");
                                                saveUserData();
                                              }
                                            }
                                          },
                                          // height: getVerticalSize(47),
                                          text: TitleString.signUp,
                                          margin: getMargin(top: 20),
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
                      if (isLoading) const Positioned(child: Loader())
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void buttonEnabledChecking(value) {
    if (firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailAddressController.text.isNotEmpty &&
        dateOfBirthController.text.isNotEmpty &&
        cityController.text.isNotEmpty) {
      if (loginType == LoginType.usernameAndPassword &&
          passwordController.text.isNotEmpty) {
        if (!isEnabled) {
          setState(() {
            isEnabled = true;
          });
        }
      } else if (loginType != LoginType.usernameAndPassword &&
          phoneNumberController.text.isNotEmpty) {
        if (!isEnabled) {
          setState(() {
            isEnabled = true;
          });
        }
      }
    } else {
      if (isEnabled) {
        setState(() {
          isEnabled = false;
        });
      }
    }
    //   if (_formKey.currentState!.validate()) {
    //     if (isEnabled != true) {
    //       setState(() {
    //         isEnabled = true;
    //       });
    //     }
    //   } else {
    //     if (isEnabled) {
    //       setState(() {
    //         isEnabled = false;
    //       });
    //     }
    //   }
  }

  void saveUserData() {
    final Map<String, dynamic> userJson = {
      "cognitoId": cognitoId,
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "fullName": "${firstNameController.text} ${lastNameController.text}".trim(),
      "email": emailAddressController.text.trim(),
      "dob": dateOfBirthController.text.trim(),
      "city": cityController.text.trim(),
      "phoneNumber": countryCode.toString() + phoneNumberController.text,
      "loginType": loginType.name,
      "stage": 3,
    };

    BlocProvider.of<UserBloc>(context)
        .add(CreateUserAccountEvent(userData: userJson));
  }
}
