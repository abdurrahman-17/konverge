import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/graphql/user_info.dart';
import '../../models/skills/skills.dart';
import '../../services/amplify/amplify_service.dart';
import '../../blocs/graphql/graphql_event.dart';
import '../../blocs/graphql/graphql_state.dart';
import '../../core/locator.dart';
import '../../repository/graphql_repo.dart';
import '../../services/graphql/qql_service.dart';

class GraphqlBloc extends Bloc<GraphqlEvent, GraphqlState> {
  static GraphqlService graphqlService = GraphqlService();
  UserInfoModel? currentUser;
  List<Skills> skills = [];
  List<Skills> interests = [];
  List<Skills> businessIdea = [];

  // AmplifyService amplifyService = AmplifyService();
  GraphqlBloc() : super(GraphqlInitialState()) {
    on<GraphqlInitialEvent>((event, emit) {
      emit(GraphqlInitialState());
    });

    // on<CreateUserEvent>((event, emit) async {
    //   emit(QueryLoadingState());
    //   var result =
    //       await Locator.instance.get<GraphqlRepo>().registerUser(event.user);
    //   result.fold(
    //       (error)  {emit(GraphqlErrorState(error.message.toString()));},
    //       (success)
    //           {emit(CreateUserSuccessState(success.resultData.toString()));});
    // });

    on<UpdateNotificationStatusEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updateNotificationStatus(event.userName, event.isNotificationOn);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(QueryUpdateSuccessState());
        },
      );
    });
    /*To get the information weather the user need an investor or a business partner. */
    on<UpdateInvestOrBusinessPartnerEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updateLookingForInvestOrBusinessPartner(event.investmentTypeValue);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(QueryUpdateSuccessState());
        },
      );
    });

    /*update only allow matches to message you
    * the usage of this event is on privacy screen.*/
    on<UpdatePrivacyScreenDataEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result =
          await Locator.instance.get<GraphqlRepo>().updatePrivacyScreenData(
                event.isAllowMatchesMessage,
                event.isPushNotificationOn,
                event.isAllowPeopleToSendManualRequest,
              );
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(
            PrivacyScreenValuesUpdateSuccessState(
              event.isAllowMatchesMessage,
              event.isAllowPeopleToSendManualRequest,
              event.isPushNotificationOn,
            ),
          );
        },
      );
    });

    on<UpdateBiographyEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updateBiography(event.biography);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(SaveBiographySuccessState(event.biography));
        },
      );
    });

    on<UpdateBusinessStageEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updateBusinessStage(event.ideaStage, event.moreInfo);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(
            SaveBusinessStageSuccessState(
              event.ideaStage,
              event.moreInfo,
            ),
          );
        },
      );
    });

    on<UpdateLevelOfPassionEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updateLevelOfPassion(event.passion);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(SaveLevelOfPassionSuccessState(event.passion));
        },
      );
    });

    on<UpdateHoursPerWeekEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updateHoursPerWeek(event.hours);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(SaveHoursPerWeekSuccessState(event.hours));
        },
      );
    });

    on<UpdateMotivationListEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updateMotivationList(event.motivation);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(SaveMotivationListSuccessState(event.motivation));
        },
      );
    });

    on<UpdateProfileVisibilityListEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updateProfileVisibilityList(event.profileVisibility);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(
            SaveProfileVisibilityListSuccessState(event.profileVisibility),
          );
        },
      );
    });

    on<UpdateSkillsLookingForListEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updateSkillsLookingForList(event.skills);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(SaveSkillsLookingForListSuccessState(event.skills));
        },
      );
    });

    on<UpdatePersonalSkillsListEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updatePersonalSkillsList(event.skills);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(SavePersonalSkillsListSuccessState(event.skills));
        },
      );
    });
    on<ReadMatchCountEvent>((event, emit) async {
      // emit(QueryLoadingState());
      var result = await Locator.instance.get<GraphqlRepo>().getMatchCount();
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(ReadMatchCountSuccessState(success));
        },
      );
    });

    /*this will be triggered when a notification is clicked.*/
    on<UpdateNotificationReadStatusEvent>((event, emit) async {
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updateNotificationReadStatus(event.notificationId);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(UpdateNotificationReadSuccessStatus(event.notificationId));
        },
      );
    });

    on<UpdateAccountInfoEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result =
          await Locator.instance.get<GraphqlRepo>().updateAccountInformation(
                event.firstname,
                event.lastname,
                event.city,
                event.email,
                event.dob,
              );
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(
            UpdateAccountDetailsSuccessState(
              firstname: event.firstname,
              lastname: event.lastname,
              city: event.city,
              email: event.email,
              dob: event.dob,
            ),
          );
        },
      );
    });

    /*Read user model from server, Complete information about a user can be get from this event.*/
    on<ReadLoggedInUserInfoEvent>((event, emit) async {
      emit(QueryLoadingState());
      // var username = Locator.instance.get<SharedPrefServices>().getUserName();
      String cognitoId =
          await Locator.instance.get<AmplifyService>().getCognitoId();

      var result =
          await Locator.instance.get<GraphqlRepo>().readUserInfo(cognitoId);

      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          currentUser = success;
          emit(const ReadUserSuccessState());
        },
      );
    });

    /*Read skill list for skills update screens*/
    on<ReadSkillsListEvent>((event, emit) async {
      emit(SkillsLoadingState());
      var result = await Locator.instance.get<GraphqlRepo>().readSkillsList();
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          skills = success.skills;
          emit(
            SkillsListReadSuccessState(
              success.skills,
              success.interests,
              success.businessIdea,
            ),
          );
        },
      );
    });
    /*Read interest list for interests update screens*/
    on<ReadInterestsListEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance.get<GraphqlRepo>().readInterests();
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(InterestsListReadSuccessState(success.skills));
        },
      );
    });
    /*Read interests list for interests update screens*/
    on<UpdateInterestListEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updatePersonalInterestsList(event.interests);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(SaveInterestListSuccessState(event.interests));
        },
      );
    });
    on<ReadQuestionnaireListEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result =
          await Locator.instance.get<GraphqlRepo>().readQuestionnaire();
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(QuestionnaireReadSuccessState(success.questionnaires));
        },
      );
    });
    on<UpdatePreQuestionnaireInfoEvent>((event, emit) async {
      emit(QueryLoadingState());

      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updatePreQuestionnaireInfo(event.requestModel);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(QueryUpdateSuccessState());
        },
      );
    });
    on<UpdateNavigationStageInfoEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updateUserStageStatus(event.stage);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(UserStageUpdateToServerSuccessState(event.stage));
        },
      );
    });
    on<UpdateMyQualityOrderEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .updateMyQualityOrder(event.myQualityList);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(MyQualityOrderUpdateSuccess(event.myQualityList));
        },
      );
    });
    /*search skill list for skills update screens*/
    on<SearchSkillsListEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = searchSkills(event.query, event.skills);
      emit(SkillsSearchSuccessState(result));
    });
    /*read user DetailEvent*/
    /*Read interest list for interests update screens*/
    on<ReadUserDetailsEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance.get<GraphqlRepo>().readUserDetails(
            event.cognitoID,
            userId: event.userId,
            searchId: event.searchId,
          );
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(UserDetailState(user: success));
        },
      );
    });
    /*Read interest list for interests update screens*/
    on<FetchMatchUserListEvent>((event, emit) async {
      emit(MatchLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .fetchMatchUsers(event.userId, event.skip);
      result.fold(
        (error) {
          emit(MatchErrorState(error.message.toString()));
        },
        (success) {
          emit(FetchMatchesState(matches: success));
        },
      );
    });
    /*Block user*/
    on<BlockUserEvent>((event, emit) async {
      emit(QueryLoadingState());

      var result = await Locator.instance.get<GraphqlRepo>().blockUser(
            userId: event.userId,
            interestId: event.interestedId,
            time: "",
          );
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(const BlockSuccessState());
        },
      );
    });

    /*Un Block user*/
    on<UnblockUserEvent>((event, emit) async {
      emit(QueryLoadingState());
      print("UserId ${event.userId}");
      var result = await Locator.instance.get<GraphqlRepo>().unBlockUser(
            userId: event.userId,
            interestId: event.interestedId,
            time: "",
          );
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(const UnBlockSuccessState());
        },
      );
    });
    /*add player id event*/
    on<AddPlayerIdEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance
          .get<GraphqlRepo>()
          .addPlayerID(userId: event.userId, playerId: event.playerId);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(const PlayerIdSuccessState());
        },
      );
    });
    /*delete player id event*/
    on<DeletePlayerIdEvent>((event, emit) async {
      emit(QueryLoadingState());
      var result = await Locator.instance.get<GraphqlRepo>().deletePlayerId(
            userId: event.userId,
            playerId: event.playerId,
          );
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(const PlayerIdSuccessState());
        },
      );
    });

    /*match user event*/
    on<MatchUserEvent>((event, emit) async {
      // emit(QueryLoadingState());
      var result = await Locator.instance.get<GraphqlRepo>().matchUser(
            userId: event.userId,
            interestedId: event.user.userId!,
            isMatch: event.isMatch,
            matchType: event.matchType,
          );

      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(
            MatchSuccessState(
              error: success.message,
              isMatch: success.isMatch,
              itsMatch: success.itsMatch,
              user: event.user,
            ),
          );
        },
      );
    });

    /*match user from queryEvent*/
    on<MatchUserSearchEvent>((event, emit) async {
      // emit(QueryLoadingState());
      // var result = await Locator.instance
      //     .get<GraphqlRepo>()
      //     .matchUserFromSearch(
      //         userId: event.userId,
      //         interestedId: event.interestedId,
      //         name: event.name);
      // result.fold(
      //     (error)  {emit(GraphqlErrorState(error.message.toString()))},
      //     (success)  {emit( MatchSuccessState())});
    });

    /*get blocked user event*/

    /// need to implement
    ///
    on<GetBlockedUserEvent>((event, emit) async {
      emit(QueryLoadingState());

      var result = await Locator.instance
          .get<GraphqlRepo>()
          .getBlockedUsers(userId: event.userId);
      result.fold(
        (error) {
          emit(GraphqlErrorState(error.message.toString()));
        },
        (success) {
          emit(GetBlockedUsersState(users: success));
        },
      );
    });
  }

  List<Skills> searchSkills(String query, List<Skills> skills) {
    if (skills.isEmpty) {
      return [];
    }
    List<Skills> data = [];
    for (Skills skill in skills) {
      if (skill.skill
          .toLowerCase()
          .contains(query.toString().toLowerCase().trim())) {
        data.add(skill);
      }
    }
    return data;
  }

  void stateChange(Emitter<GraphqlState> emit) {}
}
