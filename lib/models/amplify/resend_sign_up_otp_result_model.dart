//this same model will be using for sign up and Otp confirmation using amplify.
class ResendSignUpOtpResultModel {
  String?
      warningInfo; // show warning info according to isSignUpComplete on result.
  int resultType;
  ResendSignUpOtpResultModel({
    required this.resultType,
    this.warningInfo,
  });
}
