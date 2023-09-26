import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CircleIndicator extends StatelessWidget {
  final String? count;

  CircleIndicator(this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5.0),
      width: 15.0,
      height: 15.0,
      decoration: new BoxDecoration(
        color: AppColors.green400,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 3),
        child: Text(
          count.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 8.0),
        ),
      ),
    );
  }
}
