import 'package:flutter/material.dart';
import '../../utilities/enums.dart';
import '../../core/app_export.dart';

import 'custom_icon_button.dart';

class CommonMessageDialogue extends StatelessWidget {
  const CommonMessageDialogue({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: AppDecoration.fillBlueGray90002,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: getHorizontalSize(
                305,
              ),
              height: getVerticalSize(295),
              padding: getPadding(
                left: 38,
                top: 24,
                right: 38,
                bottom: 24,
              ),
              decoration: AppDecoration.fillBlack90066.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder35,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconButton(
                    height: 64,
                    width: 64,
                    shape: IconButtonShape.circleBorder32,
                    margin: getMargin(
                      top: 45,
                    ),
                    child: CustomLogo(
                      svgPath: Assets.imgCheckMark,
                    ),
                  ),
                  Container(
                    width: getHorizontalSize(
                      222,
                    ),
                    margin: getMargin(
                      left: 2,
                      top: 26,
                      right: 4,
                    ),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: AppStyle.txtPoppinsMedium20,
                    ),
                  ),
                  if (message.contains("block"))
                    Padding(
                      padding: getPadding(
                        top: 32,
                      ),
                      child: Text(
                        "Manage blocked accounts in settings",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtPoppinsLightItalic12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
