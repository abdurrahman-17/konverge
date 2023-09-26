import 'dart:ui';

class MatchData {
  List<Color> gradCircle1;
  List<Color> gradCircle2;
  Color color1;
  Color color2;
  double radius;
  double? width;

  MatchData({
    required this.gradCircle1,
    required this.gradCircle2,
    required this.color1,
    required this.color2,
    this.radius = 39,
    this.width,
  });
}
