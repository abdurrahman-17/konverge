import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konverge/core/locator.dart';
import 'package:konverge/repository/user_repository.dart';
import 'package:konverge/view/search_for_skills/screens/search_for_skills.dart';
import '../../../blocs/graphql/graphql_bloc.dart';
import '../../../blocs/graphql/graphql_event.dart';
import '../../../core/configurations.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/snack_bar.dart';
import '../../../core/app_export.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../launch/screens/launch_screen.dart';

import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/custom_buttons.dart';
import '../widgets/investment_item.dart';

class InvestmentScreen extends StatelessWidget {
  static const String routeName = "/investment";
  final bool isFromHome;
  InvestmentScreen({
    super.key,
    this.isFromHome = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonBackground,
        CommonBgLogo(
          // image: Assets.imgGroup530Black900,
          opacity: 0.6,
          position: CommonBgLogoPosition.bottomLeft,
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

  Widget contents(BuildContext context) {
    return SizedBox(
      height: size.height,
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Padding(
          padding: getPadding(left: 35, right: 35, bottom: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InvestmentItem(
                title: TitleString.investment_competition,
                fontStyle: AppStyle.txtPoppinsSemiBold20,
                topMargin: 0,
                iconNeeded: false,
              ),
              InvestmentItem(
                title: TitleString.investment_screen_description,
                fontStyle: AppStyle.txtPoppinsRegular14WhiteA700,
                topMargin: 12,
                iconNeeded: false,
              ),
              InvestmentItem(
                title: TitleString.warningInvestment,
                subtitle: TitleString.warningInvestment0,
                subTitle1: TitleString.warningInvestment1,
              ),
              InvestmentItem(
                title: TitleString.warningInvestment2,
              ),
              InvestmentItem(
                title: TitleString.warningInvestment3,
              ),
              InvestmentItem(
                topMargin: 17,
                title: TitleString.warningInvestment4,
                iconNeeded: false,
              ),
              InvestmentItem(
                topMargin: 6,
                title: TitleString.warningInvestment5,
                iconNeeded: false,
              ),
              Container(
                margin: getMargin(top: 23),
                padding: getPadding(
                  left: 26,
                  top: 14,
                  right: 26,
                  bottom: 14,
                ),
                decoration: AppDecoration.fillBlack90068.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder23,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: getHorizontalSize(161),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: TitleString.email_support_title,
                              style: TextStyle(
                                color: AppColors.whiteA700,
                                fontSize: getFontSize(11),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            TextSpan(
                              text: TitleString.applyEmailID,
                              style: TextStyle(
                                color: AppColors.whiteA700,
                                fontSize: getFontSize(13),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await Clipboard.setData(
                          const ClipboardData(
                            text: TitleString.applyEmailID,
                          ),
                        );
                        HapticFeedback.vibrate();
                        showSnackBar(
                          message: TitleString.infoEmailIdCopied,
                        );
                      },
                      child: CustomLogo(
                        svgPath: Assets.imgVolume,
                        height: getVerticalSize(20),
                        width: getHorizontalSize(15),
                        margin: getMargin(top: 10, bottom: 10),
                      ),
                    ),
                  ],
                ),
              ),
              CustomButton(
                text: TitleString.search_profile,
                margin: getMargin(top: 20),
                enabled: true,
                fontStyle: ButtonFontStyle.poppinsRegular14,
                onTap: () {
                  updateStage(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LaunchScreen.routeName,
                    arguments: {
                      'tab': 2,
                    },
                    (Route<dynamic> route) => false,
                  );
                },
              ),
              CustomButton(
                text: TitleString.start_matching,
                margin: getMargin(top: 20),
                variant: ButtonVariant.outlineTealA400,
                fontStyle: ButtonFontStyle.poppinsRegular14WhiteA700,
                onTap: () {
                  updateStage(context);
                  int tabToSelect = 3;
                  if (isFromHome) tabToSelect = 1;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LaunchScreen.routeName,
                    arguments: {
                      'tab': tabToSelect,
                    },
                    (Route<dynamic> route) => false,
                  );
                  if (tabToSelect == 3) checkLookingForSkillsUpdated(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkLookingForSkillsUpdated(BuildContext context) {
    final activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();
    if (activeUser?.looking_for_skills == null ||
        activeUser!.looking_for_skills!.isEmpty) {
      Navigator.pushNamed(
        context,
        SearchForSkillsScreen.routeName,
        arguments: {
          'isSecondTime': true,
        },
      );
    }
  }

  void updateStage(BuildContext context) {
    BlocProvider.of<GraphqlBloc>(context).add(
      const UpdateNavigationStageInfoEvent(
        stage: Constants.navigationStageShowHome,
        // stage: Constants.navigationStageQuestionnaireCompleted,

      ),
    );
  }
}
