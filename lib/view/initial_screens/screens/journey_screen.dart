import 'package:flutter/material.dart';
import '../../../models/graphql/pre_questionnaire_info_request.dart';
import '../../../core/app_export.dart';
import '../../../utilities/enums.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/snack_bar.dart';
import 'time_for_us_screen.dart';

import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_bg_logo.dart';
import '../../common_widgets/custom_buttons.dart';

// ignore_for_file: must_be_immutable
class YourJourneyScreen extends StatefulWidget {
  static const String routeName = '/journey';
  PreQuestionnaireInfoModel requestModel;

  YourJourneyScreen({super.key, required this.requestModel});

  @override
  State<YourJourneyScreen> createState() => _YourJourneyScreenState();
}

class _YourJourneyScreenState extends State<YourJourneyScreen>
    with TickerProviderStateMixin {
  int selectedIndex = -1;
  AnimationController? _controller;
  Animation<double>? animation;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation =
        Tween<double>(begin: 0.0, end: -width.toDouble()).animate(_controller!)
          ..addListener(() {
            setState(() {});
          });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonBackground,
        CommonBgLogo(
          opacity: 0.6,
          position: CommonBgLogoPosition.topRight,
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
    return AnimatedBuilder(
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(animation!.value, 0),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: getPadding(left: 35, right: 35),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Where are you in your journey?",
                        textAlign: TextAlign.left,
                        style: AppStyle.txtPoppinsSemiBold20,
                      ),
                      Container(
                        margin: getMargin(top: 10),
                        child: Text(
                          "Apply for investment if you have a business idea ready, if not, we'll help you get started.",
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsLight13,
                        ),
                      ),
                      Container(
                        margin: getMargin(top: 26),
                        decoration: selectedIndex != 0
                            ? AppDecoration.txtOutlineTealA400.copyWith(
                                borderRadius:
                                    BorderRadiusStyle.txtRoundedBorder23,
                              )
                            : AppDecoration.txtOutlineTealA400.copyWith(
                                color: AppColors.tealA400,
                                borderRadius:
                                    BorderRadiusStyle.txtRoundedBorder23,
                              ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                          child: Container(
                            padding: getPadding(top: 12, bottom: 12),
                            child: Center(
                              child: CustomRichText(
                                text: "I'm looking to network",
                                style: TextStyle(
                                  color: selectedIndex != 0
                                      ? AppColors.whiteA700
                                      : AppColors.black900,
                                  fontSize: getFontSize(14),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: getMargin(top: 22),
                        decoration: selectedIndex != 1
                            ? AppDecoration.txtOutlineTealA400.copyWith(
                                borderRadius:
                                    BorderRadiusStyle.txtRoundedBorder23,
                              )
                            : AppDecoration.txtOutlineTealA400.copyWith(
                                color: AppColors.tealA400,
                                borderRadius:
                                    BorderRadiusStyle.txtRoundedBorder23,
                              ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                          child: Container(
                            padding: getPadding(top: 12, bottom: 12),
                            child: Center(
                              child: CustomRichText(
                                text: "I'm looking for investment",
                                style: TextStyle(
                                  color: selectedIndex != 1
                                      ? AppColors.whiteA700
                                      : AppColors.black900,
                                  fontSize: getFontSize(14),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: getPadding(left: 35, bottom: 46, right: 35),
                  child: CustomButton(
                    text: "Continue",
                    margin: getMargin(top: 20),
                    enabled: true,
                    //variant: ButtonVariant.outlineBlack90035,
                    onTap: () => onTap(context),
                  ),
                ),
              )
            ],
          ),
        );
      },
      animation: animation!,
    );
  }

  Future<void Function()?> onTap(BuildContext context) async {
    if (selectedIndex != -1) {
      if (selectedIndex == 0) {
        widget.requestModel.lookingForInvestOrPartner =
            Constants.lookingForTypeBusiness;
      } else {
        widget.requestModel.lookingForInvestOrPartner =
            Constants.lookingForTypeInvestor;
      }
      await _controller!.forward();
      await Navigator.pushNamed(
        context,
        TimeForUsScreen.routeName,
        arguments: {
          'data': widget.requestModel,
        },
      );
      await _controller!.reverse();
    } else {
      showSnackBar(message: "Please Select any option");
    }
    return null;
  }
}
