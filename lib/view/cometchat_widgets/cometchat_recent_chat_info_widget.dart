import 'package:flutter/material.dart';

import '../../theme/app_style.dart';
import '../../utilities/colors.dart';
import '../common_widgets/custom_rich_text.dart';

Widget recentTextChat(String text) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomRichText(
          text: text.length > 25 ? text.substring(0, 18) + '...' : text,
          style: AppStyle.txtPoppinsLightItalic12,
        ),
      ],
    ),
  );
}

// Recent Media container
Widget recentMediaChatContainer(String type) {
  Icon? icon;
  switch (type) {
    case "image":
      icon = Icon(
        Icons.image_outlined,
        size: 15,
        color: AppColors.gray500,
      );
      break;
    case "video":
      icon = Icon(
        Icons.video_camera_front_outlined,
        size: 15,
        color: AppColors.gray500,
      );
      break;
    case "audio":
      icon = Icon(
        Icons.audio_file_outlined,
        size: 15,
        color: AppColors.gray500,
      );
      break;
    case "file":
      icon = Icon(
        Icons.file_open_outlined,
        size: 15,
        color: AppColors.gray500,
      );
      break;
  }

  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        icon ?? SizedBox(),
        // CometChatStatusIndicator(
        //   backgroundImage: Icon(Icons.turn_right),
        // ),
      ],
    ),
  );
}
