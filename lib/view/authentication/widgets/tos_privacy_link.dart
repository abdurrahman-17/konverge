import 'package:flutter/material.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../screens/privacy_policy.dart';
import '../../tos/terms_and_condition.dart';

import '../../../theme/app_style.dart';
import '../../../utilities/title_string.dart';

class TOSPrivacyLink extends StatelessWidget {
  const TOSPrivacyLink({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              TermsAndConditionScreen.routeName,
            );
          },
          child: CustomRichText(
            text: TitleString.termsOfServices,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsRegular12,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              PrivacyPolicyScreen.routeName,
            );
          },
          child: CustomRichText(
            text: TitleString.privacyPolicy,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsRegular12,
          ),
        ),
      ],
    );
  }
}
