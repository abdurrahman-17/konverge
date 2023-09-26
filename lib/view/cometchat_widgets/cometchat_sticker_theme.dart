import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

import '../../utilities/colors.dart';

List<ExtensionsDataSource> stickerExtension() {
  List<ExtensionsDataSource> extensions = [
    StickersExtension(
      configuration: StickerConfiguration(
        stickerButtonIcon: Image.asset(AssetConstants.smile,
            package: UIConstants.packageName, color: AppColors.yellow),
        keyboardButtonIcon: Image.asset(
          AssetConstants.keyboard,
          package: UIConstants.packageName,
          color: AppColors.yellow,
        ),
      ),
    ),
  ];
  return extensions;
}
