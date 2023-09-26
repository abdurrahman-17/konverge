import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import '../../theme/cometchat_theme.dart';
import 'cometchat_message_composer.dart';
import 'cometchat_message_list.dart';

CometChatMessages cometChatMessage(
  p0,
  List<CometChatMessageTemplate> _messageTypes,
) {
  // p0.name = 'hi';
  return CometChatMessages(
    user: p0,
    theme: CometchatThemeInfo.customTheme,
    messageComposerConfiguration: messageConfiguration(),
    // messageHeaderConfiguration: MessageHeaderConfiguration(
    // listItemView: (user, group, context) {
    //   return ProfileImageItem(
    //     matchData: getColorCodeFromColors(themeColor, 38),
    //     height: getVerticalSize(38),
    //     child: profileImageWidget(),
    //   );
    // },
    // subtitleView: (user, group, context) {
    // },
    // ),
    messageListConfiguration: messageListConfiguration(_messageTypes),
    messagesStyle: CometchatThemeInfo.chatWindowBackground,
    hideDetails: true,
  );
}
