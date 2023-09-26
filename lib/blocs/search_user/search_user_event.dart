part of 'search_user_bloc.dart';

abstract class SearchUserEvent extends Equatable {
  const SearchUserEvent();

  @override
  List<Object> get props => [];
}

class SearchUserInitialEvent extends SearchUserEvent {}

class FetchSearchUsersEvent extends SearchUserEvent {
  final String query;

  const FetchSearchUsersEvent({required this.query});
}

class FetchAutoCompleteEvent extends SearchUserEvent {
  final String query;
  final String userId;

  const FetchAutoCompleteEvent({required this.query, required this.userId});
}

class AddToRecentSearchEvent extends SearchUserEvent {
  final UserInfoModel user;

  const AddToRecentSearchEvent({required this.user});
}

class DeleteRecentSearchEvent extends SearchUserEvent {
  final String cognitoId;

  const DeleteRecentSearchEvent({required this.cognitoId});
}

class DeleteRecentSearchListEvent extends SearchUserEvent {}
