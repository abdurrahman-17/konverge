import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/graphql/user.dart';
import '../../repository/amplify_repo.dart';
import '../../repository/graphql_repo.dart';

import '../../core/locator.dart';
import '../../models/amplify/resend_sign_up_otp_result_model.dart';
import '../../models/amplify/sign_up_request.dart';
import '../../models/amplify/sign_up_result_model.dart';
import '../../services/amplify/amplify_service.dart';
import '../../services/shared_preference_service.dart';
import '../../utilities/constants_amplify.dart';
import '../../utilities/enums.dart';
import '../../utilities/title_string.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AmplifyService amplifyService = AmplifyService();

  AuthenticationBloc() : super(LoginInitialState()) {
    on<LoginInitialEvent>((event, emit) {
      emit(LoginInitialState());
    });

    /*Sign in with phone number and password */
    on<SignInWithPhoneAndPasswordEvent>((event, emit) async {
      emit(const LoginLoadingState());
      var result =
          await Locator.instance.get<AmplifyRepo>().loginWithPhoneNumber(
                event.phoneNumber,
                event.password,
              );
      result.fold(
        (error) {
          log('error.message ${error.message}');
          emit(LoginErrorState(errorMessage: error.message));
        },
        (success) {
          if (success.resultType == ConstantsAmplify.resultOk) {
            Locator.instance.get<GraphqlRepo>().updateLoginTimeToDb();
            print("emiting : LoginSuccessState "+event.phoneNumber);
            emit(const LoginSuccessState());
          } else if (success.resultType ==
              ConstantsAmplify.errorUserNotConfirmed) {
            print("emiting : LoginConfirmAccountState "+event.phoneNumber);
            emit(LoginConfirmAccountState(
                event.phoneNumber, TitleString.warningConfirmPhoneNumber));
          }
        },
      );
    });
    /*Sign in with phone number and password */
    on<UpdatePasswordEvent>((event, emit) async {
      emit(const LoginLoadingState());
      var result = await Locator.instance.get<AmplifyRepo>().updatePassword(
            event.oldPassword,
            event.newPassword,
          );
      result.fold(
        (error) {
          log('error.message ${error.message}');
          emit(UpdatePasswordErrorState(error.message));
        },
        (success) {
          emit(UpdatePasswordSuccessState());
        },
      );
    });

    /*SignUpWithPhoneAndPasswordEvent*/
    on<SignUpWithPhoneAndPasswordEvent>((event, emit) async {
      emit(const LoginLoadingState());
      /*SignUpResultModel signUpResultModel =
            await Locator.instance.get<AmplifyService>().signUp(event.signUpRequest, event.phoneNumber);*/
      var result =
          await Locator.instance.get<AmplifyRepo>().signUpWithPhoneNumber(
                event.signUpRequest,
                event.phoneNumber,
              );
      result
          .fold((error) => {emit(LoginErrorState(errorMessage: error.message))},
              (success) {
        switch (success.resultType) {
          case ConstantsAmplify.resultOk:
            emit(SignUpSuccessfulState(userName: event.phoneNumber));
            break;
          case ConstantsAmplify.userAlreadyRegistered:
            emit(const LoginErrorState(
                errorMessage: TitleString.warningUserNameAlreadyExists));
            break;
          default:
            emit(LoginErrorState(errorMessage: success.warningInfo!));
        }
      });
    });
    /*ForgotPassword trigger otp Event*/
    on<ForgotPasswordSendOtpEvent>((event, emit) async {
      emit(const LoginLoadingState());
      var result = await Locator.instance
          .get<AmplifyRepo>()
          .initForgetPasswordReq(event.phoneNumber);
      result.fold(
        (error) => {
          emit(
            LoginErrorState(errorMessage: error.message),
          ),
        },
        (success) {
          switch (success.resultType) {
            case ConstantsAmplify.resultOk:
              if (event.isResendOTP) {
                emit(
                  ForgotPasswordResendRequestSuccessState(event.phoneNumber),
                );
              } else {
                emit(
                  ForgotPasswordRequestSuccessState(event.phoneNumber),
                );
              }
              break;
            case ConstantsAmplify.userNotRegistered:
              emit(
                LoginErrorState(
                  errorMessage:
                      '${event.phoneNumber}${TitleString.phoneNumberNotRegistered}',
                ),
              );
              break;
            default:
              emit(
                LoginErrorState(
                  errorMessage: success.warningInfo!,
                ),
              );
          }
        },
      );
    });
    /*Reset password event to send new password and confirmation code to aws.*/
    on<ResetPasswordEvent>((event, emit) async {
      emit(const LoginLoadingState());
      var result = await Locator.instance.get<AmplifyRepo>().resetPassword(
            event.userName,
            event.confirmationCode,
            event.newPassword,
          );
      result.fold(
        (error) => {
          emit(
            ResetPasswordOtpFailureState(errorMessage: error.message),
          ),
        },
        (success) {
          switch (success.resultType) {
            case ConstantsAmplify.resultOk:
              emit(ResetPasswordSuccessState());
              break;
            default:
              emit(
                LoginErrorState(errorMessage: success.warningInfo!),
              );
          }
        },
      );
    });

    /*Verify OTP*/
    on<VerifyOtpEvent>((event, emit) async {
      emit(const LoginLoadingState());
      SignUpResultModel signUpResultModel =
          await amplifyService.confirmSignUp(event.phoneNumber, event.otp);
      switch (signUpResultModel.resultType) {
        case ConstantsAmplify.resultOk:
          emit(OtpVerificationSuccess(event.phoneNumber));
          break;
        case ConstantsAmplify.wrongOtp:
          emit(OtpVerificationFailed());
          break;
        case ConstantsAmplify.expiredCode:
          emit(OtpVerificationFailed());
          break;
        default:
          emit(LoginErrorState(errorMessage: signUpResultModel.warningInfo!));
      }
    });
    /*Resend signup OTP*/
    on<ResendSignUpOtpEvent>((event, emit) async {
      emit(const LoginLoadingState());
      ResendSignUpOtpResultModel resendOtpResultModel =
          await amplifyService.resendSignUpOtp(event.phoneNumber);
      switch (resendOtpResultModel.resultType) {
        case ConstantsAmplify.resultOk:
          emit(ResendSignUpOtpSuccess());
          break;
        default:
          emit(ResendSignUpOtpFailed(resendOtpResultModel.warningInfo!));
      }
    });

    /*Resend signup OTP*/
    on<StartEmailVerificationEvent>((event, emit) async {
      emit(const LoginLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .triggerEmailVerificationProcess();
      result.fold(
        (error) {
          emit(EmailOtpVerificationTriggerFailed(error.message.toString()));
        },
        (success) {
          emit(
            EmailOtpVerificationTriggerSuccess(isResendOTP: event.isResendOtp),
          );
        },
      );
    });
    /*Resend signup OTP*/
    on<StartEmailOtpVerificationEvent>((event, emit) async {
      emit(const LoginLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .verifyEmailOtpVerificationProcess(event.otp);
      result.fold(
        (error) {
          emit(EmailOtpValidationFailed(error.message.toString()));
        },
        (success) {
          emit(
            EmailOtpValidationSuccess(success.message),
          );
        },
      );
    });

    /*SignOut*/
    on<SignOutEvent>((event, emit) async {
      emit(const SignOutState(signOutStatus: ApiStatus.loading));
      final result = await Locator.instance.get<AmplifyRepo>().signOut();
      if (result) {
        /*clear username from local.*/
        Locator.instance.get<SharedPrefServices>().clearSharedPref();
        emit(const SignOutState(signOutStatus: ApiStatus.success));
      } else {
        emit(const SignOutState(signOutStatus: ApiStatus.error));
      }
    });

    /*SignInWithGoogle*/
    on<SignInWithGoogleEvent>((event, emit) async {
      emit(const LoginLoadingState(
        loginType: LoginType.google,
      ));

      final result = await Locator.instance
          .get<AmplifyRepo>()
          .signInWithSocialLogin(LoginType.google);
      final state = result.fold((fail) {
        return LoginErrorState(
          errorMessage: fail.message,
          loginType: LoginType.google,
        );
      }, (success) {
        return LoginSuccessState(
          user: success,
          loginType: LoginType.google,
        );
      });
      emit(state);
    });

    /*SignInWithApple*/
    on<SignInWithAppleEvent>((event, emit) async {
      emit(const LoginLoadingState(
        loginType: LoginType.apple,
      ));

      final result = await Locator.instance
          .get<AmplifyRepo>()
          .signInWithSocialLogin(LoginType.apple);
      final state = result.fold((fail) {
        return LoginErrorState(
          errorMessage: fail.message,
          loginType: LoginType.apple,
        );
      }, (success) {
        return LoginSuccessState(
          user: success,
          loginType: LoginType.apple,
        );
      });
      emit(state);
    });
  }
}
