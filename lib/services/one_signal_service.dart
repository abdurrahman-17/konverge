import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:konverge/services/remote_config_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../core/locator.dart';
import '../main.dart';
import '../models/app_update_model.dart';
import '../utilities/common_design_utils.dart';
import '../view/view_profile/screens/view_profile_screen.dart';
import 'comet_chat.dart';

Map<String, String> notificationData = {};

Future<void> oneSignalInitialize() async {
  OneSignal.shared.setAppId(dotenv.env['ONE_SIGNAL_APP_ID']!);

  /* For handling notification click action additional data should be passed
   along with content . additional data like this {notificationType=chat} */
  // requestPushNotificationPermissionFromOS();
  OneSignal.shared.setNotificationOpenedHandler((openedResult) {
    print("notification opened");
    print("data ${openedResult.notification}");
    try {
      Map<String, dynamic>? data = openedResult.notification.additionalData;
      print("data $data");
      if (data == null) return;
      log("sender id: ${data["request_type"]}, cognitoId: ${data["cognito_id"]}");
      notificationData["request_type"] = data["request_type"];
      if (data.containsKey("request_type") && data.containsKey("cognito_id")) {
        // final activeUser =
        //     Locator.instance.get<UserRepo>().getCurrentUserData();
        // if (data["request_type"] == "match") {
        String cognitoId = data["cognito_id"];
        String receiverId = data["receiver_id"];
        String senderId = data["sender_id"];
        notificationData["cognito_id"] = cognitoId;
        notificationData["receiver_id"] = receiverId;
        notificationData["sender_id"] = senderId;

        log("sender id: $senderId, cognitoId: $cognitoId, receiver Id: $receiverId");

        if (data["request_type"] == "new_message") {
          // cometChatView(globalNavigatorKey.currentContext!);
          cometChatRedirections(globalNavigatorKey.currentContext!, senderId);
        } else {
          print("notification context ${globalNavigatorKey.currentContext!}");
          globalNavigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => ViewProfileScreen(
                cognitoId: cognitoId,
                from: "notification",
                currentUserId: receiverId,
                userId: senderId,
              ),
            ),
          );
        }

        //}
      }
    } catch (e) {
      print("error-notification $e");
    }
    // if (openedResult.notification.additionalData != null &&
    //     openedResult.notification.additionalData!['notificationType'] ==
    //         'chat') {
    // }
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler((event) async {
    print("Notification Foreground");
    try {
      Map<String, dynamic>? data = event.notification.additionalData;
      if (data == null) return;
      if (data.containsKey("update")) {
        event.complete(null);
        AppUpdateModel model =
            await Locator.instance.get<RemoteConfigService>().getUpdateModel();
        launchForceUpdate(model);
      }
      // if (data.containsKey("request_type") && data.containsKey("cognitoId")) {
      //   final activeUser =
      //       Locator.instance.get<UserRepo>().getCurrentUserData();
      //   if (data["request_type"] == "match") {
      //     String cognitoId = data["cognitoId"];
      //     Navigator.pushNamed(
      //       globalNavigatorKey.currentContext!,
      //       ViewProfileScreen.routeName,
      //       arguments: {
      //         'cognitoId': cognitoId,
      //         "from": "",
      //         "current": activeUser!.userId!,
      //         "userId": ""
      //       },
      //     );
      //   }
      // }
    } catch (e) {}
    // if (Locator.instance.get<SharedPrefUserServices>().getChatPageStatus()) {
    //   event.complete(null);
    // }
  });
}

///push notification device playerId get function
Future<String> getOneSignalFcmToken() async {
  var deviceState = await OneSignal.shared.getDeviceState();
  print("Device playerId : ${deviceState?.userId}");
  return deviceState!.userId.toString();
}

///asking for push notification permission from os
void requestPushNotificationPermissionFromOS() {
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
}
