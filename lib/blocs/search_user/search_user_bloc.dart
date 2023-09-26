import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../repository/user_repository.dart';
import '../../core/locator.dart';
import '../../models/graphql/user_info.dart';
import '../../repository/graphql_repo.dart';
import '../../services/amplify/amplify_service.dart';
import '../../utilities/enums.dart';

part 'search_user_event.dart';

part 'search_user_state.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  // UserModel? currentUser;
  List<UserInfoModel> recentSearch = [];
  AmplifyService amplifyService = AmplifyService();

  SearchUserBloc() : super(SearchUserInitialState()) {
    on<SearchUserInitialEvent>((event, emit) {
      emit(SearchUserInitialState());
    });

    /*Search Users*/
    on<FetchSearchUsersEvent>((event, emit) async {
      emit(
        FetchSearchUsersState(
            status: ProviderStatus.loading,
            users: [],
            error: "",
            recentUsers: recentSearch),
      );
      String userId =
          Locator.instance.get<UserRepo>().getCurrentUserData()!.userId!;
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .searchUsers(event.query, userId);
      result.fold(
          (error) => {
                emit(FetchSearchUsersState(
                    status: ProviderStatus.error,
                    users: const [],
                    recentUsers: recentSearch,
                    error: error.message))
              },
          (success) => {
                emit(FetchSearchUsersState(
                    recentUsers: recentSearch,
                    status: ProviderStatus.loaded,
                    users: success,
                    error: ""))
              });
    });

    /*Auto Complete*/
    on<FetchAutoCompleteEvent>((event, emit) async {
      emit(
        const AutoCompleteState(
            status: ProviderStatus.loading, skills: [], names: [], error: ""),
      );
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .autoCompleteName(event.query);
      result.fold(
          (error) => {
                emit(AutoCompleteState(
                    status: ProviderStatus.error,
                    skills: const [],
                    names: const [],
                    error: error.message))
              },
          (success) => {
                emit(AutoCompleteState(
                    status: ProviderStatus.error,
                    skills: success!.autocompleteNamesSkills!.skills!,
                    names: success.autocompleteNamesSkills!.fullName!,
                    error: ""))
              });
    });

    /*Rec*/
    on<AddToRecentSearchEvent>((event, emit) async {
      emit(SearchUserInitialState());

      // List<UserInfoModel> temp = [];
      // for (UserInfoModel user in recentSearch) {
      //   temp.add(user);
      // }
      // log("temp $recentSearch");
      // log("recent before ${recentSearch.length}");
      if (recentSearch.isNotEmpty)
        recentSearch
            .removeWhere((user) => user.cognitoId == event.user.cognitoId);
      //  log("recent search user after ${recentSearch.length}");
      recentSearch.insert(0, event.user);
      emit(RecentSearchState(users: recentSearch));
    });

    on<DeleteRecentSearchEvent>((event, emit) async {
      emit(SearchUserInitialState());
      if (recentSearch.isNotEmpty)
        recentSearch
            .removeWhere((user) => user.cognitoId == event.cognitoId);
      emit(RecentSearchState(users: recentSearch));
    });

    on<DeleteRecentSearchListEvent>((event, emit) async {
      emit(SearchUserInitialState());
      recentSearch.clear();
      emit(RecentSearchState(users: recentSearch));
    });
  }
}
