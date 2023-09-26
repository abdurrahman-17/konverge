import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import '../../theme/cometchat_theme.dart';
import '../../utilities/common_functions.dart';
import '../../utilities/styles/common_styles.dart';
import 'cometchat_chat_view.dart';
import 'cometchat_users_list_item.dart';

//search view
CometChatUsersWithMessages usersList(context, _messageTypes) {
  return CometChatUsersWithMessages(
    usersConfiguration: UsersConfiguration(
      title: "Users",
      hideSectionSeparator: true,
      searchPlaceholder: "Start Searching",
      listItemView: (p0) {
        print("User Information");

        print(p0.metadata);
        Color? attachedColorCode;
        p0.name = textToFirstLetterToUpperCase(p0.name);
        // String? personalityCode;

        if ((p0.metadata?['color_code']) != null) {
          attachedColorCode = Color(
            int.parse(p0.metadata?['color_code'].substring(1, 7), radix: 16) +
                0xFF000000,
          );
          //personalityCode = (_conversation.conversationWith as User).metadata?["my_code"];
        } else {
          attachedColorCode = Colors.blue;
        }
        return GestureDetector(
          onTap: () {
            String name = p0.name.length > 25
                ? p0.name.substring(0, 18) + '...'
                : p0.name;
            p0.name = name;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Container(
                  decoration: commonBgBackgroundGradient,
                  child: cometChatMessage(
                    p0,
                    _messageTypes,
                  ),
                ),
              ),
            );
          },
          child: CometChatUserListItem(
            CometChatAvatar(
              image: p0.avatar,
              name: p0.name,
            ),
            attachedColorCode,
            p0.name,
          ),
        );
      },
      usersRequestBuilder: UsersRequestBuilder()
        ..friendsOnly = true
        ..hideBlockedUsers = true
        ..limit = 30
        ..userStatus = "",
      usersStyle: CometchatThemeInfo.chatUserListPageBackground,
    ),
    theme: CometchatThemeInfo.customTheme,
  );
}
