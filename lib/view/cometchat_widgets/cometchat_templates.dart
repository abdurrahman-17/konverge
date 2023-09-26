import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

import '../../theme/cometchat_theme.dart';

List<CometChatMessageTemplate> templateInfo() {
  CometChatMessageTemplate _textTemplate = ChatConfigurator.getDataSource()
      .getTextMessageTemplate(CometchatThemeInfo.customTheme);
  CometChatMessageTemplate _audioTemplate = ChatConfigurator.getDataSource()
      .getAudioMessageTemplate(CometchatThemeInfo.customTheme);
  CometChatMessageTemplate _messageImageTemplate =
      ChatConfigurator.getDataSource()
          .getImageMessageTemplate(CometchatThemeInfo.customTheme);
  CometChatMessageTemplate _videoMessageTemplate =
      ChatConfigurator.getDataSource()
          .getVideoMessageTemplate(CometchatThemeInfo.customTheme);
  CometChatMessageTemplate _getFileMessageTemplate =
      ChatConfigurator.getDataSource()
          .getFileMessageTemplate(CometchatThemeInfo.customTheme);
  CometChatMessageTemplate _getGroupActionTemplate =
      ChatConfigurator.getDataSource()
          .getGroupActionTemplate(CometchatThemeInfo.customTheme);

  //custom list of templates
  List<CometChatMessageTemplate> _messageTypes = [
    _textTemplate,
    _messageImageTemplate,
    _audioTemplate,
    _videoMessageTemplate,
    _getFileMessageTemplate,
    _getGroupActionTemplate
  ];
  return _messageTypes;
}
