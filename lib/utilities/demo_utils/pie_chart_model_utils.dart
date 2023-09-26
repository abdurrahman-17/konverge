import '../../models/pie_chart/pie_chart_model.dart';
import '../colors.dart';

List<PieChartModel> pieChartModel = [
  PieChartModel(
    grad: [
      AppColors.amber700,
      AppColors.yellow500,
    ],
    itemColor: [
      AppColors.brown1,
      AppColors.brown2,
    ],
    txtColor: AppColors.passion2,
    name: "Money",
    value: 23,
  ),
  PieChartModel(
    grad: [
      AppColors.redA400,
      AppColors.pinkA200,
    ],
    txtColor: AppColors.passion2,
    itemColor: [
      AppColors.brown1,
      AppColors.brown2,
    ],
    name: "Passion",
    value: 22,
  ),
  PieChartModel(
    grad: [
      AppColors.lightBlueA70001,
      AppColors.lightBlue100,
    ],
    txtColor: AppColors.passion2,
    itemColor: [
      AppColors.brown1,
      AppColors.brown2,
    ],
    name: "Freedom",
    value: 10,
  ),
  PieChartModel(
    grad: [
      AppColors.greenA20000,
      AppColors.greenA20000,
    ],
    txtColor: AppColors.passion2,
    itemColor: [
      AppColors.brown2,
      AppColors.brown2,
    ],
    name: "Change The World",
    value: 12,
  ),
  PieChartModel(
    grad: [
      AppColors.purpleA700,
      AppColors.purpleA700,
    ],
    txtColor: AppColors.passion2,
    itemColor: [
      AppColors.brown1,
      AppColors.brown1,
    ],
    name: "Fame & Power",
    value: 11,
  ),
  PieChartModel(
    grad: [
      AppColors.deepOrange300,
      AppColors.deepOrange300,
    ],
    txtColor: AppColors.passion2,
    itemColor: [
      AppColors.brown1,
      AppColors.brown2,
    ],
    name: "Better lifestyle",
    value: 7,
  ),
  PieChartModel(
      grad: [AppColors.gray500, AppColors.whiteA700],
      name: "Helping Others",
      itemColor: [
        AppColors.brown1,
        AppColors.brown2,
      ],
      txtColor: AppColors.passion2,
      value: 14)
];
