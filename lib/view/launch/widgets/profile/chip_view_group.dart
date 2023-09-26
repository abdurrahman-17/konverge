import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';

import '../../../../models/skills/skills.dart';
import '../../../common_widgets/custom_rich_text.dart';

class ChipViewGroup extends StatelessWidget {
  ChipViewGroup({
    super.key,
    required this.skill,
    this.onTap,
  });

  final Skills skill;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.transparent,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: getPadding(top: 7, bottom: 7, right: 13, left: 13),
          decoration: AppDecoration.txtOutlineBlack90027.copyWith(
            borderRadius: BorderRadiusStyle.txtCircleBorder17,
          ),
          child: FittedBox(
            child: Row(
              children: [
                CustomRichText(
                  text: skill.skill,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black900,
                    fontSize: getFontSize(9),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: getHorizontalSize(10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
