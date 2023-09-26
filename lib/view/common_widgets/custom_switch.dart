import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../core/app_export.dart';

class CustomSwitch extends StatefulWidget {
  CustomSwitch({
    super.key,
    this.alignment,
    this.margin,
    this.value,
    this.onChanged,
    this.onToggle,
  });

  final ValueChanged<bool>? onToggle;
  final Alignment? alignment;
  final EdgeInsetsGeometry? margin;
  bool? value;
  final Function(bool)? onChanged;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return widget.alignment != null
        ? Align(
            alignment: widget.alignment ?? Alignment.center,
            child: _buildSwitchWidget(),
          )
        : _buildSwitchWidget();
  }

  Widget _buildSwitchWidget() {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: FlutterSwitch(
        value: widget.value ?? false,
        height: getHorizontalSize(20),
        width: getHorizontalSize(33),
        toggleSize: 17.42,
        borderRadius: getHorizontalSize(10.00),
        activeColor: AppColors.tealA400,
        activeToggleColor: AppColors.whiteA700,
        inactiveColor: AppColors.black900,
        inactiveToggleColor: AppColors.whiteA700,
        padding: 2,
        onToggle: (value) {
          setState(() {
            widget.value = value;
            widget.onToggle!(value);
          });
        },
      ),
    );
  }
}
