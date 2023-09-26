//this same model will be using for sign up and Otp confirmation using amplify.
class CommonResultModel {
  String? warningInfo; // show warning
  int resultType; // if result is ok, warning info won't be showing
  CommonResultModel({
    required this.resultType,
    this.warningInfo,
  });
}
