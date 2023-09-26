import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/graphql/pre_questionnaire_info_request.dart';
import '../models/graphql/user.dart';
import '../models/graphql/user_info.dart';
import '../utilities/enums.dart';
import '../utilities/transition/page_transition.dart';
import '../utilities/transition_constant.dart';
import '../view/account_details/screens/email_verification_screen.dart';
import '../view/authentication/screens/logout_confirmation.dart';
import '../view/authentication/screens/test.dart';
import '../view/authentication/screens/verify_phone_screen.dart';
import '../view/common_widgets/network_lost_screen.dart';
import '../view/launch/widgets/confirm_deletion_screen.dart';
import '../view/my_qualities_screen/screens/edit_quality_screen.dart';
import '../view/search_for_interests/screens/search_for_interests.dart';
import '../models/amplify/sign_up_request.dart';
import '../view/account_details/screens/account_details_screen.dart';
import '../view/authentication/screens/account_set_screen.dart';
import '../view/authentication/screens/reset_password_screen.dart';
import '../view/authentication/screens/sign_up_phone_screen.dart';
import '../view/authentication/screens/sign_up_screen_with_social.dart';
import '../view/authentication/screens/success_screen.dart';
import '../view/tos/terms_and_condition.dart';
import '../view/biography/screens/biography_screen.dart';
import '../view/change_password/screens/change_password_screen.dart';
import '../view/edit_profile/screens/edit_profile_image_screen.dart';
import '../view/edit_profile/screens/edit_profile_screen.dart';
import '../view/hours_per_week/screens/hours_per_week_screen.dart';
import '../view/initial_screens/screens/time_for_us_screen.dart';
import '../view/its_match/screens/its_match_screen.dart';
import '../view/launch/screens/launch_screen.dart';
import '../view/match_notification/screens/match_notification_screen.dart';
import '../view/passion/screens/passion_screen.dart';
import '../view/privacy/screens/privacy_screen.dart';
import '../view/questionnaire/screens/questionnaire_screen.dart';
import '../view/results/screens/investment_screen.dart';
import '../view/results/screens/result_screen.dart';
import '../view/search_for_skills/screens/almost_there_screen.dart';
import '../view/search_for_skills/screens/ideas_screen.dart';
import '../view/search_for_skills/screens/search_for_skills.dart';
import '../view/support/screens/support_screen.dart';
import '../view/view_profile/screens/view_profile_details_screen.dart';
import '../view/view_profile/screens/view_profile_screen.dart';
import '../view/authentication/screens/forgot_password_screen.dart';
import '../view/authentication/screens/get_started_screen.dart';
import '../view/initial_screens/screens/journey_screen.dart';
import '../view/authentication/screens/login_screen.dart';
import '../view/authentication/screens/sign_up_screen.dart';
import '../view/initial_screens/screens/stay_up_to_date.dart';
import '../view/legal/screens/legal_screen.dart';
import '../view/motivation/screens/motivation_screen.dart';
import '../view/splash_screen.dart';
import '../view/authentication/screens/privacy_policy.dart';
import '../main.dart';

///initialRoute
const String initialRoute = SplashScreen.routeName;
// const String initialRoute = TestScreen.routeName;

//all routes must be initialize here..
Route<dynamic> generateRoute(RouteSettings settings) {
  final arguments = settings.arguments ?? <String, dynamic>{};
  PageTransition pageTransition = PageTransition();
  if (globalNavigatorKey.currentContext != null)
    FocusScope.of(globalNavigatorKey.currentContext!).unfocus();
  SystemChannels.textInput.invokeMethod('TextInput.hide');
  switch (settings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case LoginScreen.routeName:
      return pageTransition.getTransition(widget: const LoginScreen());
    case GetStartedScreen.routeName:
      return MaterialPageRoute(builder: (_) => const GetStartedScreen());
    case ForgotPasswordScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      String userName = arg['username'] as String;
      return pageTransition.getTransition(
          widget: ForgotPasswordScreen(username: userName));

    case SignUpScreen.routeName:
      return pageTransition.getTransition(widget: const SignUpScreen());

    // return MaterialPageRoute(builder: (_) => const SignUpScreen());
    case SignUpPhoneScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      SignUpRequestModel? signUpRequestModel =
          arg['data'] as SignUpRequestModel;
      return pageTransition.getTransition(
          widget: SignUpPhoneScreen(
            signUpRequestModel: signUpRequestModel,
          ),
          time: 100);
    // return MaterialPageRoute(
    //   builder: (_) => SignUpPhoneScreen(
    //     signUpRequestModel: signUpRequestModel,
    //   ),
    // );
    case StayUpToDate.routeName:
      return pageTransition.getTransition(widget: const StayUpToDate());
    case YourJourneyScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      PreQuestionnaireInfoModel? preQuestionnaireInfoModel =
          arg['data'] as PreQuestionnaireInfoModel;
      return pageTransition.getTransition(
          widget: YourJourneyScreen(
            requestModel: preQuestionnaireInfoModel,
          ),
          time: 350);
    // return MaterialPageRoute(
    //   builder: (_) => YourJourneyScreen(
    //     requestModel: preQuestionnaireInfoModel,
    //   ),
    // );
    case TimeForUsScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      PreQuestionnaireInfoModel? preQuestionnaireInfoModel =
          arg['data'] as PreQuestionnaireInfoModel;
      return MaterialPageRoute(
        builder: (_) => TimeForUsScreen(
          requestModel: preQuestionnaireInfoModel,
        ),
      );
    case SearchForSkillsScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      PreQuestionnaireInfoModel? preQuestionnaireInfoModel;
      if (arg['data'] != null) {
        preQuestionnaireInfoModel = arg['data'] as PreQuestionnaireInfoModel?;
      }
      bool isSecondTime = false;
      if (arg['isSecondTime'] != null) {
        isSecondTime = true;
      }
      return MaterialPageRoute(
        builder: (_) => SearchForSkillsScreen(
          isSecondTime: isSecondTime,
          requestModel: preQuestionnaireInfoModel,
        ),
      );
    case SignUpWithSocialScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      User? userModel = arg['user'] as User?;
      return MaterialPageRoute(
          builder: (_) => SignUpWithSocialScreen(
                user: userModel,
              ));
    case ResetPasswordScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      String username = arg['username'] as String;
      return pageTransition.getTransition(
          widget: ResetPasswordScreen(username: username));
    case SuccessScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SuccessScreen());

    case SearchForInterest.routeName:
      return MaterialPageRoute(builder: (_) => const SearchForInterest());
    case AccountSetScreen.routeName:
      return MaterialPageRoute(builder: (_) => const AccountSetScreen());
    case IdeasScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      PreQuestionnaireInfoModel? preQuestionnaireInfoModel =
          arg['data'] as PreQuestionnaireInfoModel?;
      return MaterialPageRoute(
          builder: (_) => IdeasScreen(requestModel: preQuestionnaireInfoModel));
    case AlmostThereScreen.routeName:
      return MaterialPageRoute(builder: (_) => AlmostThereScreen());
    case QuestionnaireScreen.routeName:
      return MaterialPageRoute(builder: (_) => const QuestionnaireScreen());
    case ResultScreen.routeName:
      return MaterialPageRoute(builder: (_) => const ResultScreen());
    case LogoutConfirmationScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      bool isSignOut = arg['isSignOut'] as bool? ?? true;
      return MaterialPageRoute(
        builder: (_) => LogoutConfirmationScreen(
          signOutApi: isSignOut,
        ),
      );
    case ConfirmDeletionScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => ConfirmDeletionScreen(),
      );

    case LaunchScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      int? tab = arg['tab'] as int?;
      log('message $tab');
      return MaterialPageRoute(
        builder: (_) => LaunchScreen(tab: tab ?? 0),
      );
    case InvestmentScreen.routeName:

      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      bool isFromHome = arg['isFromHome'] as bool? ?? false;
      return MaterialPageRoute(builder: (_) =>   InvestmentScreen(isFromHome: isFromHome,));
    case EditQualityScreen.routeName:
      return MaterialPageRoute(builder: (_) => const EditQualityScreen());
    case ViewProfileScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      String cognito = arg['cognitoId'].toString();
      String currentUser = arg['current'].toString();
      String userId = arg['userId'].toString();
      var from = arg['from'] ?? "";
      return PageRouteBuilder(
        transitionDuration: Duration(
            milliseconds:
                TransitionConstant.viewProfileNavigationTransitionDuration),
        reverseTransitionDuration: Duration(
            milliseconds: TransitionConstant
                .viewProfileReverseNavigationTransitionDuration),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ViewProfileScreen(
          cognitoId: cognito,
          userId: userId,
          currentUserId: currentUser,
          from: from.toString(),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    // return MaterialPageRoute(
    //   builder: (_) => ViewProfileScreen(
    //     cognitoId: cognito,
    //     userId: userId,
    //     currentUserId: currentUser,
    //     from: from.toString(),
    //   ),
    // );
    case ViewProfileDetailScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      UserInfoModel user = arg['user'] as UserInfoModel;
      var from = arg['from'] ?? "";
      return pageTransition.getTransition(
        widget: ViewProfileDetailScreen(
          userData: user,
          from: from.toString(),
        ),
        transitionType: PageTransitionTypes.bottomToTop,
      );
    case AccountDetailScreen.routeName:
      return MaterialPageRoute(builder: (_) => const AccountDetailScreen());
    case VerifyEmailScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      String emailId = arg['email'] as String;
      return MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(
                emailId: emailId,
              ));
    case ChangePasswordScreen.routeName:
      return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
    case SupportScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SupportScreen());
    case LegalScreen.routeName:
      return MaterialPageRoute(builder: (_) => const LegalScreen());
    case ItsMatchScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      log("arg $arg");
      UserInfoModel user = arg['user'] as UserInfoModel;

      return MaterialPageRoute(
          builder: (_) => ItsMatchScreen(
                matchUser: user,
              ));
    case MatchNotificationScreen.routeName:
      return MaterialPageRoute(builder: (_) => const MatchNotificationScreen());
    case EditProfileImageScreen.routeName:
      return MaterialPageRoute(builder: (_) => EditProfileImageScreen());
    case PrivacyScreen.routeName:
      return MaterialPageRoute(builder: (_) => const PrivacyScreen());
    case EditProfileScreen.routeName:
      return MaterialPageRoute(builder: (_) => const EditProfileScreen());
    case BiographyScreen.routeName:
      return MaterialPageRoute(builder: (_) => const BiographyScreen());
    case MotivationScreen.routeName:
      return MaterialPageRoute(builder: (_) => const MotivationScreen());
    case PassionScreen.routeName:
      return MaterialPageRoute(builder: (_) => const PassionScreen());
    case HoursPerWeekScreen.routeName:
      return MaterialPageRoute(builder: (_) => const HoursPerWeekScreen());
    case PrivacyPolicyScreen.routeName:
      return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
    case TermsAndConditionScreen.routeName:
      return MaterialPageRoute(builder: (_) => const TermsAndConditionScreen());
    case VerifyPhoneScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      String userName = arg['username'] as String;
      return MaterialPageRoute(
          builder: (_) => VerifyPhoneScreen(
                username: userName,
              ));
    case TestScreen.routeName:
      return MaterialPageRoute(builder: (_) => const TestScreen());
    case NetworkLostScreen.routeName:
      Map<String, dynamic> arg = arguments as Map<String, dynamic>;
      bool isSplash = arg['isSplash'] as bool? ?? false;
      return MaterialPageRoute(
          builder: (_) => NetworkLostScreen(
                isSplash: isSplash,
              ));
    // case YourMatchesScreen.routeName:
    //   return MaterialPageRoute(builder: (_) => const YourMatchesScreen());
    // case ProfileScreen.routeName:
    //   return MaterialPageRoute(builder: (_) => const ProfileScreen());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}
