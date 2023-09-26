import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import 'custom_rich_text.dart';

class CompleteYourProfileWidget extends StatelessWidget {
  final bool column;

  CompleteYourProfileWidget({
    super.key,
    this.column = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget completeText = CustomRichText(
      text: "Complete your profile",
      style: AppStyle.txtPoppinsLight10,
    );

    return column
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              completeText,
              CustomLogo(
                svgPath: Assets.imgEditWhiteA700,
                height: getVerticalSize(9),
                width: getHorizontalSize(10),
                margin: getMargin(left: 0, top: 15, bottom: 0),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              completeText,
              CustomLogo(
                svgPath: Assets.imgEditWhiteA700,
                height: getVerticalSize(9),
                width: getHorizontalSize(10),
                margin: getMargin(left: 15, top: 1, bottom: 4),
              ),
            ],
          );
  }
}
