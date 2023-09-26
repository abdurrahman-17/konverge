// ignore_for_file: use_build_context_synchronously, avoid_catches_without_on_clauses

import 'dart:developer';

import 'package:flutter/material.dart';
import '../blocs/graphql/graphql_bloc.dart';
import '../blocs/graphql/graphql_event.dart';
import '../core/configurations.dart';
import '../repository/user_repository.dart';
import '../view/search_for_skills/screens/search_for_skills.dart';
import '../core/locator.dart';
import '../services/comet_chat.dart';
import '../view/authentication/screens/sign_up_screen.dart';
import '../view/initial_screens/screens/stay_up_to_date.dart';
import '../view/launch/screens/launch_screen.dart';
import '../view/results/screens/investment_screen.dart';
import '../view/results/screens/result_screen.dart';
import '../view/search_for_skills/screens/almost_there_screen.dart';
import '../view/view_profile/screens/view_profile_screen.dart';
import 'common_functions.dart';

class CommonStaticValues {
  static bool isAfterSignUp = false;
}

void updateStage(BuildContext context) {
  BlocProvider.of<GraphqlBloc>(context).add(
    const UpdateNavigationStageInfoEvent(
      stage: Constants.navigationStageShowHome,
    ),
  );
}

Future<bool> checkLookingForSkillsIsEmpty(BuildContext buildContext) async {
  final currentUser = Locator.instance.get<UserRepo>().getCurrentUserData();
  if (currentUser?.looking_for_skills == null ||
      currentUser!.looking_for_skills!.isEmpty) {
    Navigator.pushNamed(
      buildContext,
      SearchForSkillsScreen.routeName,
      arguments: {
        'isSecondTime': true,
      },
    );
    return true;
  }
  return false;
}

Future<void> readStageOfLoggedInUserAndNavigate(
    BuildContext buildContext) async {
  final currentUser = Locator.instance.get<UserRepo>().getCurrentUserData();

  print("read logged in user details completed . navigate as per stage; 23");
  log("userPref:$currentUser");
  if (currentUser != null) {
    log("currentUserId::${currentUser.userId}");
    if (currentUser.userId == null) {
      Navigator.pushNamedAndRemoveUntil(
        buildContext,
        SignUpScreen.routeName,
        (Route<dynamic> route) => false,
      );
      return;
    } else if (CommonStaticValues.isAfterSignUp) {
      CommonStaticValues.isAfterSignUp = false;
      addPlayerId(buildContext);
    }

    switch (currentUser.stage ??
        Constants.navigationStagePhoneVerificationCompleted) {
      case Constants.navigationStagePhoneVerificationCompleted:
        //first time login after sign up
        Navigator.pushNamedAndRemoveUntil(
          buildContext,
          StayUpToDate.routeName,
          (Route<dynamic> route) => false,
        );
        break;
      case Constants.navigationStageBusinessStageCompleted:
        //updated the sign up process till business stage.
        //show from almost there screen.
        Navigator.pushNamedAndRemoveUntil(
          buildContext,
          AlmostThereScreen.routeName,
          (Route<dynamic> route) => false,
        );
        break;
      case Constants.navigationStageQuestionnaireCompleted:
        //questionnaire updated successfully
        //show from results screen.
        Navigator.pushNamedAndRemoveUntil(
          buildContext,
          ResultScreen.routeName,
          (Route<dynamic> route) => false,
        );
        break;
      case Constants.navigationStageResultScreenAccepted:
        log('userPref.my_journey ${currentUser.my_journey}');
        log('Constants.lookingForTypeInvestor ${Constants.lookingForTypeInvestor}');
        if (currentUser.my_journey == Constants.lookingForTypeInvestor) {
          log('if');
          Navigator.pushNamedAndRemoveUntil(
            buildContext,
            InvestmentScreen.routeName,
            (Route<dynamic> route) => false,
          );
        } else {
          updateStage(buildContext);
          Navigator.pushNamedAndRemoveUntil(
            buildContext,
            LaunchScreen.routeName,
            arguments: {
              'tab': 3,
            },
            (Route<dynamic> route) => false,
          );
        }
        break;
      case Constants.navigationStageShowHome:
        //show home screen
        if (notificationData.containsKey("request_type")) {
          String cognitoId = notificationData["cognito_id"] ?? "";
          String receiverId = notificationData["receiver_id"] ?? "";
          String senderId = notificationData["sender_id"] ?? "";

          if (notificationData["request_type"] == "new_message") {
            // cometChatView(globalNavigatorKey.currentContext!);

            print("My push Sender id" + senderId);
            Navigator.pushNamedAndRemoveUntil(
              buildContext,
              LaunchScreen.routeName,
              (Route<dynamic> route) => false,
            );
            cometChatRedirections(buildContext, senderId);
          } else {
            Navigator.pushAndRemoveUntil(
              buildContext,
              MaterialPageRoute(
                builder: (_) => ViewProfileScreen(
                  cognitoId: cognitoId,
                  from: "notificationBackground",
                  currentUserId: receiverId,
                  userId: senderId,
                ),
              ),
              (route) => false,
            );
            // Navigator.pushAndRemoveUntil(
            //   buildContext,
            //   ViewProfileScreen(cognitoId:cognitoId ,from: "",currentUserId: receiverId,userId: senderId,),
            //   (Route<dynamic> route) => false,
            // );
          }
        } else {
          Navigator.pushNamedAndRemoveUntil(
            buildContext,
            LaunchScreen.routeName,
            (Route<dynamic> route) => false,
          );
          if (currentUser.is_notification) {
            requestPushNotificationPermissionFromOS();
          }
        }
        break;
      default:
        //start from stay up to date screen.
        Navigator.pushNamedAndRemoveUntil(
          buildContext,
          StayUpToDate.routeName,
          (Route<dynamic> route) => false,
        );
    }
  } else {
    log("User logged in but not saved on shared preference. ");
    // Navigator.pushNamedAndRemoveUntil(
    //   buildContext,
    //   SignUpScreen.routeName,
    //   (Route<dynamic> route) => false,
    // );
  }
}
