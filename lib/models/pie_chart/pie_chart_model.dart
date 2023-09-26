import 'package:flutter/material.dart';

class PieChartModel {
  PieChartModel(
      {required this.grad,
      required this.name,
      required this.value,
      required this.itemColor,
      required this.txtColor,
      this.start,
      this.end});

  AlignmentGeometry? start;
  AlignmentGeometry? end;
  List<Color> grad;
  List<Color> itemColor;
  String name;
  double value;
  Color txtColor;
}
