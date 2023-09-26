import 'package:flutter/material.dart';
import '../../utilities/assets.dart';

class RotatingImageLoadingWidget extends StatefulWidget {
  const RotatingImageLoadingWidget({super.key});

  @override
  RotatingImageLoadingWidgetState createState() =>
      RotatingImageLoadingWidgetState();
}

class RotatingImageLoadingWidgetState extends State<RotatingImageLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animationController,
      child: Image.asset(
        Assets.imgVector,
        width: 50.0,
        height: 50.0,
      ),
    );
  }
}
