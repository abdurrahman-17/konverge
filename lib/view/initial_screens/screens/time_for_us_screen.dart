import 'package:flutter/material.dart';
import '../../../models/graphql/pre_questionnaire_info_request.dart';
import '../../../core/app_export.dart';
import '../../../utilities/enums.dart';
import '../../common_widgets/custom_buttons.dart';
import '../widget/text_with_icon.dart';
import '../../search_for_skills/screens/search_for_skills.dart';

import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';

class TimeForUsScreen extends StatefulWidget {
  static const String routeName = '/time_for_us';
  final PreQuestionnaireInfoModel requestModel;

  TimeForUsScreen({
    super.key,
    required this.requestModel,
  });

  @override
  State<TimeForUsScreen> createState() => _TimeForUsScreenState();
}

class _TimeForUsScreenState extends State<TimeForUsScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? animation;
  AnimationController? _controller1;
  Animation<double>? animation1;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _controller1 = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animation =
        Tween<double>(begin: 0.0, end: -width.toDouble()).animate(_controller!)
          ..addListener(() {
            setState(() {});
          });
    animation1 = Tween<double>(begin: 0.0, end: getVerticalSize(856))
        .animate(_controller1!)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
    _controller1!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonBackground,
        AnimatedBuilder(
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(getHorizontalSize(184),
                  -getVerticalSize(226.19) + animation1!.value),
              child: Stack(
                children: [
                  CommonBgLogo(
                    opacity: 0.6,
                    position: CommonBgLogoPosition.center,
                  ),
                ],
              ),
            );
          },
          animation: animation1!,
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
          child: SizedBox(
            height: size.height,
            width: double.maxFinite,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  child: Padding(
                    padding: getPadding(left: 35, right: 35, bottom: 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Time for us to get to know you",
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsSemiBold20,
                        ),
                        Padding(
                          padding: getPadding(top: 13),
                          child: Text(
                            "We will ask a series of questions about",
                            // overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtPoppinsLight13WhiteA700,
                          ),
                        ),
                        Padding(
                          padding: getPadding(top: 14),
                          child: const TextWithIcon(
                            text: "Your skillset",
                          ),
                        ),
                        Padding(
                          padding: getPadding(top: 8),
                          child: const TextWithIcon(
                            text: "Skills you are looking for in a match",
                          ),
                        ),
                        Padding(
                          padding: getPadding(top: 8),
                          child: const TextWithIcon(
                            text: "Your personality",
                          ),
                        ),
                        Container(
                          width: getHorizontalSize(295),
                          margin: getMargin(top: 19, right: 9),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "This helps us find the perfect matches for you to increase your chance of ",
                                  style: TextStyle(
                                    color: AppColors.whiteA700,
                                    fontSize: getFontSize(13),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                TextSpan(
                                  text: "business success.",
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
                        const Spacer(),
                        CustomButton(
                          // height: getVerticalSize(47),
                          text: "Let's go",
                          enabled: true,
                          onTap: () async {
                            _controller!.forward();
                            await _controller1!.forward();
                            await Navigator.pushNamed(
                              context,
                              SearchForSkillsScreen.routeName,
                              arguments: {
                                'data': widget.requestModel,
                              },
                            );
                            _controller!.reverse();
                            await _controller1!.reverse();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      animation: animation!,
    );
  }
}
