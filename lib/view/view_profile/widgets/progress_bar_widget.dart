import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

import '../../common_widgets/common_circular_progress.dart';

class ProgressBarWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final double size;
  final double progress;
  final bool isCurrentUser;
  final bool percentageToHours;

  ProgressBarWidget({
    super.key,
    required this.title,
    this.subTitle = "",
    this.size = 142,
    this.progress = 0,
    required this.isCurrentUser,
    this.percentageToHours = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonCircularProgress(
          percentageToHours: percentageToHours,
          progressValue: progress,
          sweepCompleteColor: AppColors.sweepCompleteColor,
          sweepColor: AppColors.lightBlueA70002.withOpacity(0.3),
          textColor: Colors.amber,
          size: size,
          isCurrentUser: isCurrentUser,
          sweepCompleteBackColor: AppColors.sweepBackCompleteColor,
        ),
        Padding(
          padding: getPadding(top: 16),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsMedium13,
          ),
        ),
        Container(
          width: getHorizontalSize(112),
          padding: getPadding(top: 3),
          child: Text(
            subTitle,
            textAlign: TextAlign.center,
            style: AppStyle.txtPoppinsRegular10Indigo30003,
          ),
        ),
      ],
    );
  }
}
