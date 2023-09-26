import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/pie_chart/pie_chart_model.dart';

class CustomPieChart extends StatelessWidget {
  final double size;
  final List<PieChartModel> models;

  CustomPieChart({
    super.key,
    this.size = 170,
    required this.models,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getSize(size),
      height: getSize(size),
      child: SfCircularChart(
        legend: Legend(isVisible: false),
        series: <DoughnutSeries<PieChartModel, String>>[
          DoughnutSeries<PieChartModel, String>(
            //explode: true,
            strokeColor: AppColors.black9007c,
            //  explodeIndex: 0,
            dataSource: models,
            xValueMapper: (PieChartModel data, _) => data.name,
            yValueMapper: (PieChartModel data, _) => data.value,
            pointColorMapper: (PieChartModel data, i) => data.itemColor[0],
            cornerStyle: CornerStyle.bothCurve,
            innerRadius: "85%",
            // radius: '50%',
            // pointRenderMode: PointRenderMode.segment,
            strokeWidth: getSize(2),
            radius: getSize(size / 2).toString(),
            dataLabelMapper: (PieChartModel data, _) => data.name,
            dataLabelSettings: const DataLabelSettings(),
          ),
        ],
      ),
    );
  }
}
