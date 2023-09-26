import 'package:flutter/material.dart';

import '../../theme/app_decoration.dart';
import '../../utilities/size_utils.dart';

class CircleWithGrad extends StatelessWidget {
  final double radius;
  final List<Color> grad;
  final Color color;

  CircleWithGrad({
    super.key,
    required this.radius,
    required this.grad,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getSize(radius),
      width: getSize(radius),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(getHorizontalSize(radius)),
        border: Border.all(
          color: color,
          width: getHorizontalSize(1),
          strokeAlign: strokeAlignOutside,
        ),
        gradient: LinearGradient(
          begin: const Alignment(0.5, 0),
          end: const Alignment(1.74, 1.26),
          colors: grad,
        ),
      ),
    );
  }
}
