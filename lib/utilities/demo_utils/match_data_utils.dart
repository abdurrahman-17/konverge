import '../../models/design_models/match_data.dart';

import '../colors.dart';
import '../size_utils.dart';

MatchData matchDataBlueRedBig = MatchData(
  radius: 120,
  gradCircle1: [AppColors.lightBlueA700, AppColors.blue30000],
  gradCircle2: [AppColors.red500, AppColors.red20058, AppColors.red300],
  color1: AppColors.lightBlue600B2,
  color2: AppColors.redA200,
);
MatchData matchDataBlueRed = MatchData(
  radius: 50,
  gradCircle1: [AppColors.lightBlueA700, AppColors.blue30000],
  gradCircle2: [AppColors.red500, AppColors.red20058, AppColors.red300],
  color1: AppColors.lightBlue600B2,
  color2: AppColors.redA200,
);
MatchData matchDataOrangeGreen = MatchData(
  radius: 50,
  gradCircle1: [AppColors.greenA400, AppColors.greenA20000],
  gradCircle2: [AppColors.orange400, AppColors.red20058, AppColors.orange200],
  color1: AppColors.green03704F,
  color2: AppColors.orangeA200,
);
MatchData matchDataRedYellow = MatchData(
  radius: 50,
  gradCircle1: [AppColors.yellowA200, AppColors.yellow40000],
  gradCircle2: [AppColors.red500, AppColors.red20058, AppColors.red300],
  color1: AppColors.yellowA400B2,
  color2: AppColors.redA200,
);
MatchData matchDataColorCode = MatchData(
  radius: 50,
  gradCircle1: [AppColors.yellowA200, AppColors.yellow40000],
  gradCircle2: [AppColors.red500, AppColors.red20058, AppColors.red300],
  color1: AppColors.yellowA400B2,
  color2: AppColors.redA200,
);
MatchData matchDataPurpleBlue = MatchData(
  radius: 50,
  gradCircle1: [AppColors.lightBlueA700, AppColors.blue30000],
  gradCircle2: [
    AppColors.purpleA20002,
    AppColors.red20058,
    AppColors.purpleA10001
  ],
  color1: AppColors.purple6F03BB,
  color2: AppColors.purpleA20001,
);
List<MatchData> matchesList = [
  matchDataBlueRed,
  matchDataOrangeGreen,
  matchDataRedYellow,
  matchDataPurpleBlue
];
MatchData matchDataOrangeRedProfile = MatchData(
  width: getHorizontalSize(116),
  radius: 90,
  gradCircle1: [AppColors.orange400, AppColors.red20058, AppColors.orange200],
  gradCircle2: [AppColors.red500, AppColors.red20058, AppColors.red300],
  color2: AppColors.redA200,
  color1: AppColors.orangeA200,
);
MatchData matchDataUserProfile = MatchData(
  width: getHorizontalSize(116),
  radius: 90,
  gradCircle1: [AppColors.lightBlueA700, AppColors.blue30000],
  gradCircle2: [
    AppColors.purpleA20002,
    AppColors.red20058,
    AppColors.purpleA10001
  ],
  color1: AppColors.lightBlue600B2,
  color2: AppColors.purpleA20001,
);
MatchData matchDataBlueRedSmallProfile = MatchData(
  radius: 38,
  width: getSize(51),
  gradCircle1: [AppColors.lightBlueA700, AppColors.blue30000],
  gradCircle2: [AppColors.red500, AppColors.red20058, AppColors.red300],
  color1: AppColors.lightBlue600B2,
  color2: AppColors.redA200,
);
MatchData matchDataBlueRedSmall = MatchData(
  radius: 25,
  //  width: getHorizontalSize(50),
  gradCircle1: [AppColors.lightBlueA700, AppColors.blue30000],
  gradCircle2: [AppColors.red500, AppColors.red20058, AppColors.red300],
  color1: AppColors.lightBlue600B2,
  color2: AppColors.redA200,
);
MatchData matchDataBlueSearchProfile = MatchData(
  radius: 38,
  width: getSize(51),
  gradCircle1: [AppColors.lightBlueA700, AppColors.blue30000],
  gradCircle2: [AppColors.red500, AppColors.red20058, AppColors.red300],
  color1: AppColors.lightBlue600B2,
  color2: AppColors.redA200,
);

MatchData matchDataBlueSideMenu = MatchData(
  radius: 67,
  width: getSize(91),
  gradCircle1: [AppColors.lightBlueA700, AppColors.blue30000],
  gradCircle2: [AppColors.red500, AppColors.red20058, AppColors.red300],
  color1: AppColors.lightBlue600B2,
  color2: AppColors.redA200,
);

MatchData matchDataOrangeRedProfileSideMenu = MatchData(
  width: getHorizontalSize(91),
  radius: 67,
  gradCircle1: [AppColors.orange400, AppColors.red20058, AppColors.orange200],
  gradCircle2: [AppColors.red500, AppColors.red20058, AppColors.red300],
  color1: AppColors.orangeA200,
  color2: AppColors.redA200,
);
