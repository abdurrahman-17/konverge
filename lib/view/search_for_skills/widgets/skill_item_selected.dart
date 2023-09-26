import 'package:flutter/material.dart';

import '../../../models/skills/skills.dart';
import '../../../theme/app_style.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/size_utils.dart';

class SkillItemSelected extends StatelessWidget {
  final Skills skill;
  final GestureTapCallback? onTap;

  SkillItemSelected({
    super.key,
    required this.skill,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: getPadding(top: 5, bottom: 5, right: 10, left: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.whiteA7007f,
          ),
          borderRadius: BorderRadius.circular(
            getHorizontalSize(14),
          ),
        ),
        child: FittedBox(
          child: Row(
            children: [
              Text(skill.skill,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppStyle.txtPoppinsRegular10WhiteA700),
              SizedBox(width: getHorizontalSize(10)),
              InkWell(
                onTap: onTap,
                child: Icon(
                  Icons.close,
                  size: getHorizontalSize(12),
                  color: AppColors.whiteA700,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
