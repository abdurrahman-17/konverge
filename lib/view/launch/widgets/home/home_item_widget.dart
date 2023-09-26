import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../../models/design_models/home_model.dart';
import '../../../common_widgets/custom_rich_text.dart';

// ignore: must_be_immutable
class HomeItemWidget extends StatelessWidget {
  HomeItemWidget({
    super.key,
    this.onTapColumnUser,
    required this.homeModel,
  });

  VoidCallback? onTapColumnUser;
  HomeModel homeModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapColumnUser,
      child: Container(
        height: getVerticalSize(143),
        width: getHorizontalSize(143),
        decoration: AppDecoration.fillBlack90066.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        child: Stack(
          children: [
            if (homeModel.count != 0)
              Positioned(
                top: getSize(13),
                right: getSize(10),
                child: Container(
                  width: getSize(16),
                  height: getSize(16),
                  decoration: AppDecoration.txtFillRedA700.copyWith(
                    borderRadius: BorderRadiusStyle.txtCircleBorder8,
                  ),
                  child: Center(
                    child: CustomRichText(
                      text: "${homeModel.count}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppStyle.txtInterRegular9,
                    ),
                  ),
                ),
              ),
            Positioned.fill(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomLogo(
                    svgPath: homeModel.icon == Assets.imgSettings
                        ? null
                        : homeModel.icon,
                    imagePath: homeModel.icon == Assets.imgSettings
                        ? Assets.imgSettings
                        : null,
                    height: getSize(36),
                  ),
                  SizedBox(
                    height: getVerticalSize(22),
                  ),
                  CustomRichText(
                    text: homeModel.name,
                    style: AppStyle.txtPoppinsSemiBold11,
                    textAlign: TextAlign.left,
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
