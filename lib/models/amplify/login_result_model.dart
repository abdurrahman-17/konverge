import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class LoginResultModel {
  SignInResult? result; //if isSignedIn on result is true, sign in auth success.
  String? warningInfo; // show warning info according to isSignedIn on result.
  String? userName;
  int? resultType;
  LoginResultModel({
    this.result,
    this.userName,
    this.resultType,
    required this.warningInfo,
  });
}
