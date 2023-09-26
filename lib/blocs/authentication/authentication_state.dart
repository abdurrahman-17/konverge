part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends AuthenticationState {}

// class LoggedInState extends AuthenticationState {
//   final UserModel? user;
//
//   const LoggedInState({this.user});
// }

class LoginSuccessState extends AuthenticationState {
  final LoginType loginType;
  final User? user;

  const LoginSuccessState({
    this.user,
    this.loginType = LoginType.usernameAndPassword,
  });
}

class LoggedOutState extends AuthenticationState {}

class LoginErrorState extends AuthenticationState {
  final String errorMessage;
  final LoginType loginType;

  const LoginErrorState({
    required this.errorMessage,
    this.loginType = LoginType.usernameAndPassword,
  });
}

class LoginConfirmAccountState extends AuthenticationState {
  final String userName;
  final String? warning;

  const LoginConfirmAccountState(
    this.userName,
    this.warning,
  );
}

class SignUpSuccessfulState extends AuthenticationState {
  final String? userName;

  const SignUpSuccessfulState({
    this.userName,
  });
}

class OtpVerificationSuccess extends AuthenticationState {
  final String userName;

  const OtpVerificationSuccess(
    this.userName,
  );
}
class EmailOtpVerificationTriggerSuccess extends AuthenticationState {
  final isResendOTP;
  const EmailOtpVerificationTriggerSuccess({this.isResendOTP});
}
class EmailOtpVerificationTriggerFailed extends AuthenticationState {
  final message;
  const EmailOtpVerificationTriggerFailed(this.message
  );
}
class EmailOtpValidationFailed extends AuthenticationState {
  final message;
  const EmailOtpValidationFailed(this.message
  );}
class EmailOtpValidationSuccess extends AuthenticationState {
  final message;
  const EmailOtpValidationSuccess(this.message
      );
}


class OtpVerificationFailed extends AuthenticationState {}

class ResendSignUpOtpSuccess extends AuthenticationState {}

class ResendSignUpOtpFailed extends AuthenticationState {
  final String errorMessage;

  const ResendSignUpOtpFailed(
    this.errorMessage,
  );
}

class ForgotPasswordRequestSuccessState extends AuthenticationState {
  final String userName;

  const ForgotPasswordRequestSuccessState(
    this.userName,
  );
}

class ForgotPasswordResendRequestSuccessState extends AuthenticationState {
  final String userName;

  const ForgotPasswordResendRequestSuccessState(
    this.userName,
  );
}

class ResetPasswordSuccessState extends AuthenticationState {}

class ResetPasswordErrorState extends AuthenticationState {
  final String warning;

  const ResetPasswordErrorState(
    this.warning,
  );
}

class LoginLoadingState extends AuthenticationState {
  final LoginType loginType;

  const LoginLoadingState({this.loginType = LoginType.usernameAndPassword});
}

//create with email and password successfully done state
// class AccountCreatedState extends AuthenticationState {
//   final UserModel user;
//
//   const AccountCreatedState(
//     this.user,
//   );
// }

class ResetEmailSendState extends AuthenticationState {}

class UpdatePasswordSuccessState extends AuthenticationState {}

class UpdatePasswordErrorState extends AuthenticationState {
  final String warning;

  const UpdatePasswordErrorState(
    this.warning,
  );
}

class ResetEmailSendFailed extends AuthenticationState {}

class ValidatedState extends AuthenticationState {
  final bool isValid;

  const ValidatedState({required this.isValid});
}

///SIGN-OUT
class SignOutState extends AuthenticationState {
  final ApiStatus signOutStatus;
  const SignOutState({required this.signOutStatus});

  @override
  List<Object> get props => [signOutStatus];
}

class ResetPasswordOtpFailureState extends AuthenticationState {
  final String errorMessage;
  final LoginType loginType;

  const ResetPasswordOtpFailureState({
    required this.errorMessage,
    this.loginType = LoginType.usernameAndPassword,
  });
}
