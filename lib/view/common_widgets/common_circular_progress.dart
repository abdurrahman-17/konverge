import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../common_widgets/complete_your_profile_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CommonCircularProgress extends StatelessWidget {
  final double progressValue;
  final Color sweepColor;
  final List<Color> sweepCompleteColor;
  final List<Color>? sweepCompleteBackColor;
  final Color textColor;
  final double size;
  final Widget? widget;
  final bool isCurrentUser;
  final bool percentageToHours;

  CommonCircularProgress({
    Key? key,
    required this.progressValue,
    required this.sweepColor,
    required this.textColor,
    required this.sweepCompleteColor,
    this.sweepCompleteBackColor,
    required this.size,
    this.widget,
    this.percentageToHours = false,
    required this.isCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getSize(size),
      width: getSize(size),
      child: Stack(
        children: [
          SfRadialGauge(
            enableLoadingAnimation: true,
            axes: [
              RadialAxis(
                showLabels: false,
                showTicks: false,
                startAngle: 0,
                endAngle: 0,
                axisLineStyle: AxisLineStyle(
                  thickness: 0.15,
                  gradient: SweepGradient(
                    colors: sweepCompleteBackColor ?? sweepCompleteColor,
                  ),
                  thicknessUnit: GaugeSizeUnit.factor,
                ),
                pointers: <GaugePointer>[
                  RangePointer(
                    value: percentageToHours
                        ? (progressValue * 100 / 80)
                        : progressValue,
                    width: 0.15,
                    color: AppColors.gray500,
                    gradient: SweepGradient(
                      colors: sweepCompleteColor,
                    ),
                    cornerStyle: percentageToHours
                        ? (progressValue.toInt() != 80
                            ? CornerStyle.bothCurve
                            : CornerStyle.bothFlat)
                        : (progressValue.toInt() != 100
                            ? CornerStyle.bothCurve
                            : CornerStyle.bothFlat),
                    sizeUnit: GaugeSizeUnit.factor,
                  )
                ],
              ),
            ],
          ),
          Align(
            child: widget ??
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    progressValue != 0
                        ? Text(
                            "${progressValue.toInt()}${percentageToHours ? ' hrs' : '%'}",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtPoppinsBold25,
                          )
                        : Visibility(
                            visible: isCurrentUser,
                            child: CompleteYourProfileWidget(
                              column: true,
                            ),
                          )
                  ],
                ),
          )
        ],
      ),
    );
  }
}
