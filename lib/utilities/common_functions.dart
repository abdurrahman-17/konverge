import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';

import '../blocs/user/user_bloc.dart';
import '../blocs/graphql/graphql_bloc.dart';
import '../blocs/graphql/graphql_event.dart';
import '../core/configurations.dart';
import '../core/locator.dart';
import '../models/graphql/user_info.dart';
import '../repository/user_repository.dart';
import '../view/common_widgets/snack_bar.dart';
import '../view/launch/screens/launch_screen.dart';

bool checkAllFieldFilled(List<TextEditingController> textEditors) {
  for (TextEditingController textEditingController in textEditors) {
    if (textEditingController.text.trim().isEmpty) {
      return false;
    }
  }
  return true;
}

double getTextContainHeight({
  required String text,
  required TextStyle style,
  required double maxWidth,
  double minWidth = 0,
}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout(
      minWidth: minWidth,
      maxWidth: maxWidth,
    );
  return textPainter.size.height;
}

void bottomNavFunction(BuildContext context, int index) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    LaunchScreen.routeName,
    arguments: {
      'tab': index,
    },
    (Route<dynamic> route) => false,
  );
}

void addPlayerId(BuildContext context) async {
  final fcmToken = await getOneSignalFcmToken();
  final activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();
  if (activeUser == null) {
    return;
  }
  BlocProvider.of<GraphqlBloc>(context).add(
    AddPlayerIdEvent(userId: activeUser.userId!, playerId: fcmToken),
  );
  BlocProvider.of<UserBloc>(context).add(
    UserLastLoginTimeUpdateEvent(userId: activeUser.userId!),
  );
}

void deletePlayerId(BuildContext context, String userId) async {
  final fcmToken = await getOneSignalFcmToken();
  BlocProvider.of<GraphqlBloc>(context).add(
    DeletePlayerIdEvent(userId: userId, playerId: fcmToken),
  );
}

double getMotivationValue(Motivation? motivation) {
  if (motivation == null) return 0;
  return (motivation.money +
          motivation.passion +
          motivation.freedom +
          motivation.changing_the_world +
          motivation.fame_and_power +
          motivation.better_lifestyle +
          motivation.passion +
          motivation.helping_others)
      .toDouble();
}

bool isRedundantClick(DateTime? firstClickTime, DateTime currentTime) {
  if (firstClickTime == null) {
    print("first click");
    return false;
  }
  int timeDifferent = currentTime.difference(firstClickTime).inSeconds;

  print('diff is $timeDifferent');
  if (timeDifferent < 60) {
    showSnackBar(message: "Please retry after ${60 - timeDifferent} seconds");
    return true;
  }
  return false;
}

bool isRedundantClickForCopyEmail(
    DateTime? firstClickTime, DateTime currentTime) {
  if (firstClickTime == null) {
    print("first click");
    return false;
  }
  int timeDifferent = currentTime.difference(firstClickTime).inSeconds;

  print('diff is $timeDifferent');
  if (timeDifferent < 5) {
    //showSnackBar(message: "Please retry after ${60 - timeDifferent} seconds");
    return true;
  }
  return false;
}

String textToFirstLetterToUpperCase(String text) {
  List<String> splitText = text.split(' ');
  List<String> newList = [];

  log('message: $text');
  log('message: $splitText');

  splitText.forEach((item) {
    if (item.isNotEmpty) {
      newList.add(item.capitalize());
    }
  });

  return newList.join(' ');
}

void addListener(
    FocusNode focusNode, int cursorPosition, TextEditingController controller) {
  if (!focusNode.hasFocus) {
    cursorPosition = controller.selection.base.offset;
  }
}

void disposeFocusNode(FocusNode node, {required VoidCallback listener}) {
  //node!.enclosingScope;
  node.removeListener(listener);
  node.dispose();

  // node=null;
}
