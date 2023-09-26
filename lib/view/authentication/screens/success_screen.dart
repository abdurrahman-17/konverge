import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../initial_screens/screens/stay_up_to_date.dart';
import '../../../utilities/enums.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/custom_icon_button.dart';

class SuccessScreen extends StatefulWidget {
  static const String routeName = 'success_screen';

  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with TickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController!)
          ..addListener(() {
            setState(() {});
          });
    Timer(const Duration(seconds: 1), () async {
      await animationController!.reverse();
      Navigator.pushNamedAndRemoveUntil(
          context, StayUpToDate.routeName, (Route<dynamic> route) => false);
    });
    animationController!.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        commonBackground,
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: contents(context),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget contents(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: getPadding(left: 35, right: 35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
              animation: animation!,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Center(
                    //   child: Visibility(
                    //     visible: animationController!.value < 0.1,
                    //     child: CustomLogo(
                    //       svgPath: Assets.imgVector,
                    //       height: getVerticalSize(103),
                    //       width: getHorizontalSize(107),
                    //       margin: getMargin(top: 1),
                    //       onTap: () {},
                    //     ),
                    //   ),
                    // ),
                    ScaleTransition(
                      scale: animation!,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Container(
                          padding: getPadding(
                            left: 107,
                            top: 93,
                            right: 107,
                            bottom: 93,
                          ),
                          decoration: AppDecoration.outlineBlack900351.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder35,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconButton(
                                height: getHorizontalSize(64),
                                width: getHorizontalSize(64),
                                shape: IconButtonShape.circleBorder32,
                                padding: IconButtonPadding.paddingAll24,
                                child: CustomLogo(
                                  svgPath: Assets.imgCheckMark,
                                  height: getHorizontalSize(64),
                                  width: getHorizontalSize(64),
                                ),
                              ),
                              Padding(
                                padding: getPadding(top: 13),
                                child: CustomRichText(
                                  text: 'Success!',
                                  style: AppStyle.txtPoppinsMedium20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }
}
