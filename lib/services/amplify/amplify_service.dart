// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:aws_common/vm.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:dartz/dartz.dart';
import '../../core/locator.dart';
import '../../models/repo/error_model.dart';
import '../../models/repo/success_base_model.dart';
import '../../utilities/constants.dart';
import '../../utilities/enums.dart';
import '../shared_preference_service.dart';
import '../../utilities/title_string.dart';

import '../../models/amplify/common_result_model.dart';
import '../../models/amplify/login_result_model.dart';
import '../../models/amplify/resend_sign_up_otp_result_model.dart';
import '../../models/amplify/sign_up_request.dart';
import '../../models/amplify/sign_up_result_model.dart';
import '../../models/graphql/user.dart';
import '../../utilities/constants_amplify.dart';
import 'amplify_configuration.dart';

String getAuthError(AuthException e) {
  String errorMsg = '';
  if (e.message.isNotEmpty) {
    errorMsg = e.message;
  } else if (e.underlyingException.toString().isNotEmpty) {
    errorMsg = e.underlyingException.toString();
  } else {
    errorMsg = "Authentication failed";
  }
  return errorMsg;
}

class AmplifyService {
  Future<bool> configureAmplify() async {
    try {
      AmplifyAuthCognito amplifyCognito = AmplifyAuthCognito();
      await Amplify.addPlugins([amplifyCognito, AmplifyStorageS3()]);
      print(amplifyConfiguration);
      await Amplify.configure(json.encode(amplifyConfiguration));
      print("Amplify configuration successful");
      return true;
    } catch (e) {
      print(e.toString());
      print("Amplify configuration error");
      return false;
    }
  }

  Future<Either<ErrorModel, SignUpResultModel>> signUp(
    SignUpRequestModel request,
    String phoneNumber,
  ) async {
    try {
      Map<CognitoUserAttributeKey, String> userAttributes = {
        CognitoUserAttributeKey.email: request.email,
        CognitoUserAttributeKey.givenName: request.firstName,
        CognitoUserAttributeKey.familyName: request.lastName,
        CognitoUserAttributeKey.phoneNumber: phoneNumber,
        CognitoUserAttributeKey.birthdate: request.birthDate,
        CognitoUserAttributeKey.address: request.city,
      };
      var signUpResult = await Amplify.Auth.signUp(
        username: phoneNumber + Constants.awsUsernameTail,
        password: request.password,
        options: SignUpOptions(userAttributes: userAttributes),
      );

      return Right(
        SignUpResultModel(
          resultType: ConstantsAmplify.resultOk,
          warningInfo: signUpResult.nextStep.signUpStep.name,
          result: signUpResult,
        ),
      );
    } on ExpiredCodeException catch (e) {
      log("ExpiredCodeException:$e");
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: e.message,
        ),
      );
    } on InvalidParameterException catch (e) {
      log(e.toString());
      //this exception happens if any of the parameters sent to aws is wrong.
      //or if a phone number does not have country code , the same exception
      //will return.
      var errorMessage = e.message;
      /* return SignUpResultModel(
          resultType: ConstantsAmplify.invalidParameterWhileRegister,
          warningInfo: errorMessage);*/
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: errorMessage,
        ),
      );
    } on UsernameExistsException {
      var errorMessage = TitleString.warningUserNameAlreadyExists;
      /*return SignUpResultModel(
          resultType: ConstantsAmplify.userAlreadyRegistered,
          warningInfo: errorMessage);*/
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: errorMessage,
        ),
      );
    } on InvalidPasswordException {
      // await Sentry.captureException(e, stackTrace: m);
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: "The provided password does not meet the required criteria",
        ),
      );
    } on AuthException catch (e) {
      safePrint("error $e");
      log("error ${e.underlyingException}");
      /*return SignUpResultModel(
          resultType: ConstantsAmplify.errorAuthException,
          warningInfo: errorMessage);*/
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: getAuthError(e),
        ),
      );
    } catch (e) {
      log(e.toString());
      /*return SignUpResultModel(
          resultType: ConstantsAmplify.errorUnknown,
          warningInfo: "Internet connection error");*/
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: "Unknown error",
        ),
      );
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession(
        options: const FetchAuthSessionOptions(forceRefresh: true),
      );
      final authenticated = session.isSignedIn;
      log("session:$authenticated");
      return authenticated;
    } catch (e) {
      return false;
    }
  }

  Future<Either<ErrorModel, LoginResultModel>> signIn(
      String userName, String password) async {
    String errorMessage = "";
    try {
      log("Jithin 1: inside sign in  ");

      var signInResult = await Amplify.Auth.signIn(
        username: userName + Constants.awsUsernameTail,
        password: password,
      );
      log("Jithin 2: " + signInResult.toString());

      if (signInResult.isSignedIn) {
        //saving username locally for using on frontend.
        Locator.instance.get<SharedPrefServices>().setUserName(userName);
        return Right(
          LoginResultModel(
            warningInfo: signInResult.nextStep.signInStep.name,
            resultType: ConstantsAmplify.resultOk,
            result: signInResult,
          ),
        );
      } else if (signInResult.nextStep.signInStep.name == "confirmSignUp") {
        return Right(
          LoginResultModel(
            warningInfo: errorMessage,
            resultType: ConstantsAmplify.errorUserNotConfirmed,
            userName: userName,
          ),
        );
      }
    } on UserNotConfirmedException {
      return Right(
        LoginResultModel(
          warningInfo: errorMessage,
          resultType: ConstantsAmplify.errorUserNotConfirmed,
          userName: userName,
        ),
      );
    } on AuthException catch (e) {
      errorMessage = getAuthError(e);
    } on SocketException catch (e) {
      errorMessage = e.message;
    } on Exception catch (e) {
      // errorMessage = e.message;
      log("Jithin 4: " + e.toString());
    } catch (e) {
      if (e is SocketException) {
        // Handle the SocketException here
        print('SocketException occurred: $e');
      }
      errorMessage = "Something went wrong, check network and try again";
    }
    return Left(
      ErrorModel(
        type: ErrorType.normalWarning,
        message: errorMessage,
      ),
    );
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updatePassword(
      String oldPassword, String newPassword) async {
    String errorMessage = "";
    try {
      await Amplify.Auth.updatePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      return Right(
        SuccessBaseModel(
          message: "Password updated successfully",
        ),
      );
    } on AuthException catch (e) {
      errorMessage = getAuthError(e);
    } on Exception catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = "Error 600";
    }
    return Left(
      ErrorModel(
        type: ErrorType.normalWarning,
        message: errorMessage,
      ),
    );
  }

  Future<bool> signOut() async {
    try {
      await Amplify.Auth.signOut();
      log("Sign out successful");
      return true;
    } catch (e) {
      log("error while sign out ; $e");
      return false;
    }
  }

  Future<SignUpResultModel> confirmSignUp(
      String userName, String confirmationCode) async {
    try {
      var signUpResult = await Amplify.Auth.confirmSignUp(
        username: "${userName}_konverge",
        confirmationCode: confirmationCode,
      );
      return SignUpResultModel(
        resultType: ConstantsAmplify.resultOk,
        warningInfo: signUpResult.nextStep.signUpStep.name,
        result: signUpResult,
      );
    } on CodeMismatchException catch (e) {
      log(e.toString());
      String errorMessage = e.underlyingException.toString();
      return SignUpResultModel(
        resultType: ConstantsAmplify.wrongOtp,
        warningInfo: errorMessage,
      );
    } on ExpiredCodeException catch (e) {
      log(e.toString());
      String errorMessage = e.underlyingException.toString();
      return SignUpResultModel(
        resultType: ConstantsAmplify.expiredCode,
        warningInfo: errorMessage,
      );
    } on AuthException catch (e) {
      log(e.toString());
      String errorMessage = getAuthError(e);
      return SignUpResultModel(
        resultType: ConstantsAmplify.errorAuthException,
        warningInfo: errorMessage,
      );
    } on Exception catch (e) {
      log(e.toString());
      return SignUpResultModel(
        resultType: ConstantsAmplify.errorUnknown,
        warningInfo: e.toString(),
      );
    }
  }

  Future<ResendSignUpOtpResultModel> resendSignUpOtp(String userName) async {
    try {
      await Amplify.Auth.resendSignUpCode(
          username: userName + Constants.awsUsernameTail);
      return ResendSignUpOtpResultModel(
        resultType: ConstantsAmplify.resultOk,
      );
    } on LimitExceededException {
      return ResendSignUpOtpResultModel(
        resultType: ConstantsAmplify.errorUnknown,
        warningInfo: TitleString.warningOtpSendLimitExceeded,
      );
    } on Exception catch (e) {
      return ResendSignUpOtpResultModel(
        resultType: ConstantsAmplify.errorUnknown,
        warningInfo: e.toString(),
      );
    }
  }

  /*to send otp to init reset password.*/
  Future<Either<ErrorModel, ResendSignUpOtpResultModel>> initForgetPasswordReq(
      String userName) async {
    try {
      await Amplify.Auth.resetPassword(
        username: userName + Constants.awsUsernameTail,
      );
      return Right(
        ResendSignUpOtpResultModel(
          resultType: ConstantsAmplify.resultOk,
        ),
      );
    } on LimitExceededException catch (e) {
      safePrint(e);
      return Right(
        ResendSignUpOtpResultModel(
          resultType: ConstantsAmplify.errorUnknown,
          warningInfo: TitleString.warningOtpSendLimitExceeded,
        ),
      );
    } on Exception catch (e) {
      safePrint(e);
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<ErrorModel, CommonResultModel>> resetPassword(
      String userName, String confirmationCode, String newPassword) async {
    try {
      await Amplify.Auth.confirmResetPassword(
        username: userName + Constants.awsUsernameTail,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );
      return Right(
        CommonResultModel(
          resultType: ConstantsAmplify.resultOk,
        ),
      );
    } on AuthException catch (e) {
      safePrint("error $e");
      log("OTP : error ${e.underlyingException}");
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: getAuthError(e),
        ),
      );
    } on Exception catch (e) {
      safePrint(e);
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: e.toString(),
        ),
      );
    }
  }

  Future<CognitoUserPoolTokens?> getTokens() async {
    try {
      final cognitoPlugin =
          Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
      final session = await cognitoPlugin.fetchAuthSession(
        options: const FetchAuthSessionOptions(forceRefresh: true),
      );

      final tokens = (session).userPoolTokensResult.value;
      log("id token starting: ${tokens.idToken} completed");
      return tokens;
    } catch (e) {
      log("getTokensException:$e");
      return null;
    }
  }

  Future<String> getCognitoId() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final id = user.userId;
      // userPoolTokens = tokens;
      log("cognito_id: $id");
      return id;
    } catch (e) {
      return "";
    }
  }

  Future<String> getRefreshToken() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession(
        options: const FetchAuthSessionOptions(forceRefresh: true),
      );
      final tokens = (session as CognitoAuthSession).userPoolTokensResult.value;
      log("{token : ${tokens.idToken.raw}");
      log("id token starting: ${tokens.idToken.raw} completed");

      return tokens.idToken.raw;
    } catch (e) {
      return "";
    }
  }

  Future<String> getAccessToken() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession(
        options: const FetchAuthSessionOptions(forceRefresh: true),
      );
      final tokens = (session as CognitoAuthSession).userPoolTokensResult.value;
      log("{access token : ${tokens.accessToken.raw}");
      return tokens.accessToken.raw;
    } catch (e) {
      return "";
    }
  }

  Future<User?> getCurrentUserAttributes() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      if (result.isNotEmpty) {
        String email = "";
        String phoneNumber = "";
        String givenName = "";
        String lastName = "";
        String city = "";
        String birthDate = "";
        for (final element in result) {
          print('key: ${element.userAttributeKey}; value: ${element.value}');
          if (element.userAttributeKey == CognitoUserAttributeKey.email) {
            email = element.value;
          }
          if (element.userAttributeKey == CognitoUserAttributeKey.phoneNumber) {
            phoneNumber = element.value;
          }
          if (element.userAttributeKey == CognitoUserAttributeKey.givenName) {
            givenName = element.value;
          }
          if (element.userAttributeKey == CognitoUserAttributeKey.familyName) {
            lastName = element.value;
          }
          if (element.userAttributeKey == CognitoUserAttributeKey.birthdate) {
            birthDate = element.value;
          }
          if (element.userAttributeKey == CognitoUserAttributeKey.address) {
            city = element.value;
          }
        }
        var user = User(
          email: email,
          phoneNumber: phoneNumber,
          city: city,
          lastName: lastName,
          firstName: givenName,
          birthDate: birthDate,
        );
        return user;
      }
    } on AuthException catch (e) {
      print(e.message);
      return null;
    }
    return null;
  }

  Future<List<String>> getStoragePath(String fileKey) async {
    if (fileKey.isEmpty) {
      return ["", "No file found"];
    }
    return [Constants.storageUrl + fileKey, ""];
    // try {
    //   if (fileKey.isEmpty) {
    //     return ["", "No file found"];
    //   }
    //   // final result = await Amplify.Storage.getUrl(
    //   //   key: fileKey,
    //   // ).result;
    //   // return [result.url.toString(), ""];
    // } on StorageException catch (e) {
    //  // log('message: ${e.message}');
    //   return ["", e.message];
    // }
  }

  //s3 bucket upload file
  Future<List<String?>> uploadFileToS3Bucket(
      {required File file, String? fileName}) async {
    try {
      fileName ??= "sample.jpg";
      final awsFile = AWSFilePlatform.fromFile(file);
      final usr = await Amplify.Auth.getCurrentUser();
      log("user $usr");
      final amplifyResult = await Amplify.Storage.list().result;
      log('Listed items: $amplifyResult');
      final result = await Amplify.Storage.uploadFile(
        localFile: awsFile,
        key: fileName,
        options:
            StorageUploadFileOptions(accessLevel: StorageAccessLevel.guest),
        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.fractionCompleted}');
        },
      ).result;
      return [result.uploadedItem.key, ""];
    } on StorageException catch (e) {
      log('Error uploading file: $e');
      return [null, "Error uploading file:"];
    } on SessionExpiredException catch (e) {
      log("SessionExpiredExceptionUpload:$e");
      return [null, "Error uploading file:"];
    } catch (e) {
      log("uploadFileToS3BucketException:$e");
      return [null, "Error uploading file:"];
    }
  }

  //get user data
  Future<AuthUser?> getCognitoUserData() async {
    try {
      AuthUser user = await Amplify.Auth.getCurrentUser();
      log(user.userId);
      log(user.username);
      return user;
    } catch (e) {
      log('getUserData:$e');
      return null;
    }
  }

  ///social login
  Future<Either<ErrorModel, User>> signInWithSocialLogin(
      LoginType loginType) async {
    log("signInWithSocialLogin");
    try {
      SignInResult? result;
      switch (loginType) {
        case LoginType.google:
          result = await Amplify.Auth.signInWithWebUI(
            provider: AuthProvider.google,
            // options: const SignInWithWebUIOptions(
            //   pluginOptions: CognitoSignInWithWebUIPluginOptions(
            //     isPreferPrivateSession: true,
            //   ),
            // ),
          );
          break;

        case LoginType.apple:
          result = await Amplify.Auth.signInWithWebUI(
            provider: AuthProvider.apple,
          );
          break;

        default:
          result = null;
          break;
      }

      if (result != null) {
        log("socialAuth:${result.isSignedIn}");
        AuthUser? authUser = await getCognitoUserData();
        User user = User(cognitoId: authUser?.userId);
        return Right(user);
      } else {
        log("errorTriggered");
        return Left(
          ErrorModel(
            message: "$loginType is not implemented",
            type: ErrorType.normalWarning,
          ),
        );
      }
    } on AmplifyException catch (e) {
      log("AmplifyException:$e");
      return Left(
        ErrorModel(
          message: e.message,
          type: ErrorType.normalWarning,
        ),
      );
    } catch (e) {
      log("catch:$e");
      return Left(
        ErrorModel(
          message: "No internet connection",
          type: ErrorType.normalWarning,
        ),
      );
    }
  }
}
