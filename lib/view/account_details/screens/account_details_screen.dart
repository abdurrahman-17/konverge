import 'package:flutter/material.dart';

import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../core/app_export.dart';
import '../../../models/graphql/user_info.dart';
import '../../../repository/user_repository.dart';
import '../../../utilities/common_functions.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../../utilities/validator.dart';

import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_textfield.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/snack_bar.dart';
import 'email_verification_screen.dart';

class AccountDetailScreen extends StatefulWidget {
  static const String routeName = "/account_details";

  const AccountDetailScreen({super.key});

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  final FocusNode _focusFirstName = FocusNode();
  final FocusNode _focusLastName = FocusNode();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPhoneNumber = FocusNode();
  final FocusNode _focusDateOfBirth = FocusNode();
  final FocusNode _focusCity = FocusNode();

  late int cursorPositionFirstName = 0;
  late int cursorPositionLastName = 0;
  late int cursorPositionEmail = 0;
  late int cursorPositionPhoneNumber = 0;
  late int cursorPositionDateOfBirth = 0;
  late int cursorPositionCity = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  UserInfoModel? user;

  void addListenerFirstName() {
    addListener(_focusFirstName, cursorPositionFirstName, firstNameController);
  }

  @override
  void initState() {
    _focusFirstName.addListener(() {
      addListenerFirstName();
    });
    _focusLastName.addListener(() {
      addListener(_focusLastName, cursorPositionLastName, lastNameController);
    });
    _focusEmail.addListener(() {
      addListener(_focusEmail, cursorPositionEmail, emailController);
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
    readUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> readUser() async {
    final currentUser = Locator.instance.get<UserRepo>().getCurrentUserData();

    if (currentUser != null) {
      user = currentUser;
    } else {
      print(" userPref null");
    }
    if (user != null) {
      if (user?.firstname != null) {
        firstNameController.text = user?.firstname ?? '';
      }
      if (user?.lastname != null) {
        lastNameController.text = user?.lastname ?? '';
      }
      if (user?.email != null) emailController.text = user?.email ?? '';
      if (user?.phonenumber != null) {
        phoneNumberController.text = user?.phonenumber ?? '';
      }
      if (user?.dob != null) {
        String dateOfBirth = user?.dob?.substring(0, 10) ?? '';
        dateOfBirth =
            convertDateFormat(dateOfBirth, "yyyy-MM-dd", 'dd/MM/yyyy');
        dateOfBirthController.text = dateOfBirth;
      }
      if (user?.city != null) cityController.text = user?.city ?? '';
    } else {
      print(" user is null");
    }
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
            children: [contents(context), if (isLoading) const Loader()],
          ),
          appBar: CommonAppBar.appBar(context: context),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget contents(BuildContext context) {
    return BlocListener<GraphqlBloc, GraphqlState>(
      listener: (BuildContext context, state) {
        setState(() {
          isLoading = false;
        });
        switch (state.runtimeType) {
          case QueryLoadingState:
            setState(() {
              isLoading = true;
            });
            break;
          case QueryUpdateSuccessState:
            break;
          case UpdateAccountDetailsSuccessState:
            state as UpdateAccountDetailsSuccessState;
            user?.firstname = state.firstname;
            user?.lastname = state.lastname;
            user?.email = state.email;
            user?.city = state.city;
            user?.dob = convertDateFormat(
              state.dob,
              "dd/MM/yyyy",
              "yyyy-MM-dd'T'HH:mm:ss'Z'",
            );
            user?.fullname = "${state.firstname} ${state.lastname}";
            Locator.instance.get<UserRepo>().setCurrentUserData(user!);
            Navigator.pop(context);
            break;
          case GraphqlErrorState:
            print("Graphql error state: $state");
            break;
          default:
            print("Graphql Unknown state while logging in: $state");
        }
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Padding(
              padding: getPadding(left: 35, right: 35, bottom: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account Details",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: AppStyle.txtPoppinsSemiBold20,
                  ),
                  Container(
                    width: double.maxFinite,
                    margin: getMargin(top: 15, bottom: 15),
                    child: Text(
                      TitleString.warningInfoAccount,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsLight13,
                    ),
                  ),
                  Text(
                    TitleString.enterYourFirstNameHint,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsMedium14,
                  ),
                  CustomTextFormField(
                    focusNode: _focusFirstName,
                    controller: firstNameController,
                    validator: (firstName) => Validation.nameValidation(
                      firstName,
                      TitleString.firstName,
                      2,
                    ),
                    hintText: TitleString.enterYourFirstNameHint,
                    margin: getMargin(top: 11),
                    variant: TextFormFieldVariant.outlineBlack90035,
                    fontStyle: TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                    hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                  ),
                  Padding(
                    padding: getPadding(top: 22),
                    child: Text(
                      TitleString.yourLastNameLabel,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsMedium14,
                    ),
                  ),
                  CustomTextFormField(
                    focusNode: _focusLastName,
                    controller: lastNameController,
                    hintText: TitleString.enterYourLastNameHint,
                    validator: (lastName) => Validation.nameValidation(
                      lastName,
                      TitleString.lastName,
                      2,
                    ),
                    margin: getMargin(top: 11),
                    variant: TextFormFieldVariant.outlineBlack90035,
                    fontStyle: TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                    hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                  ),
                  Padding(
                    padding: getPadding(top: 22),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: TitleString.enterYourEmailLabel,
                            style: TextStyle(
                              color: AppColors.whiteA700,
                              fontSize: getFontSize(14),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: "*",
                            style: TextStyle(
                              color: AppColors.red800,
                              fontSize: getFontSize(14),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  CustomTextFormField(
                    focusNode: _focusEmail,
                    isEnabled: !(user?.isEmailVerified ?? false),
                    controller: emailController,
                    validator: (email) => Validation.emailValidation(email),
                    hintText: TitleString.enterYourEmailHint,
                    margin: getMargin(top: 11),
                    suffixConstraints: BoxConstraints(
                      maxHeight: getVerticalSize(47),
                    ),
                    suffix: Visibility(
                      visible: !(user?.isEmailVerified ?? false),
                      child: InkWell(
                        hoverColor: AppColors.transparent,
                        highlightColor: AppColors.transparent,
                        focusColor: AppColors.transparent,
                        splashColor: AppColors.transparent,
                        onTap: () async {
                          if (user?.email != emailController.text.trim()) {
                            showSnackBar(
                                message: TitleString.warningMessageEmailSave);
                            return;
                          }
                          final verificationStatus = await Navigator.pushNamed(
                            context,
                            VerifyEmailScreen.routeName,
                            arguments: {
                              'email': user?.email,
                            },
                          );
                          if (verificationStatus != null) {
                            setState(() {
                              user!.isEmailVerified = true;
                            });
                          }
                        },
                        onLongPress: () {},
                        child: Padding(
                          padding: getPadding(all: 13),
                          child: Text(
                            TitleString.verify.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtPoppinsRegular12,
                          ),
                        ),
                      ),
                    ),
                    variant: TextFormFieldVariant.outlineBlack90035,
                    fontStyle: TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                    hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                  ),
                  Padding(
                    padding: getPadding(top: 24),
                    child: Text(
                      TitleString.enterYourPhoneNumberLabel,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsMedium14,
                    ),
                  ),
                  CustomTextFormField(
                    focusNode: _focusPhoneNumber,
                    controller: phoneNumberController,
                    hintText: TitleString.enterYourPhoneNumberHint,
                    isEnabled: false,
                    margin: getMargin(top: 9),
                    variant: TextFormFieldVariant.outlineBlack90035,
                    fontStyle: TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                    hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                  ),
                  Padding(
                    padding: getPadding(top: 22),
                    child: Text(
                      TitleString.enterYourDobLabel,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsMedium14,
                    ),
                  ),
                  CustomTextFormField(
                    focusNode: _focusDateOfBirth,
                    controller: dateOfBirthController,
                    validator: (dateOfBirth) => Validation.validateDateOfBirth(
                      dateOfBirth,
                    ),
                    hintText: TitleString.enterYourDobHint,
                    margin: getMargin(top: 11),
                    variant: TextFormFieldVariant.outlineBlack90035,
                    fontStyle: TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                    hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                    textInputType: TextInputType.datetime,
                    onChanged: (value) {
                      List<String> spittedValue = value.split('');
                      if (spittedValue.length == 3 &&
                          !spittedValue.contains('/')) {
                        dateOfBirthController.text =
                            '${spittedValue[0]}${spittedValue[1]}/${spittedValue[2]}';
                        dateOfBirthController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                            offset: dateOfBirthController.text.length,
                          ),
                        );
                      } else if (spittedValue.length == 6 &&
                          spittedValue[5] != '/') {
                        dateOfBirthController.text =
                            '${spittedValue[0]}${spittedValue[1]}/${spittedValue[3]}${spittedValue[4]}/${spittedValue[5]}';
                        dateOfBirthController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                            offset: dateOfBirthController.text.length,
                          ),
                        );
                      } else if (value.length >= 10) {
                        dateOfBirthController.text =
                            '${spittedValue[0]}${spittedValue[1]}/${spittedValue[3]}${spittedValue[4]}/${spittedValue[6]}${spittedValue[7]}${spittedValue[8]}${spittedValue[9]}';
                        dateOfBirthController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                            offset: dateOfBirthController.text.length,
                          ),
                        );
                      }
                      // buttonEnabledChecking(value);
                    },
                  ),
                  Padding(
                    padding: getPadding(top: 17),
                    child: Text(
                      TitleString.enterYourCityLabel,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsMedium14,
                    ),
                  ),
                  CustomTextFormField(
                    focusNode: _focusCity,
                    controller: cityController,
                    validator: (cityName) => Validation.nameValidation(
                      cityName,
                      TitleString.city,
                      2,
                    ),
                    hintText: TitleString.enterYourCityHint,
                    margin: getMargin(top: 10),
                    variant: TextFormFieldVariant.outlineBlack90035,
                    fontStyle: TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                    hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                    textInputAction: TextInputAction.done,
                  ),
                  CustomButton(
                    enabled: true,
                    // height: getVerticalSize(47),
                    text: TitleString.btnSave,
                    margin: getMargin(top: 37),
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        String dateOfBirth = dateOfBirthController.text;
                        BlocProvider.of<GraphqlBloc>(context).add(
                          UpdateAccountInfoEvent(
                            firstname: firstNameController.text.trim(),
                            lastname: lastNameController.text.trim(),
                            city: cityController.text.trim(),
                            email: emailController.text.trim(),
                            dob: dateOfBirth.trim(),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
