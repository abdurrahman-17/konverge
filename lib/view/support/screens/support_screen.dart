import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utilities/common_functions.dart';
import '../../../utilities/title_string.dart';
import '../../common_widgets/snack_bar.dart';
import '../../../core/app_export.dart';
import '../../../utilities/styles/common_styles.dart';
import '../../common_widgets/common_app_bar.dart';
import '../../common_widgets/common_bg_logo.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  static const String routeName = "/support";

  @override
  State<SupportScreen> createState() => _SupportScreen();
}

class _SupportScreen extends State<SupportScreen> {
  DateTime? firstClickTime;
  bool isButtonDisabled = false;
  Timer? timer;

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
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
          body: contents(context),
          appBar: CommonAppBar.appBar(context: context),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget contents(BuildContext context) {
    return Container(
      padding: getPadding(left: 35, right: 35, bottom: 23),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: getPadding(top: 0),
            child: Text(
              "Support",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtPoppinsSemiBold20,
            ),
          ),
          Container(
            width: getHorizontalSize(288),
            padding: getPadding(top: 10, bottom: 20),
            child: Text(
              "This is your space to fire away with questions and get answers.",
              textAlign: TextAlign.left,
              style: AppStyle.txtPoppinsLight13,
            ),
          ),
          Text(
            "FAQ's",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsSemiBold20,
          ),
          Container(
            margin: getMargin(top: 10),
            padding: getPadding(left: 23, top: 17, right: 23, bottom: 17),
            decoration: AppDecoration.fillBlack90068.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder23,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: getHorizontalSize(164),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Have another query? \nFeel free to email us\n",
                          style: TextStyle(
                            color: AppColors.gray92A6C4,
                            fontSize: getFontSize(12),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: TitleString.supportEmailID,
                          style: TextStyle(
                            color: AppColors.whiteA700,
                            fontSize: getFontSize(13),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                CustomLogo(
                  svgPath: Assets.imgVolume,
                  height: getVerticalSize(20),
                  width: getHorizontalSize(15),
                  onTap: () async {
                    if (!isButtonDisabled &&
                        !isRedundantClickForCopyEmail(
                            firstClickTime, DateTime.now())) {
                      // Enable the button after 5 seconds
                      timer = Timer(Duration(seconds: 5), () {
                        setState(() {
                          isButtonDisabled = false;
                        });
                      });
                      setState(() {
                        isButtonDisabled = true;
                        firstClickTime = DateTime.now();
                      });
                      await Clipboard.setData(
                        const ClipboardData(
                          text: TitleString.supportEmailID,
                        ),
                      );
                      HapticFeedback.vibrate();
                      showSnackBar(
                        message: TitleString.infoEmailIdCopied,
                      );
                    } else {
                      isRedundantClickForCopyEmail(
                          firstClickTime, DateTime.now());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
