import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../../../../models/design_models/user.dart';
import '../../../../utilities/title_string.dart';
import '../../../common_widgets/complete_your_profile_widget.dart';
import '../../../common_widgets/custom_rich_text.dart';

class BioGraphyWidget extends StatelessWidget {
  final Biography? biography;

  BioGraphyWidget({
    super.key,
    this.biography,
  });

  @override
  Widget build(BuildContext context) {
    return biography != null
        ? biographyWidget(biography!)
        : emptyBiographyWidget();
  }

  Widget emptyBiographyWidget() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: getPadding(left: 25, top: 14, right: 25),
            child: CustomRichText(
              text: TitleString.biography,
              style: AppStyle.txtPoppinsMedium13,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: getPadding(top: 35, right: 74),
            child: CompleteYourProfileWidget(),
          ),
        )
      ],
    );
  }

  Widget biographyWidget(Biography biography) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: getPadding(left: 25, top: 14, right: 25),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: biography.title,
                    style: TextStyle(
                      color: AppColors.whiteA700,
                      fontSize: getFontSize(13),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (biography.subTitle.toLowerCase() != 'no idea yet' ||
                      (biography.subTitle.toLowerCase() == 'no idea yet' &&
                          biography.biography.isEmpty))
                    TextSpan(
                      text: " - ${biography.subTitle}",
                      style: TextStyle(
                        color: AppColors.whiteA700,
                        fontSize: getFontSize(13),
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Container(
          margin: getMargin(left: 25, top: 8, right: 25),
          child: CustomRichText(
            text: biography.subTitle.toLowerCase() == 'no idea yet'
                ? biography.biography
                : biography.description,
            style: AppStyle.txtPoppinsLight10,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
