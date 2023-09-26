import 'package:flutter/material.dart';
import '../../../utilities/transition_constant.dart';

import '../../../core/app_export.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../launch/widgets/confirm_exit_screen.dart';
import '../../questionnaire/screens/questionnaire_screen.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/custom_buttons.dart';

class AlmostThereScreen extends StatefulWidget {
  static const String routeName = '/almost_there';

  AlmostThereScreen({super.key});

  @override
  State<AlmostThereScreen> createState() => _AlmostThereScreenState();
}

class _AlmostThereScreenState extends State<AlmostThereScreen> {
  bool startAnimation = false;
  AssetImage assetImage = AssetImage(Assets.commonLogo);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(assetImage, context);
    return Stack(
      children: [
        commonBackground,
        AnimatedPositioned(
          left: getHorizontalSize(
            (startAnimation ? -176 : 300),
          ),
          top: getVerticalSize(
            630,
          ),
          duration: Duration(
              milliseconds:
                  TransitionConstant.almostThereImageTransitionDuration),
          child: Image(
            image: assetImage,
            fit: BoxFit.contain,
            width: getHorizontalSize(378.59),
            height: getVerticalSize(364.39),
            opacity: AlwaysStoppedAnimation(0.6),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: WillPopScope(
              onWillPop: () async {
                // Custom logic to determine whether to allow back navigation or not
                // Return false to restrict the back button
                //onTapDeny(context);
                confirmExit(context);
                return false;
              },
              child: contents(context)),
          appBar: CommonAppBar.appBar(
            context: context,
            visible: false,
          ),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  Future<void> confirmExit(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => ConfirmExitScreen(),
    );
  }

  Widget contents(BuildContext context) {
    return Container(
      padding: getPadding(
        left: 35,
        right: 35,
        bottom: 70,
      ),
      height: size.height,
      width: double.maxFinite,
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(
                milliseconds:
                    TransitionConstant.almostThereTextTransitionDuration),
            curve: Curves.easeIn,
            transform: Matrix4.translationValues(
                startAnimation ? 0 : MediaQuery.of(context).size.width, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: getPadding(top: 27),
                  child: Text(
                    "Almost there...",
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsSemiBold20,
                  ),
                ),
                Container(
                  margin: getMargin(top: 16),
                  child: Text(
                    "The final piece of the puzzle is our quick questionnaire.",
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsLight13,
                  ),
                ),
                Container(
                  margin: getMargin(top: 13),
                  child: Text(
                    "In business, having chemistry in your founding team is key.",
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsLight13,
                  ),
                ),
                Container(
                  margin: getMargin(top: 13),
                  child: Text(
                    "We build up a picture of your personality to find the matches that are tailored just for you.",
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsLight13,
                  ),
                ),
                Container(
                  margin: getMargin(top: 13),
                  child: Text(
                    "But... it only works if you answer honestly!",
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsSemiBold16,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          CustomButton(
            // height: getVerticalSize(47),
            text: "Let's go",
            enabled: true,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                QuestionnaireScreen.routeName,
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
