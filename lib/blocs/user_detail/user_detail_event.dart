part of 'user_detail_bloc.dart';

abstract class UserDetailEvent extends Equatable {
  const UserDetailEvent();

  @override
  List<Object> get props => [];
}

class UserDetailInitialEvent extends UserDetailEvent {}

// class GetUserDataEvent extends UserDetailEvent {
//   final String userId;
//
//   const GetUserDataEvent({required this.userId});
// }

// class SaveUserDataEvent extends UserDetailEvent {
//   final UserModel user;
//
//   const SaveUserDataEvent({required this.user});
// }

class UpdateProfileImageEvent extends UserDetailEvent {
  final File imageFile;

  const UpdateProfileImageEvent({required this.imageFile});
}

class UserLastLoginTimeUpdateEvent extends UserDetailEvent {
  final String userId;

  const UserLastLoginTimeUpdateEvent({
    required this.userId,
  });
}

class SaveProfileImageEvent extends UserDetailEvent {
  final String userId;
  final File imageFile;

  const SaveProfileImageEvent({required this.imageFile, required this.userId});
}

class UpdateProfileImageUrlEvent extends UserDetailEvent {
  final String url;

  const UpdateProfileImageUrlEvent({required this.url});
}

class FetchProfileImageUrl extends UserDetailEvent {
  final String key;

  const FetchProfileImageUrl({required this.key});
}

class FetchUserDetailEvent extends UserDetailEvent {
  final String cognitoId;
  final String searchId;
  final String userId;

  const FetchUserDetailEvent({
    required this.cognitoId,
    required this.searchId,
    required this.userId,
  });
}

class MatchUserDetailEvent extends UserDetailEvent {
  final String userId;
  final UserInfoModel user;
  final bool isMatch;
  final String matchType;

  const MatchUserDetailEvent(
      {required this.userId,
      required this.user,
      required this.isMatch,
      required this.matchType});
}

class UnblockUserDetailEvent extends UserDetailEvent {
  final String userId;
  final String interestedId;

  const UnblockUserDetailEvent(
      {required this.userId, required this.interestedId});
}

class BlockUserDetailEvent extends UserDetailEvent {
  final String userId;
  final String interestedId;

  const BlockUserDetailEvent(
      {required this.userId, required this.interestedId});
}

//create user account
class CreateUserAccountEvent extends UserDetailEvent {
  final Map<String, dynamic> userData;

  const CreateUserAccountEvent({required this.userData});
}

class DeleteUserAccountEvent extends UserDetailEvent {
  final String userId;

  const DeleteUserAccountEvent({required this.userId});
}
