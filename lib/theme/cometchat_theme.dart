import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart' as cc;

import '../utilities/colors.dart';

class CometchatThemeInfo {
  static CometChatTheme customTheme = CometChatTheme(
    palette: Palette(
      backGroundColor: PaletteModel(
        dark: AppColors.indigo90001,
        light: AppColors.indigo90001,
      ),
      // Chat window top icons color
      primary: PaletteModel(
        dark: AppColors.whiteFFF,
        light: AppColors.whiteFFF,
      ),
      // secondary: PaletteModel(dark: Colors.grey, light: Colors.red),
      //Text chat receive message text color
      accent: PaletteModel(
        dark: AppColors.whiteFFF,
        light: AppColors.whiteFFF,
      ),

      success: PaletteModel(
        dark: AppColors.whiteFFF,
        light: Colors.green,
      ),
      // People search box color
      accent100: PaletteModel(
        dark: AppColors.blueGray10033,
        light: AppColors.blueGray10033,
      ),

      // error: PaletteModel(dark: Colors.red, light: Colors.red),
    ),
    typography: cc.Typography.fromDefault(),
  );

  static CometChatTheme customTheme1 = CometChatTheme(
    palette: Palette(
      backGroundColor: PaletteModel(
        dark: AppColors.whiteFFF,
        light: AppColors.transparent,
      ),
      // Chat window top icons color
      primary: PaletteModel(
        dark: AppColors.whiteFFF,
        light: AppColors.whiteFFF,
      ),
      // secondary: PaletteModel(dark: Colors.grey, light: Colors.red,),
      //Text chat receive message text color
      accent: PaletteModel(
        dark: AppColors.whiteFFF,
        light: AppColors.whiteFFF,
      ),

      success: PaletteModel(
        dark: AppColors.whiteFFF,
        light: Colors.green,
      ),
      // People search box color
      accent100: PaletteModel(
        dark: AppColors.blueGray10033,
        light: AppColors.blueGray10033,
      ),

      // error: PaletteModel(dark: Colors.red, light: Colors.red,),
    ),
    typography: cc.Typography.fromDefault(),
  );

  // Chat detail view message list theme or Message bubble configuration
  static CometChatTheme messageBubbleTheme = CometChatTheme(
    palette: Palette(
      backGroundColor: PaletteModel(
        light: AppColors.transparent,
        dark: AppColors.transparent,
      ),
      // Send chat bubble background
      primary: PaletteModel(
        light: AppColors.lightBlue,
        dark: AppColors.lightBlue,
      ),
      // Time stamp and tick mark color
      accent: PaletteModel(
        dark: AppColors.whiteFFF,
        light: AppColors.whiteFFF,
      ),
      // Receive chat bubble background
      accent100: PaletteModel(
        dark: AppColors.blueGray10033,
        light: AppColors.blueGray10033,
      ),
      //
    ),
    typography: cc.Typography.fromDefault(),
  );

  // Chat window background gradient
  static MessagesStyle chatWindowBackground = MessagesStyle(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.black9004c,
        AppColors.indigo90001,
        AppColors.cyan900,
        AppColors.cyan90001,
      ],
    ),
    background: AppColors.transparent,
  );

  static MessageComposerStyle chatMessageComposerStyle = MessageComposerStyle(
    background: AppColors.transparent,
    inputBackground: AppColors.blueGray10033,
    emojiIconTint: AppColors.yellow,
    sendButtonIconTint: AppColors.tealA400,
    stickerIconTint: AppColors.red,
    closeIconTint: AppColors.tealA400,
    dividerTint: AppColors.tealA400,
    attachmentIconTint: AppColors.tealA400,
    border: Border.all(color: AppColors.whiteFFF),
    placeholderTextStyle: TextStyle(color: AppColors.whiteA700),
    inputTextStyle: TextStyle(color: AppColors.tealA400),
  );

  // User List page background gradient
  static UsersStyle chatUserListPageBackground = UsersStyle(
    searchBackground: AppColors.gray40033,
    searchPlaceholderStyle: TextStyle(color: AppColors.gray92A6C4),
    searchIconTint: AppColors.gray92A6C4,
    // titleStyle: TextStyle(m),
    searchBorderRadius: 100.0,
    background: AppColors.transparent,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.black9004c,
        AppColors.indigo90001,
        AppColors.cyan900,
        AppColors.cyan90001,
      ],
    ),
  );

  static ConversationsStyle conversationStyle = ConversationsStyle(
    // searchBackground: AppColors.gray40033,
    // searchPlaceholderStyle: TextStyle(color: AppColors.gray92A6C4),
    // searchIconTint: AppColors.gray92A6C4,
    // titleStyle: TextStyle(m),

    // searchBorderRadius: 100.0,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.black9004c,
        AppColors.indigo90001,
        AppColors.cyan900,
        AppColors.cyan90001,
      ],
    ),
    background: AppColors.transparent,
  );

  static BadgeStyle badgeStyle = BadgeStyle(
    width: 17,
    height: 17,
    borderRadius: 100,
    textStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10.0,
      color: cometChatTheme.palette.getAccent(),
    ),
    background: AppColors.green400,
  );
}
