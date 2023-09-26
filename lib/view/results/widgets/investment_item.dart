import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class InvestmentItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? subTitle1;
  final bool iconNeeded;
  final double? topMargin;
  final TextStyle? fontStyle;

  InvestmentItem({
    required this.title,
    this.subtitle,
    this.subTitle1,
    this.iconNeeded = true,
    this.topMargin,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: getMargin(top: topMargin ?? 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (iconNeeded)
            CustomLogo(
              imagePath: Assets.imgRadioSelect,
              width: getHorizontalSize(13),
              height: getHorizontalSize(13),
            ),
          if (iconNeeded)
            SizedBox(
              width: getHorizontalSize(14),
            ),
          SizedBox(
            width: getHorizontalSize(iconNeeded ? 250 : 277),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: fontStyle ??
                        TextStyle(
                          color: AppColors.whiteA700,
                          fontSize: getFontSize(13),
                          fontFamily: 'Poppins',
                          fontWeight:
                              iconNeeded ? FontWeight.w600 : FontWeight.w300,
                        ),
                  ),
                  if (subtitle != null)
                    TextSpan(
                      text: subtitle,
                      style: TextStyle(
                        color: AppColors.whiteA700,
                        fontSize: getFontSize(13),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (subTitle1 != null)
                    TextSpan(
                      text: subTitle1,
                      style: TextStyle(
                        color: AppColors.whiteA700,
                        fontSize: getFontSize(13),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
