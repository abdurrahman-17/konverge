import 'package:flutter/material.dart';

import '../utilities/colors.dart';
import '../utilities/size_utils.dart';

class AppDecoration {
  static BoxDecoration get fillBlack9007c => BoxDecoration(
        color: AppColors.black9007c,
      );

  static BoxDecoration get fillBlackGrad9007c => BoxDecoration(
        color: AppColors.black9007c,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.black9004c,
            AppColors.indigo90001,
            AppColors.cyan900,
            AppColors.cyan90001,
            AppColors.black9007c,
            AppColors.black9007c,
          ],
        ),
      );

  static BoxDecoration get fillBlueGray90002 => BoxDecoration(
        color: AppColors.blueGray90002,
      );

  static BoxDecoration get outlineTealA400 => BoxDecoration(
        color: AppColors.blueGray10033,
        border: Border.all(
          color: AppColors.tealA400,
          width: getHorizontalSize(1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black90035,
            spreadRadius: getHorizontalSize(2),
            blurRadius: getHorizontalSize(2),
            offset: const Offset(
              0,
              2,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineGray80001 => BoxDecoration(
        color: AppColors.black90033,
        border: Border.all(
          color: AppColors.gray80001,
          width: getHorizontalSize(1),
        ),
      );

  static BoxDecoration get fillBlack900cc => BoxDecoration(
        color: AppColors.black900Cc,
      );

  static BoxDecoration get fillTeal300 => BoxDecoration(
        color: AppColors.teal300,
      );

  static BoxDecoration get outlineBlueGray90001 => BoxDecoration(
        color: AppColors.whiteA70007,
        border: Border.all(
          color: AppColors.blueGray90001,
          width: getHorizontalSize(1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black90035,
            spreadRadius: getHorizontalSize(2),
            blurRadius: getHorizontalSize(2),
            offset: const Offset(
              0,
              2,
            ),
          ),
        ],
      );

  static BoxDecoration get txtFillRedA700 => BoxDecoration(
        color: AppColors.redA700,
      );

  static BoxDecoration get outlineBlueGray70003 => BoxDecoration(
        color: AppColors.black9002d,
        border: Border.all(
          color: AppColors.blueGray70003,
          width: getHorizontalSize(1),
        ),
      );

  static BoxDecoration get backgroundForMatchesSwipeView => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [
            Color(0xFF131436),
            Color(0xFF0A2639),
          ],
        ),
        border: Border.all(
          color: AppColors.blueGray70003,
          width: getHorizontalSize(1),
        ),
      );

  static BoxDecoration get fillBlack900 => BoxDecoration(
        color: AppColors.black900,
      );

  static BoxDecoration get gradientIndigo900Cyan90001 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.5,
            0,
          ),
          end: const Alignment(
            0.5,
            1,
          ),
          colors: [
            AppColors.indigo900,
            AppColors.cyan900,
            AppColors.cyan90001,
          ],
        ),
      );

  static BoxDecoration get outlineBlack90026 => BoxDecoration(
        color: AppColors.blueGray900,
        boxShadow: [
          BoxShadow(
            color: AppColors.black90026,
            spreadRadius: getHorizontalSize(2),
            blurRadius: getHorizontalSize(2),
            offset: const Offset(
              0,
              1,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineBlack90026_3 => BoxDecoration(
        color: AppColors.blueGray90001,
        boxShadow: [
          BoxShadow(
            color: AppColors.black90026,
            spreadRadius: getHorizontalSize(2),
            blurRadius: getHorizontalSize(2),
            offset: const Offset(
              0,
              1,
            ),
          ),
        ],
      );

  static BoxDecoration get txtOutlineBlack90026 => BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(
              -1,
              0,
            ),
            end: const Alignment(
              1,
              0,
            ),
            tileMode: TileMode.decal,
            colors: [
              AppColors.teal400Opacity,
              AppColors.tealA400,
            ],
          ),
          boxShadow: [
            BoxShadow(
                color: AppColors.black90035,
                spreadRadius: getHorizontalSize(2),
                blurRadius: getHorizontalSize(2),
                offset: const Offset(1, 1))
          ]);

  static BoxDecoration get txtOutlineBlack90027 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.84,
            0.87,
          ),
          end: const Alignment(
            0.08,
            0.87,
          ),
          colors: [
            AppColors.teal400,
            AppColors.tealA400,
          ],
        ),
      );

  static BoxDecoration get fillBlack90099 => BoxDecoration(
        color: AppColors.black90099,
      );

  static BoxDecoration get fillBlack90066 => BoxDecoration(
        color: AppColors.black90066,
      );

  static BoxDecoration get fillBlack9004c => BoxDecoration(
        color: AppColors.black9004c,
      );

  static BoxDecoration get outlineBlack90035 => BoxDecoration(
        color: AppColors.blueGray10033,
        boxShadow: [
          BoxShadow(
            color: AppColors.black90035,
            spreadRadius: getHorizontalSize(2),
            blurRadius: getHorizontalSize(2),
            offset: const Offset(
              0,
              2,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineBlack900351 => BoxDecoration(
        color: AppColors.black90066,
        boxShadow: [
          BoxShadow(
            color: AppColors.black90035,
            spreadRadius: getHorizontalSize(2),
            blurRadius: getHorizontalSize(2),
            offset: const Offset(
              0,
              2,
            ),
          ),
        ],
      );

  static BoxDecoration get fillWhiteA700 => BoxDecoration(
        color: AppColors.whiteA700,
      );

  static BoxDecoration get txtOutlineTealA400 => BoxDecoration(
        border: Border.all(
          color: AppColors.tealA400,
          width: getHorizontalSize(1),
        ),
      );

  static BoxDecoration get fillBlack90068 => BoxDecoration(
        color: AppColors.black90068,
      );
}

class BorderRadiusStyle {
  static BorderRadius customBorderTL35 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(35),
    ),
    topRight: Radius.circular(
      getHorizontalSize(35),
    ),
  );

  static BorderRadius roundedBorder4 = BorderRadius.circular(
    getHorizontalSize(4),
  );

  static BorderRadius txtCircleBorder8 = BorderRadius.circular(
    getHorizontalSize(8),
  );

  static BorderRadius roundedBorder14 = BorderRadius.circular(
    getHorizontalSize(14),
  );
  static BorderRadius circleBorder52 = BorderRadius.circular(
    getHorizontalSize(52),
  );

  static BorderRadius circleBorder17 = BorderRadius.circular(
    getHorizontalSize(17),
  );

  static BorderRadius circleBorder67 = BorderRadius.circular(
    getHorizontalSize(67),
  );

  static BorderRadius txtCircleBorder17 = BorderRadius.circular(
    getHorizontalSize(17),
  );

  static BorderRadius roundedBorder23 = BorderRadius.circular(
    getHorizontalSize(23),
  );
  static BorderRadius roundedBorder50 = BorderRadius.circular(
    getHorizontalSize(50),
  );
  static BorderRadius roundedBorder35 = BorderRadius.circular(
    getHorizontalSize(35),
  );

  static BorderRadius roundedBorder10 = BorderRadius.circular(
    getHorizontalSize(10),
  );

  static BorderRadius roundedBorder2 = BorderRadius.circular(
    getHorizontalSize(2),
  );

  static BorderRadius customBorderLR62 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(60),
    ),
    topRight: Radius.circular(
      getHorizontalSize(62),
    ),
  );
  static BorderRadius txtRoundedBorder23 = BorderRadius.circular(
    getHorizontalSize(23),
  );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
