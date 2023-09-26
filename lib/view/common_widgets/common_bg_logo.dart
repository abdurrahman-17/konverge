import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../utilities/enums.dart';

class CommonBgLogo extends StatelessWidget {
  final double opacity;
  final CommonBgLogoPosition position;
  final String image;

  CommonBgLogo({
    super.key,
    this.opacity = 1,
    this.position = CommonBgLogoPosition.topLeft,
    this.image = Assets.commonLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // right: getHorizontalSize(position == CommonBgLogoPosition.topRight?),
      left: getHorizontalSize((position == CommonBgLogoPosition.topLeft ||
              position == CommonBgLogoPosition.bottomLeft)
          ? -176
          : (position == CommonBgLogoPosition.topRight ||
                  position == CommonBgLogoPosition.bottomRight)
              ? 184
              : 0),
      top: getVerticalSize(
        position == CommonBgLogoPosition.topLeft ||
                position == CommonBgLogoPosition.topCenter ||
                position == CommonBgLogoPosition.topRight
            ? -226.19
            : position == CommonBgLogoPosition.bottomRight ||
                    position == CommonBgLogoPosition.bottomLeft ||
                    position == CommonBgLogoPosition.bottomCenter
                ? 630
                : 0,
      ),
      child: Image.asset(
        image,
        fit: BoxFit.contain,
        width: getHorizontalSize(378.59),
        height: getVerticalSize(364.39),
        opacity: AlwaysStoppedAnimation(opacity),
      ),
    );
  }
}
