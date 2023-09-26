import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'rps_custom_painter.dart';

class CommonBgWidget extends StatelessWidget {
  final Color color;
  final double? width;

  CommonBgWidget({
    super.key,
    required this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        width ?? getHorizontalSize(100),
        width ?? getHorizontalSize(100),
      ),
      painter: RPSCustomPainter(color: color),
    );
  }
}
