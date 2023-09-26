import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../utilities/assets.dart';
import '../../utilities/colors.dart';
import '../../utilities/size_utils.dart';
import 'custom_logo.dart';

class LoaderWithLogo extends StatefulWidget {
  const LoaderWithLogo({
    super.key,
  });

  @override
  State<LoaderWithLogo> createState() => _LoaderWithLogoState();
}

class _LoaderWithLogoState extends State<LoaderWithLogo>
    with TickerProviderStateMixin {
  late Ticker _ticker;
  double angleInRadians = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      setState(() {
        angleInRadians += 0.06;
      });
    })
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      padding: getPadding(all: 3),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        image: const DecorationImage(
          image: AssetImage(
            Assets.blueGradientOne,
          ),
          opacity: 0,
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Transform.rotate(
          angle: angleInRadians,
          child: CustomLogo(
            svgPath: Assets.logoSvg,
            height: getVerticalSize(107),
            width: getHorizontalSize(107),
          ),
        ),
      ),
    );
  }
}
