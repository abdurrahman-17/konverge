import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utilities/assets.dart';
import '../../utilities/size_utils.dart';
import 'custom_logo.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({
    Key? key,
    this.width,
    this.height,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 500),
    this.controller,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Widget? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..forward()
      ..repeat(reverse: false);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
        child: _itemBuilder(),
      ),
    );
  }

  Widget _itemBuilder() =>
      widget.itemBuilder ??
      CustomLogo(
        svgPath: Assets.imgVector,
        height: widget.height ?? getVerticalSize(103),
        width: widget.width ?? getHorizontalSize(107),
        margin: getMargin(top: 1),
        onTap: () {},
      );
}
