import 'package:flutter/material.dart';
import '../../authentication/screens/privacy_policy.dart';
import '../../tos/terms_and_condition.dart';

import '../../../core/app_export.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';

class LegalScreen extends StatelessWidget {
  static const String routeName = "/legal";

  const LegalScreen({super.key});

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

  Widget contents(BuildContext context) {
    return Container(
      padding: getPadding(left: 35, right: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Legal",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsSemiBold20,
          ),
          Padding(
            padding: getPadding(top: 12, bottom: 20),
            child: Text(
              "Find all the legal stuff that keeps you protected",
              textAlign: TextAlign.left,
              style: AppStyle.txtPoppinsLight13WhiteA700,
            ),
          ),
          InkWell(
            child: item(text: "Terms of service"),
            onTap: () {
              Navigator.pushNamed(
                context,
                TermsAndConditionScreen.routeName,
              );
            },
          ),
          // InkWell(
          //   child: item(text: "Terms and conditions"),
          //   onTap: () {
          //     Navigator.pushNamed(
          //       context,
          //       TermsAndConditionScreen.routeName,
          //     );
          //   },
          // ),
          InkWell(
            child: item(text: "Privacy policy"),
            onTap: () {
              Navigator.pushNamed(
                context,
                PrivacyPolicyScreen.routeName,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget item({required String text}) {
    return Container(
      margin: getMargin(top: 11),
      padding: getPadding(
        top: 15,
        right: 20,
        left: 23,
        bottom: 15,
      ),
      decoration: AppDecoration.outlineGray80001
          .copyWith(borderRadius: BorderRadiusStyle.circleBorder52),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsMedium13Gray500,
          ),
          CustomLogo(
            svgPath: Assets.imgArrowRightTealA400,
            height: getVerticalSize(8),
            width: getHorizontalSize(4),
          ),
        ],
      ),
    );
  }
}
