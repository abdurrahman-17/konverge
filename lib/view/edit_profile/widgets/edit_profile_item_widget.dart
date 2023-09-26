import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

import '../../../models/design_models/profile_visible_data.dart';
import '../../common_widgets/custom_rich_text.dart';
import '../../common_widgets/custom_switch.dart';

// ignore: must_be_immutable
class EditProfileItemWidget extends StatelessWidget {
  ProfileVisibleData data;
  ValueChanged<bool>? onToggle;
  GestureTapCallback? onTapRowEdit;

  EditProfileItemWidget({
    super.key,
    this.onTapRowEdit,
    required this.data,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapRowEdit?.call();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomLogo(
            svgPath: Assets.imgEdit,
            height: getSize(12),
            width: getSize(12),
            margin: getMargin(top: 3, bottom: 7),
          ),
          Padding(
            padding: getPadding(left: 15),
            child: CustomRichText(
              text: data.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtPoppinsRegular15,
            ),
          ),
          const Spacer(),
          if (data.toggleShow)
            CustomSwitch(
              value: data.visibility,
              onToggle: (value) {
                data.visibility = value;
                if (onToggle != null) onToggle!(value);
              },
            ),
        ],
      ),
    );
  }
}
