import 'package:flutter/material.dart';

import '../../utilities/colors.dart';
import '../../utilities/styles/common_styles.dart';
import 'cometchat_conversation.dart';
import 'floating_button.dart';

void cometchatConversationNavigation(context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Container(
        decoration: commonBgBackgroundGradient,
        child: Scaffold(
          backgroundColor: AppColors.transparent,
          floatingActionButton: floatingButton(context),
          body: Center(
            child: conversationMessageList(context),
          ),
        ),
      ),
    ),
  );
}
