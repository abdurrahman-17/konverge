part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LoginInitialEvent extends AuthenticationEvent {}

class SignInWithPhoneAndPasswordEvent extends AuthenticationEvent {
  final String phoneNumber;
  final String password;

  const SignInWithPhoneAndPasswordEvent({
    required this.phoneNumber,
    required this.password,
  });
}

class UpdatePasswordEvent extends AuthenticationEvent {
  final String oldPassword;
  final String newPassword;

  const UpdatePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });
}

class SignUpWithPhoneAndPasswordEvent extends AuthenticationEvent {
  final SignUpRequestModel signUpRequest;
  final String phoneNumber;

  const SignUpWithPhoneAndPasswordEvent({
    required this.signUpRequest,
    required this.phoneNumber,
  });
}

class ForgotPasswordSendOtpEvent extends AuthenticationEvent {
  final String phoneNumber;
  final bool isResendOTP;

  ForgotPasswordSendOtpEvent({
    required this.phoneNumber,
    this.isResendOTP = false,
  });
}

class ConfirmPhoneNumberEvent extends AuthenticationEvent {
  final String phoneNumber;

  const ConfirmPhoneNumberEvent({
    required this.phoneNumber,
  });
}

class ResetPasswordEvent extends AuthenticationEvent {
  final String confirmationCode;
  final String newPassword;
  final String userName;

  const ResetPasswordEvent({
    required this.userName,
    required this.confirmationCode,
    required this.newPassword,
  });
}

class VerifyOtpEvent extends AuthenticationEvent {
  final String phoneNumber;
  final String otp;

  const VerifyOtpEvent({
    required this.phoneNumber,
    required this.otp,
  });
}
class VerifyEmailOtpEvent extends AuthenticationEvent {
  final String otp;

  const VerifyEmailOtpEvent({
    required this.otp,
  });
}

class ResendSignUpOtpEvent extends AuthenticationEvent {
  final String phoneNumber;

  const ResendSignUpOtpEvent({required this.phoneNumber});
}
class StartEmailVerificationEvent extends AuthenticationEvent {
  final String email;
  final bool isResendOtp;
  StartEmailVerificationEvent({required this.email,this.isResendOtp = false});
}

class StartEmailOtpVerificationEvent extends AuthenticationEvent {
  final String otp;
  const StartEmailOtpVerificationEvent({required this.otp});
}

class SignInWithGoogleEvent extends AuthenticationEvent {}

class SignInWithAppleEvent extends AuthenticationEvent {}

class SignOutEvent extends AuthenticationEvent {}
