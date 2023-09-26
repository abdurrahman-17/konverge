// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../../../models/graphql/user_info.dart';
import '../../../models/pie_chart/pie_chart_model.dart';
import '../../../utilities/common_functions.dart';
import '../../../utilities/demo_utils/pie_chart_model_utils.dart';
import '../../common_widgets/custom_pie_chart.dart';

import '../../../core/app_export.dart';
import '../../common_widgets/custom_rich_text.dart';
import 'legend_dot_item_widget.dart';
import '../../common_widgets/common_circular_progress.dart';

class PieChart extends StatelessWidget {
  double total;
  String title;
  String subTitle;
  Motivation? motivation;
  bool isCurrentUser;

  PieChart({
    super.key,
    this.total = 0,
    required this.title,
    required this.subTitle,
    required this.isCurrentUser,
    this.motivation,
  });

  List<PieChartModel> charts = [];

  @override
  Widget build(BuildContext context) {
    if (motivation != null) {
      createPieChartModel();
    } else {
      total = 0;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getMotivationValue(motivation) == 0
            ? CommonCircularProgress(
                progressValue: 0,
                sweepCompleteColor: AppColors.sweepCompleteColor,
                sweepColor: AppColors.lightBlueA70002.withOpacity(0.3),
                textColor: Colors.amber,
                size: 160,
                isCurrentUser: isCurrentUser,
                widget: commonTextWidget(),
                sweepCompleteBackColor: AppColors.sweepBackCompleteColor,
              )
            : SizedBox(
                height: getSize(140),
                width: getSize(160),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPieChart(models: charts),
                    Align(
                      child: commonTextWidget(),
                    ),
                  ],
                ),
              ),
        Spacer(),
        Container(
          padding: getPadding(left: 7, bottom: 3),
          width: getHorizontalSize(146),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: getVerticalSize(9));
            },
            itemCount: charts.isEmpty ? pieChartModel.length : charts.length,
            itemBuilder: (context, index) {
              return LegendDotItemWidget(
                model: charts.isEmpty ? pieChartModel[index] : charts[index],
                total: total,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget commonTextWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomRichText(
          text: title,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: AppStyle.txtPoppinsMedium13,
        ),
        Container(
          width: getHorizontalSize(68),
          padding: getPadding(top: 3),
          child: CustomRichText(
            text: subTitle,
            textAlign: TextAlign.center,
            style: AppStyle.txtPoppinsRegular10Indigo30003,
          ),
        ),
      ],
    );
  }

  void createPieChartModel() {
    total = 700;
    charts = [];
    charts = [
      PieChartModel(
        grad: [
          AppColors.money1,
          AppColors.money1,
          AppColors.money2,
        ],
        itemColor: [
          AppColors.money1,
        ],
        txtColor: AppColors.moneyTextColor,
        name: "Money",
        value: motivation?.money.toDouble() ?? 0,
      ),
      PieChartModel(
        grad: [
          AppColors.passion1,
          AppColors.passion1,
          AppColors.passion2,
        ],
        itemColor: [
          AppColors.passion1,
        ],
        txtColor: AppColors.passionTextColor,
        name: "Passion",
        value: motivation?.passion.toDouble() ?? 0,
      ),
      PieChartModel(
        grad: [
          AppColors.freedom1,
          AppColors.freedom2,
          AppColors.freedom2,
        ],
        itemColor: [
          AppColors.freedom2,
        ],
        txtColor: AppColors.freedomTextColor,
        name: "Freedom",
        value: motivation?.freedom.toDouble() ?? 0,
      ),
      PieChartModel(
        grad: [
          AppColors.change2,
          AppColors.change2,
          AppColors.change1,
        ],
        itemColor: [
          AppColors.change2,
          AppColors.change1,
        ],
        txtColor: AppColors.changeTextColor,
        name: "Change The World",
        value: motivation?.changing_the_world.toDouble() ?? 0,
      ),
      PieChartModel(
        grad: [
          AppColors.fame1,
          AppColors.fame1,
          AppColors.fame2,
        ],
        itemColor: [
          AppColors.fame1,
          AppColors.fame1,
        ],
        txtColor: AppColors.fameTextColor,
        name: "Fame & Power",
        value: motivation?.fame_and_power.toDouble() ?? 0,
      ),
      PieChartModel(
        grad: [
          AppColors.brown1,
          AppColors.brown1,
          AppColors.brown2,
        ],
        itemColor: [
          AppColors.brown1,
          AppColors.brown2,
        ],
        txtColor: AppColors.brownTextColor,
        name: "Better lifestyle",
        value: motivation?.better_lifestyle.toDouble() ?? 0,
      ),
      PieChartModel(
        grad: [AppColors.help1, AppColors.help1, AppColors.help3],
        itemColor: [AppColors.help1, AppColors.help2, AppColors.help3],
        name: "Helping Others",
        start: Alignment.topRight,
        end: Alignment.bottomLeft,
        txtColor: AppColors.helpingTextColor,
        value: motivation?.helping_others.toDouble() ?? 0,
      )
    ];
  }
}
