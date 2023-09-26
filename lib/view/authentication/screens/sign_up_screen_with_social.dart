import 'package:flutter/material.dart';
import '../../../models/graphql/user.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/snack_bar.dart';
import '../../../theme/app_style.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/size_utils.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../../utilities/validator.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_textfield.dart';

class SignUpWithSocialScreen extends StatelessWidget {
  static const String routeName = '/sign_up_with_social';
  final User? user;

  SignUpWithSocialScreen({
    super.key,
    required this.user,
  });

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  // final FocusNode _focusDateOfBirth = FocusNode();
  // final FocusNode _focusCity = FocusNode();

  // late int cursorPositionDateOfBirth = 0;
  // late int cursorPositionCity = 0;

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
          body: contents(context),
          appBar: CommonAppBar.appBar(context: context),
          backgroundColor: Colors.transparent,
        ),
      ],
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
          child: SingleChildScrollView(
            child: Container(
              padding: getPadding(
                left: 35,
                right: 35,
                bottom: 27,
              ),
              height: size.height - getVerticalSize(127),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomRichText(
                        text: TitleString.yourDetails,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtPoppinsSemiBold20,
                      ),
                      Padding(
                        padding: getPadding(top: 12),
                        child: CustomRichText(
                          text: TitleString.userInfoHeader,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsLight13,
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 32),
                        child: CustomRichText(
                          text: TitleString.dateOfBirth,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsMedium14,
                        ),
                      ),
                      CustomTextFormField(
                        focusNode: FocusNode(),
                        controller: dateOfBirthController,
                        hintText: TitleString.hintDateOfBirth,
                        variant: TextFormFieldVariant.outlineBlack90035,
                        fontStyle:
                            TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                        hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                        textInputType: TextInputType.datetime,
                        margin: getMargin(top: 11),
                        validator: (dateOfBirth) =>
                            Validation.validateDateOfBirth(
                          dateOfBirth,
                        ),
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
                        padding: getPadding(top: 23),
                        child: CustomRichText(
                          text: TitleString.city,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsMedium14,
                        ),
                      ),
                      CustomTextFormField(
                        focusNode: FocusNode(),
                        controller: cityController,
                        variant: TextFormFieldVariant.outlineBlack90035,
                        fontStyle:
                            TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                        hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                        hintText: TitleString.enterCityName,
                        margin: getMargin(top: 10),
                        validator: (cityName) => Validation.nameValidation(
                          cityName,
                          TitleString.city,
                          2,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                      enabled: true,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          showSnackBar(
                            message: "Please try to sign up via get started.",
                          );
                        }
                      },
                      text: TitleString.signUp,
                      margin: getMargin(top: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
