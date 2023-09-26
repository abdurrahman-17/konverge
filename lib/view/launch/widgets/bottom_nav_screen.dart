import 'dart:io';

import 'package:flutter/material.dart';

import '../../../theme/app_decoration.dart';
import '../../../utilities/assets.dart';
import '../../../utilities/size_utils.dart';
import 'widgets/bottom_nav_item.dart';

class BottomNavScreen extends StatelessWidget {
  final GestureTapCallback? onTapHome;
  final GestureTapCallback? onTapProfile;
  final GestureTapCallback? onTapMatch;
  final GestureTapCallback? onTapSearch;
  final int selectedIndex;

  BottomNavScreen({
    super.key,
    required this.selectedIndex,
    this.onTapHome,
    this.onTapMatch,
    this.onTapProfile,
    this.onTapSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getPadding(
        left: 45,
        top: 15,
        right: 45,
        bottom: Platform.isIOS ? 25 : 15,
      ),
      decoration: AppDecoration.fillBlack90099
          .copyWith(borderRadius: BorderRadiusStyle.customBorderTL35),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BottomNavItem(
                onTap: onTapHome,
                image: Assets.imgHome,
                label: "Home",
                isSelected: selectedIndex == 0,
              ),
              BottomNavItem(
                onTap: onTapMatch,
                image: Assets.imgMatchIcon,
                label: "Match",
                isSelected: selectedIndex == 1,
              ),
              BottomNavItem(
                onTap: onTapSearch,
                image: Assets.imgSearch,
                label: "Search",
                isSelected: selectedIndex == 2,
              ),
              BottomNavItem(
                onTap: onTapProfile,
                image: Assets.imgUser,
                label: "Profile",
                isSelected: selectedIndex == 3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
