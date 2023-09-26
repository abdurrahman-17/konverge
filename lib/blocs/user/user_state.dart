part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitialState extends UserState {}

// class UserFoundState extends UserState {
//   final UserModel user;
//
//   const UserFoundState(this.user);
// }

class UserNotFound extends UserState {}

class UserDataSavedState extends UserState {}

class UserImageUpdate extends UserState {
  final ProviderStatus status;
  final String filePath;

  const UserImageUpdate({
    required this.status,
    required this.filePath,
  });

  @override
  List<Object> get props => [status];
}

class UserLastLoginTimeUpdateState extends UserState {
  final bool successStatus;
  final String? message;

  const UserLastLoginTimeUpdateState(
    this.message, {
    required this.successStatus,
  });
}

class UserImageSaveState extends UserState {
  final ProviderStatus status;
  final String fileUri;
  final String error;
  final String key;

  const UserImageSaveState({
    required this.status,
    required this.fileUri,
    required this.error,
    required this.key,
  });

  @override
  List<Object> get props => [status];
}

class FetchUserImageUrlState extends UserState {
  final ProviderStatus status;
  final String fileUrl;
  final String error;

  const FetchUserImageUrlState({
    required this.status,
    required this.fileUrl,
    required this.error,
  });

  @override
  List<Object> get props => [status];
}

class FetchUserDetailState extends UserState {
  final ProviderStatus status;
  final UserInfoModel? user;
  final String error;

  const FetchUserDetailState({
    required this.status,
    required this.user,
    required this.error,
  });

  @override
  List<Object> get props => [status];
}

class UserMatchedSuccessState extends UserState {
  final ProviderStatus status;
  final String error;
  final bool isMatch;
  final UserInfoModel? user;
  final bool itsMatch;

  UserMatchedSuccessState({
    required this.status,
    required this.error,
    required this.isMatch,
    required this.itsMatch,
    required this.user,
  });
}

class UserBlockedSuccessState extends UserState {
  final ProviderStatus status;
  final String error;

  const UserBlockedSuccessState({
    required this.status,
    required this.error,
  });
}

class UserUnBlockedSuccessState extends UserState {
  final ProviderStatus status;
  final String error;

  const UserUnBlockedSuccessState({
    required this.status,
    required this.error,
  });
}

//CreateUserAccountState
class CreateUserAccountState extends UserState {
  final ApiStatus userCreateStatus;
  final String? errorMessage;

  const CreateUserAccountState({
    required this.userCreateStatus,
    this.errorMessage,
  });

  @override
  List<Object> get props => [userCreateStatus];
}

//DeleteUserAccountState
class DeleteUserAccountState extends UserState {
  final ApiStatus userDeleteStatus;
  final String? errorMessage;
  const DeleteUserAccountState({
    required this.userDeleteStatus,
    this.errorMessage,
  });

  @override
  List<Object> get props => [userDeleteStatus];
}
