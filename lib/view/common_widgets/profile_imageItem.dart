import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'common_bg_widget.dart';
import '../../models/design_models/match_data.dart';

import '../../utilities/size_utils.dart';

class ProfileImageItem extends StatelessWidget {
  ProfileImageItem({
    super.key,
    this.child,
    required this.matchData,
    required this.height,
  });

  final Widget? child;
  final MatchData matchData;
  final double height;

  @override
  Widget build(BuildContext context) {
    double ratio = 115 / 90;
    return SizedBox(
      height: getSize(matchData.radius * ratio),
      width: getSize(matchData.radius * ratio),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            child: CommonBgWidget(
              color: matchData.gradCircle2[0],
              width: getSize(matchData.radius * ratio),
            ),
          ),
          if (child != null) Align(child: child),
        ],
      ),
    );
  }
}
