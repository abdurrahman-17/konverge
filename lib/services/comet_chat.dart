import 'dart:developer';

import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../view/cometchat_widgets/cometchat_navigation.dart';
import '../view/cometchat_widgets/cometchat_sticker_theme.dart';
import '../view/cometchat_widgets/cometchat_templates.dart';
import '../view/cometchat_widgets/cometchat_user_navigation.dart';

Future<void> initCometChat() async {
  initializeCometChat();
}

void initializeCometChat() async {
//CometChat SDk should be initialized at the start of application.
  UIKitSettings authSettings = (UIKitSettingsBuilder()
        ..subscriptionType = CometChatSubscriptionType.friends
        ..region = dotenv.env['COMET_CHAT_REGION']!
        ..autoEstablishSocketConnection = true
        ..appId = dotenv.env['COMET_CHAT_APP_ID']!
        ..authKey = dotenv.env['COMET_CHAT_AUTH_KEY']!
        ..extensions = stickerExtension())
      .build();

  CometChatUIKit.init(
    // authSettings: authSettings,
    onSuccess: (String successMessage) {},
    onError: (CometChatException exc) {
// "Initialization failed with exception: ${exc.message}";
    },
    uiKitSettings: authSettings,
  );
}

Future<void> cometChatRedirections(context, userId) async {
  CometChat.getUser(userId, onSuccess: (User user) {
    cometChatUserRedirectionWithUserId(context, user);
  }, onError: (CometChatException e) {
    // debugPrint("User Fetch Failed: ${e.message}");
  });
  // UserModel? currentUser;
}

Future<void> cometChatUserRedirectionWithUserId(context, User user) async {
  User _conversationWith = user;

  cometchatUserNavigation(context, _conversationWith, templateInfo());
}

Future<void> cometChatUserRedirection(
    context, userId, userName, profilePic) async {
  User _conversationWith = User(
    name: userName,
    uid: userId,
    avatar: profilePic,
    role: "default",
    status: "online",
    statusMessage: "",
  );

  cometchatUserNavigation(context, _conversationWith, templateInfo());
}

Future<User?> cometChatLogin(String userId) async {
  try {
    final loggedInUser = await CometChatUIKit.login(userId);
    print("loggedInUser $loggedInUser");
    return loggedInUser;
  } catch (e) {
    log("cometChatLogin:$e");
  }
  return null;
}

Future<void> cometChatView(context) async {
  cometchatConversationNavigation(context);
}

 // Message composer style           

                  


 



