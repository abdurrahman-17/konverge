import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

//this same model will be using for sign up and Otp confirmation using amplify.
class SignUpResultModel {
  //if isSignUpComplete on result is true, User registration
  //successfully completed.
  SignUpResult? result;
  // show warning info according to isSignUpComplete on result.
  String? warningInfo;
  int resultType;
  SignUpResultModel({
    this.result,
    required this.resultType,
    required this.warningInfo,
  });
}
