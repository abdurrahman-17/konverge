import 'package:flutter/material.dart';

import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../blocs/graphql/graphql_state.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../models/graphql/user_info.dart';
import '../../../repository/user_repository.dart';
import '../../../theme/app_style.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/size_utils.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/common_dialogs.dart';
import '../../common_widgets/custom_buttons.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/custom_textfield.dart';
import '../../common_widgets/loader.dart';

class BiographyScreen extends StatefulWidget {
  static const String routeName = "/biography";

  const BiographyScreen({super.key});

  @override
  State<BiographyScreen> createState() => _BiographyScreenState();
}

class _BiographyScreenState extends State<BiographyScreen> {
  TextEditingController biographyController = TextEditingController();
  final FocusNode _focusBiography = FocusNode();
  late int cursorPositionBiography = 0;

  UserInfoModel? user;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _focusBiography.addListener(() {
      if (!_focusBiography.hasFocus) {
        cursorPositionBiography = biographyController.selection.base.offset;
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
    var currentUser = Locator.instance.get<UserRepo>().getCurrentUserData();
    setState(() {
      if (currentUser != null) user = currentUser;
      if (user != null && user?.biography != null) {
        biographyController.text = user?.biography ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonBackground,
        CommonBgLogo(
          opacity: 0.6,
          position: CommonBgLogoPosition.bottomRight,
        ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: contents(context),
          appBar: CommonAppBar.appBar(context: context),
          backgroundColor: Colors.transparent,
        ),
        if (isLoading)
          const Positioned(
            child: Loader(),
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
          case SaveBiographySuccessState:
            //biography update success
            user?.biography = (state as SaveBiographySuccessState).biography;
            Locator.instance.get<UserRepo>().setCurrentUserData(user!);

            Navigator.pop(context, true);
            break;
          case GraphqlErrorState:
            print(
                "GraphqlErrorState: $state ${(state as GraphqlErrorState).errorMessage}");
            break;
          default:
            print("Unknown state while logging in: $state");
        }
      },
      child: Container(
        padding: getPadding(left: 35, right: 35),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomRichText(
                text: TitleString.biography,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppStyle.txtPoppinsSemiBold20,
              ),
              Container(
                margin: getMargin(top: 10),
                child: CustomRichText(
                  text: TitleString.biographyContent,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtPoppinsLight13,
                ),
              ),
              Padding(
                padding: getPadding(top: 20),
                child: CustomRichText(
                  text: TitleString.biography,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtPoppinsRegular15,
                ),
              ),
              Padding(
                padding: getPadding(top: 10),
                child: Form(
                  key: formKey,
                  child: CustomTextFormField(
                    autoValidateMode: AutovalidateMode.disabled,
                    focusNode: _focusBiography,
                    controller: biographyController,
                    maxLines: 20,
                    maxLength: 250,
                    onChanged: (val) {
                      if (val.length < 50) setState(() {});
                      if (val.length >= 50)
                        setState(() {
                          formKey.currentState!.validate();
                        });
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Biography is required";
                      }
                      if (val.length < 50) {
                        return "Minimum character limit : 50";
                      }
                      return null;
                    },
                    hintText: "Enter your biography",
                    variant: TextFormFieldVariant.outlineBlack90035,
                    fontStyle: TextFormFieldFontStyle.poppinsMedium14WhiteA700,
                    hintStyle: TextFormFieldFontStyle.poppinsMedium14,
                    margin: getMargin(top: 11),
                    focusedInputBorder: biographyController.text.length < 50
                        ? TextFormFieldVariant.outlineBlack90035
                        : TextFormFieldVariant.outlineTealA400,
                  ),
                ),
              ),
              // Spacer(),
              CustomButton(
                // height: getVerticalSize(47),
                text: "Save",
                enabled: biographyController.text.length >= 50,
                margin: getMargin(top: 30, bottom: 30),
                onTap: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  if (biographyController.text.length < 3) {
                    showInfo(
                      context,
                      content: TitleString.warningEmptyBiography,
                      buttonLabel: TitleString.btnOkay,
                    );
                    return;
                  }

                  BlocProvider.of<GraphqlBloc>(context).add(
                    UpdateBiographyEvent(
                      biography: biographyController.text,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
