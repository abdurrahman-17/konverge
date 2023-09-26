part of 'search_user_bloc.dart';

abstract class SearchUserState extends Equatable {
  const SearchUserState();

  @override
  List<Object> get props => [];
}

class SearchUserInitialState extends SearchUserState {}

class AutoCompleteState extends SearchUserState {
  final ProviderStatus status;
  final List<String> names;
  final List<String> skills;
  final String error;

  const AutoCompleteState(
      {required this.status,
      required this.names,
      required this.skills,
      required this.error});

  @override
  List<Object> get props => [status];
}

class FetchSearchUsersState extends SearchUserState {
  final ProviderStatus status;
  final List<UserInfoModel> users;
  final List<UserInfoModel> recentUsers;
  final String error;

  const FetchSearchUsersState(
      {required this.status, required this.users,required this.recentUsers, required this.error});

  @override
  List<Object> get props => [status];
}
class RecentSearchState extends SearchUserState {
  final List<UserInfoModel> users;
  const RecentSearchState(
      {required this.users});
}
