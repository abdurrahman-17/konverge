import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../models/skills/skills.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../launch/widgets/profile/chip_view_group.dart';
import '../../search_for_interests/screens/search_for_interests.dart';
import '../../search_for_skills/screens/search_for_skills.dart';

class SkillView extends StatelessWidget {
  final List<Skills> skills;
  final String title;
  final String emptyTest;
  final GestureTapCallback? tap;

  SkillView({
    super.key,
    required this.title,
    required this.skills,
    this.emptyTest = "",
    this.tap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CustomRichText(
            text: title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsRegular14WhiteA700,
          ),
        ),
        skills.isNotEmpty
            ? Padding(
                padding: getPadding(top: 9),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    runSpacing: getVerticalSize(5),
                    spacing: getHorizontalSize(5),
                    children: List<Widget>.generate(
                      skills.length,
                      (index) => ChipViewGroup(
                        skill: skills[index],
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
              )
            : emptyWidget(context),
      ],
    );
  }

  Widget emptyWidget(BuildContext context) {
    return InkWell(
      onTap: () async {
        print("title $title");
        if (title.toLowerCase().contains("interests")) {
          await Navigator.pushNamed(
            context,
            SearchForInterest.routeName,
          );
        } else {
          await Navigator.pushNamed(
            context,
            SearchForSkillsScreen.routeName,
            arguments: {
              'isSecondTime': true,
            },
          );
        }
        if (tap != null) tap!();
      },
      child: Container(
        margin: getMargin(top: 50, bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomRichText(
              text: "Complete your profile",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtPoppinsLight10,
            ),
            CustomLogo(
              svgPath: Assets.imgEditWhiteA700,
              height: getSize(12),
              width: getSize(12),
              margin: getMargin(left: 10),
            ),
          ],
        ),
      ),
    );
  }
}
