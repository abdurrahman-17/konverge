import 'package:flutter/material.dart';

import '../../../../theme/app_style.dart';
import '../../../../utilities/assets.dart';
import '../../../../utilities/size_utils.dart';
import '../../common_widgets/custom_logo.dart';
import '../../common_widgets/custom_rich_text.dart';

class TextWithIcon extends StatelessWidget {
  final String? text;
  final String? icon;

  const TextWithIcon({
    super.key,
    this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: getMargin(right: 15),
          child: CustomLogo(
            imagePath: icon ?? Assets.imgRadioSelect,
            width: getHorizontalSize(13),
            height: getHorizontalSize(13),
          ),
        ),
        CustomRichText(
          text: text ?? "",
          style: AppStyle.txtPoppinsSemiBold13,
        ),
      ],
    );
  }
}
