import 'package:flutter/material.dart';

import '../../models/design_models/match_data.dart';
import '../../utilities/size_utils.dart';
import 'common_bg_widget.dart';

class MatchWidget extends StatelessWidget {
  final MatchData matchData;

  MatchWidget({
    super.key,
    required this.matchData,
  });

  @override
  Widget build(BuildContext context) {
    // double ratio = 115 / 90;
    return SizedBox(
      height: getSize(matchData.radius),
      width: getSize(matchData.radius),
      child: CommonBgWidget(
        color: matchData.color1,
        width: getSize(matchData.radius),
      ),
      // Stack(
      //   children: [
      //     Align(
      //       alignment: Alignment.topLeft,
      //       child: CommonBgWidget(
      //         color: matchData.gradCircle2[0],
      //         width: getSize(matchData.radius * ratio),
      //       ),
      //     ),
      //     Align(
      //       alignment: Alignment.topRight,
      //       child: CircleWithGrad(
      //         radius: matchData.radius,
      //         grad: matchData.gradCircle2,
      //         color: matchData.color2,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
