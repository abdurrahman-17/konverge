import 'package:flutter/material.dart';

import '../../utilities/styles/common_styles.dart';
import 'cometchat_chat_view.dart';

void cometchatUserNavigation(context, user, _messageTypes) {
  String name =
      user.name.length > 25 ? user.name.substring(0, 18) + '...' : user.name;
  user.name = name;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Container(
        decoration: commonBgBackgroundGradient,
        child: cometChatMessage(
          user,
          _messageTypes,
        ),
      ),
    ),
  );
}
