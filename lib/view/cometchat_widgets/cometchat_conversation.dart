import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';

import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart' as cc;
import '../../theme/app_style.dart';
import '../../theme/cometchat_theme.dart';
import '../../utilities/colors.dart';
import '../../utilities/common_functions.dart';
import '../../utilities/date_utils.dart';
import '../../utilities/styles/common_styles.dart';
import 'cometchat_chat_view.dart';
import 'cometchat_conversation_list_item.dart';
import 'cometchat_recent_chat_info_widget.dart';
import 'cometchat_templates.dart';

CometChatConversationsWithMessages conversationMessageList(context) {
  return CometChatConversationsWithMessages(
    theme: CometchatThemeInfo.customTheme,
    conversationsConfiguration: ConversationsConfiguration(
      conversationsStyle: CometchatThemeInfo.conversationStyle,
      listItemView: (_conversation) {
        Color? attachedColorCode;
        String? personalityCode;
        User conversationWith = _conversation.conversationWith as User;
        conversationWith.name =
            textToFirstLetterToUpperCase(conversationWith.name);

        if (conversationWith.metadata?["color_code"] != null) {
          attachedColorCode = Color(
            int.parse(
                  conversationWith.metadata?["color_code"].substring(1, 7),
                  radix: 16,
                ) +
                0xFF000000,
          );
          personalityCode = conversationWith.metadata?["my_code"];
        } else {
          attachedColorCode = Colors.blue;
        }
        String recentMessageType = _conversation.lastMessage?.type ?? "";
        //_conversation.lastMessage?.
        print("last message time");
        print(_conversation.lastMessage?.deliveredAt);

        return GestureDetector(
          onTap: () {
            User user = _conversation.conversationWith as User;
            String name = user.name.length > 25
                ? user.name.substring(0, 18) + '...'
                : user.name;
            user.name = name;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Container(
                  decoration: commonBgBackgroundGradient,
                  child: cometChatMessage(
                    user,
                    templateInfo(),
                  ),
                ),
              ),
            );
          },
          child: CometChatConversationListItem(
            CometChatAvatar(
              image: conversationWith.avatar,
              name: conversationWith.name,
            ),
            attachedColorCode,
            conversationWith.name,
            cc.CometChatBadge(
              style: CometchatThemeInfo.badgeStyle,
              count: _conversation.unreadMessageCount ?? 0,
            ),
            recentMessageType == "text"
                ? recentTextChat(
                    (_conversation.lastMessage as TextMessage).text.trim(),
                  )
                : recentMediaChatContainer(recentMessageType),
            personalityCode,
            cc.CometChatDate(
              customDateString: dateToAgoFormat(
                _conversation.lastMessage?.deliveredAt ?? DateTime.now(),
              ),
              style: DateStyle(
                textStyle: AppStyle.txtPoppinsLightItalic9,
                border: Border.all(color: AppColors.transparent),
              ),
            ),
          ),
        );
      },
    ),
  );
}
