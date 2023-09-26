import 'package:another_xlider/another_xlider.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../models/design_models/slider_data.dart';

class CustomSlider extends StatelessWidget {
  final SliderData data;
  final void Function(double value)? onDragComplete;

  CustomSlider({
    super.key,
    required this.data,
    this.onDragComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: getPadding(left: 35, right: 25),
          child: Text(
            data.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppStyle.txtPoppinsRegular14WhiteA700,
          ),
        ),
        Container(
          height: getVerticalSize(21),
          margin: getMargin(top: 20, left: 20, right: 25),
          child: FlutterSlider(
            min: 0,
            minimumDistance: 1,
            maximumDistance: 100,
            max: data.name == 'Hours per week' ? 80 : 100,
            tooltip: FlutterSliderTooltip(
              custom: (value) {
                final intValue = value.toInt();
                final tooltipText = data.name == 'Hours per week'
                    ? intValue.toString() + ' hrs'
                    : intValue.toString() + " %";
                return Container(
                  padding: getPadding(top: 2, bottom: 2, right: 7, left: 7),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:
                      Text(tooltipText, style: AppStyle.txtPoppinsSemiBold13),
                );
              },
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              boxStyle: FlutterSliderTooltipBox(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
            handler: FlutterSliderHandler(
              decoration: const BoxDecoration(),
              child: Container(
                height: getVerticalSize(21),
                width: getHorizontalSize(7),
                decoration: BoxDecoration(
                  color: AppColors.tealA400,
                  borderRadius: BorderRadius.circular(getHorizontalSize(3)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black90035,
                      spreadRadius: getHorizontalSize(2),
                      blurRadius: getHorizontalSize(2),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            trackBar: FlutterSliderTrackBar(
              activeTrackBarHeight: 1,
              inactiveTrackBarHeight: 1,
              inactiveTrackBar: BoxDecoration(
                color: AppColors.blueGray60001,
              ),
              activeTrackBar: BoxDecoration(
                color: AppColors.sliderActiveColor,
              ),
            ),
            values: [data.value],
            onDragCompleted: (
              int handlerIndex,
              dynamic lowerValue,
              dynamic upperValue,
            ) {
              if (onDragComplete != null) {
                onDragComplete!(lowerValue as double);
              }
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
