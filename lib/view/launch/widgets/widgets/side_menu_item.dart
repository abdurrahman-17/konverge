import 'package:flutter/material.dart';

import '../../../../theme/app_style.dart';
import '../../../common_widgets/custom_rich_text.dart';

class SideMenuItem extends StatelessWidget {
  final void Function()? onTap;
  final String label;
  final EdgeInsetsGeometry padding;
  final TextStyle? style;

  const SideMenuItem({
    super.key,
    this.onTap,
    required this.label,
    required this.padding,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: CustomRichText(
          text: label,
          style: style ?? AppStyle.txtPoppinsRegular14WhiteA700,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
