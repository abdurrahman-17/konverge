part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserInitialEvent extends UserEvent {}

// class GetUserDataEvent extends UserEvent {
//   final String userId;
//
//   const GetUserDataEvent({required this.userId});
// }

// class SaveUserDataEvent extends UserEvent {
//   final UserModel user;
//
//   const SaveUserDataEvent({required this.user});
// }

class UpdateProfileImageEvent extends UserEvent {
  final File imageFile;

  const UpdateProfileImageEvent({required this.imageFile});
}


class UserLastLoginTimeUpdateEvent extends UserEvent {
  final String userId;
  const UserLastLoginTimeUpdateEvent({required this.userId,});
}

class SaveProfileImageEvent extends UserEvent {
  final String userId;
  final File imageFile;

  const SaveProfileImageEvent({required this.imageFile, required this.userId});
}

class UpdateProfileImageUrlEvent extends UserEvent {
  final String url;

  const UpdateProfileImageUrlEvent({required this.url});
}

class FetchProfileImageUrl extends UserEvent {
  final String key;

  const FetchProfileImageUrl({required this.key});
}

class FetchUserDetailEvent extends UserEvent {
  final String cognitoId;
  final String searchId;
  final String userId;

  const FetchUserDetailEvent({
    required this.cognitoId,
    required this.searchId,
    required this.userId,
  });
}

class MatchUserEvent extends UserEvent {
  final String userId;
  final UserInfoModel user;
  final bool isMatch;
  final String matchType;

  const MatchUserEvent(
      {required this.userId,
      required this.user,
      required this.isMatch,
      required this.matchType});
}

class UnblockUserEvent extends UserEvent {
  final String userId;
  final String interestedId;

  const UnblockUserEvent({required this.userId, required this.interestedId});
}

class BlockUserEvent extends UserEvent {
  final String userId;
  final String interestedId;

  const BlockUserEvent({required this.userId, required this.interestedId});
}

//create user account
class CreateUserAccountEvent extends UserEvent {
  final Map<String, dynamic> userData;

  const CreateUserAccountEvent({required this.userData});
}

class DeleteUserAccountEvent extends UserEvent {
  final String userId;
  const DeleteUserAccountEvent({required this.userId});
}
