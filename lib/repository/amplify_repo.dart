import 'package:dartz/dartz.dart';
import '../models/amplify/common_result_model.dart';
import '../models/amplify/resend_sign_up_otp_result_model.dart';
import '../models/graphql/user.dart';
import '../models/repo/success_base_model.dart';
import '../../core/locator.dart';
import '../../models/amplify/login_result_model.dart';
import '../../models/amplify/sign_up_request.dart';
import '../../models/amplify/sign_up_result_model.dart';
import '../../models/repo/error_model.dart';
import '../../services/amplify/amplify_service.dart';
import '../utilities/enums.dart';

class AmplifyRepo {
  Future<Either<ErrorModel, SignUpResultModel>> signUpWithPhoneNumber(
      SignUpRequestModel request, String phoneNumber) async {
    return await Locator.instance
        .get<AmplifyService>()
        .signUp(request, phoneNumber);
  }

  Future<Either<ErrorModel, LoginResultModel>> loginWithPhoneNumber(
      String phoneNumber, String password) async {
    var isUserLoggedIn =
        await Locator.instance.get<AmplifyService>().isUserLoggedIn();
    if (isUserLoggedIn) {
      // var isSignedOut =
      await Locator.instance.get<AmplifyService>().signOut();
    }
    Either<ErrorModel, LoginResultModel> loginModel = await Locator.instance
        .get<AmplifyService>()
        .signIn(phoneNumber, password);

    loginModel.fold((error) => {}, (success) {
      print("++++++++++++++++++++++++" + success.userName.toString());
    });
    return loginModel;
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updatePassword(
      String oldPassword, String newPassword) async {
    return await Locator.instance
        .get<AmplifyService>()
        .updatePassword(oldPassword, newPassword);
  }

  Future<Either<ErrorModel, ResendSignUpOtpResultModel>> initForgetPasswordReq(
      String username) async {
    return await Locator.instance
        .get<AmplifyService>()
        .initForgetPasswordReq(username);
  }

  Future<Either<ErrorModel, CommonResultModel>> resetPassword(
      String username, String confirmationCode, String newPassword) async {
    return await Locator.instance.get<AmplifyService>().resetPassword(
          username,
          confirmationCode,
          newPassword,
        );
  }

  ///social login
  Future<Either<ErrorModel, User>> signInWithSocialLogin(
      LoginType loginType) async {
    return await Locator.instance
        .get<AmplifyService>()
        .signInWithSocialLogin(loginType);
  }

  ///signOut
  Future<bool> signOut() async =>
      await Locator.instance.get<AmplifyService>().signOut();
}
