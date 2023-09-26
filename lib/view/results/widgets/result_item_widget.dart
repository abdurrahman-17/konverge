import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

import '../../../models/skills/skills.dart';
import '../../common_widgets/custom_rich_text.dart';

// ignore: must_be_immutable
class ResultItemWidget extends StatelessWidget {
  Skills skill;
  int index;
  Color? bgColor;

  ResultItemWidget({
    super.key,
    required this.skill,
    required this.index,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.transparent,
        cardColor: Colors.transparent,
      ),
      child: Container(
        decoration: AppDecoration.outlineBlack90026_3.copyWith(
          borderRadius: BorderRadiusStyle.circleBorder17,
        ),
        child: Row(
          children: [
            Container(
              width: getSize(34),
              padding: getPadding(top: 6, bottom: 6),
              decoration: AppDecoration.txtOutlineBlack90026.copyWith(
                borderRadius: BorderRadiusStyle.txtCircleBorder17,
              ),
              child: Center(
                child: CustomRichText(
                  text: "$index",
                  style: AppStyle.txtPoppinsBold14,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: getPadding(top: 6, bottom: 6),
              child: CustomRichText(
                text: skill.skill,
                style: AppStyle.txtPoppinsRegular13,
                textAlign: TextAlign.left,
              ),
            ),
            CustomLogo(
              svgPath: Assets.imgGroup451,
              height: getVerticalSize(8),
              width: getHorizontalSize(4),
              margin: getMargin(
                left: 19,
                top: 13,
                right: 16,
                bottom: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
