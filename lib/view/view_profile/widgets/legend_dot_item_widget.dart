import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

import '../../../models/pie_chart/pie_chart_model.dart';
import '../../common_widgets/custom_rich_text.dart';

class LegendDotItemWidget extends StatelessWidget {
  const LegendDotItemWidget({
    super.key,
    required this.model,
    this.total = 0,
  });

  final PieChartModel model;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: getSize(10),
              width: getSize(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: model.start??Alignment.bottomLeft,
                  end: model.end??Alignment.topRight,
                  colors: model.grad,
                ),
                borderRadius: BorderRadius.all(Radius.circular(getSize(10))),
              ),
            ),
            Padding(
              padding: getPadding(left: 7),
              child: CustomRichText(
                text: model.name,
                style: AppStyle.txtPoppinsBold10.copyWith(color: model.txtColor),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        if (total != 0)
          Padding(
            padding: getPadding(left: 7),
            child: Text(
              "${model.value.toDouble().toStringAsFixed(0)}%",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: AppStyle.txtPoppinsBold9WhiteA700,
            ),
          ),
      ],
    );
  }

  double findPercentage(double value) {
    if (total == 0) {
      return 0;
    } else {
      return (value * 100) / total;
    }
  }
}
