// import 'dart:ui' as ui;

import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  Color color;
  RPSCustomPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.6936948, size.height * 0.5136174);
    path_0.cubicTo(
      size.width * 0.7094009,
      size.height * 0.3339922,
      size.width * 0.4784643,
      size.height * 0.1814130,
      size.width * 0.2894383,
      size.height * 0.3131104,
    );
    path_0.cubicTo(
      size.width * 0.2746261,
      size.height * 0.3234304,
      size.width * 0.2600696,
      size.height * 0.3354965,
      size.width * 0.2459104,
      size.height * 0.3494330,
    );
    path_0.cubicTo(
      size.width * 0.1360470,
      size.height * 0.4817157,
      size.width * 0.1309104,
      size.height * 0.7396470,
      size.width * 0.3503930,
      size.height * 0.8864870,
    );
    path_0.cubicTo(
      size.width * 0.6402965,
      size.height * 1.021148,
      size.width * 0.8884696,
      size.height * 0.8708522,
      size.width,
      size.height * 0.5529791,
    );
    path_0.cubicTo(
        size.width * 0.9590348,
        size.height * 0.7931496,
        size.width * 0.8342130,
        size.height * 0.9664783,
        size.width * 0.5676861,
        size.height);
    path_0.cubicTo(
      size.width * 0.2369009,
      size.height * 1.000739,
      size.width * 0.08234591,
      size.height * 0.7745617,
      size.width * 0.1058452,
      size.height * 0.5224478,
    );
    path_0.cubicTo(
      size.width * 0.1346661,
      size.height * 0.2777704,
      size.width * 0.3968765,
      size.height * 0.1108626,
      size.width * 0.6031478,
      size.height * 0.2612043,
    );
    path_0.cubicTo(
      size.width * 0.6890513,
      size.height * 0.3238165,
      size.width * 0.7117139,
      size.height * 0.4068461,
      size.width * 0.6936948,
      size.height * 0.5136174,
    );
    path_0.close();
    path_0.moveTo(
      size.width * 0.3814470,
      size.height * 0.7082609,
    );
    path_0.cubicTo(
      size.width * 0.5109670,
      size.height * 0.8244713,
      size.width * 0.7604913,
      size.height * 0.7006878,
      size.width * 0.7592661,
      size.height * 0.4846452,
    );
    path_0.cubicTo(
      size.width * 0.7582617,
      size.height * 0.3083017,
      size.width * 0.6779009,
      size.height * 0.2012826,
      size.width * 0.4920870,
      size.height * 0.1675730,
    );
    path_0.cubicTo(
      size.width * 0.2487878,
      size.height * 0.1518243,
      size.width * 0.1225130,
      size.height * 0.2705922,
      size.width * 0.06247748,
      size.height * 0.4917139,
    );
    path_0.cubicTo(
      size.width * 0.03844009,
      size.height * 0.6071383,
      size.width * 0.05589687,
      size.height * 0.8116391,
      size.width * 0.2181226,
      size.height * 0.9629478,
    );
    path_0.cubicTo(
      size.width * 0.01729574,
      size.height * 0.8109087,
      size.width * -0.05207600,
      size.height * 0.6153730,
      size.width * 0.04030852,
      size.height * 0.3527983,
    );
    path_0.cubicTo(
      size.width * 0.1390174,
      size.height * 0.1283061,
      size.width * 0.3585861,
      size.height * 0.07385557,
      size.width * 0.5474061,
      size.height * 0.1130957,
    );
    path_0.cubicTo(
      size.width * 0.7297809,
      size.height * 0.1612174,
      size.width * 0.8441826,
      size.height * 0.3028783,
      size.width * 0.8081991,
      size.height * 0.5325722,
    );
    path_0.cubicTo(
      size.width * 0.7351374,
      size.height * 0.8041322,
      size.width * 0.4581278,
      size.height * 0.7957696,
      size.width * 0.3814470,
      size.height * 0.7082609,
    );
    path_0.close();
    path_0.moveTo(
      size.width * 0.3811670,
      size.height * 0.3199478,
    );
    path_0.cubicTo(
      size.width * 0.3002826,
      size.height * 0.4010991,
      size.width * 0.2311809,
      size.height * 0.4884252,
      size.width * 0.2616730,
      size.height * 0.6279478,
    );
    path_0.cubicTo(
      size.width * 0.3016870,
      size.height * 0.7603974,
      size.width * 0.4472522,
      size.height * 0.8544304,
      size.width * 0.6085591,
      size.height * 0.8082417,
    );
    path_0.cubicTo(
      size.width * 0.7190600,
      size.height * 0.7766035,
      size.width * 0.8168252,
      size.height * 0.6715896,
      size.width * 0.8515991,
      size.height * 0.5599870,
    );
    path_0.cubicTo(
      size.width * 0.9625217,
      size.height * 0.2039852,
      size.width * 0.5615757,
      size.height * -0.03531817,
      size.width * 0.2407670,
      size.height * 0.05108348,
    );
    path_0.cubicTo(
      size.width * 0.7201200,
      size.height * -0.1583313,
      size.width * 1.093539,
      size.height * 0.3199487,
      size.width * 0.8614417,
      size.height * 0.6916870,
    );
    path_0.cubicTo(
      size.width * 0.7200800,
      size.height * 0.8974522,
      size.width * 0.5466165,
      size.height * 0.9384957,
      size.width * 0.3429078,
      size.height * 0.8243165,
    );
    path_0.cubicTo(
      size.width * 0.2155304,
      size.height * 0.7297017,
      size.width * 0.1800757,
      size.height * 0.5914852,
      size.width * 0.2322852,
      size.height * 0.4593722,
    );
    path_0.cubicTo(
      size.width * 0.2715817,
      size.height * 0.3841383,
      size.width * 0.3221330,
      size.height * 0.3402330,
      size.width * 0.3811670,
      size.height * 0.3199478,
    );
    path_0.close();
    path_0.moveTo(
      size.width * 0.4884739,
      size.height * 0.3501904,
    );
    path_0.cubicTo(
      size.width * 0.5807383,
      size.height * 0.3501904,
      size.width * 0.6555339,
      size.height * 0.4275304,
      size.width * 0.6555339,
      size.height * 0.5229330,
    );
    path_0.cubicTo(
      size.width * 0.6555339,
      size.height * 0.6183365,
      size.width * 0.5807383,
      size.height * 0.6956757,
      size.width * 0.4884739,
      size.height * 0.6956757,
    );
    path_0.cubicTo(
      size.width * 0.3962087,
      size.height * 0.6956757,
      size.width * 0.3214139,
      size.height * 0.6183365,
      size.width * 0.3214139,
      size.height * 0.5229330,
    );
    path_0.cubicTo(
      size.width * 0.3214139,
      size.height * 0.4275304,
      size.width * 0.3962087,
      size.height * 0.3501904,
      size.width * 0.4884739,
      size.height * 0.3501904,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = color.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
