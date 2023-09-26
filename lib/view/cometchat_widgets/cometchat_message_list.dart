// Message List config
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

import '../../theme/cometchat_theme.dart';
import '../../utilities/colors.dart';

MessageListConfiguration messageListConfiguration(
  List<CometChatMessageTemplate> _messageTypes,
) {
  return MessageListConfiguration(
    templates: _messageTypes,
    emptyStateText: "Start your conversation",

    // Message Bubble theme configuration
    theme: CometchatThemeInfo.messageBubbleTheme,
    messageListStyle: MessageListStyle(
      background: AppColors.transparent,
    ),
  );
}
