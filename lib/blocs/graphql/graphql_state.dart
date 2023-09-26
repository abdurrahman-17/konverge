import 'package:equatable/equatable.dart';
import '../../models/blocked_user_model.dart';
import '../../models/graphql/user_info.dart';
import '../../models/questionnaire/questionnaire.dart';
import '../../models/skills/skills.dart';

abstract class GraphqlState extends Equatable {
  const GraphqlState();

  @override
  List<Object> get props => [];
}

class GraphqlInitialState extends GraphqlState {}

class GraphqlInitialStateMatches extends GraphqlState {}

class GraphqlErrorState extends GraphqlState {
  final String errorMessage;

  const GraphqlErrorState(
    this.errorMessage,
  );
}

class MatchErrorState extends GraphqlState {
  final String errorMessage;

  const MatchErrorState(
    this.errorMessage,
  );
}

class CreateUserSuccessState extends GraphqlState {
  final String data;

  const CreateUserSuccessState(
    this.data,
  );
}

class SaveBiographySuccessState extends GraphqlState {
  final String biography;

  const SaveBiographySuccessState(
    this.biography,
  );
}

class SaveBusinessStageSuccessState extends GraphqlState {
  final String moreInfo;
  final String ideaStage;

  const SaveBusinessStageSuccessState(
    this.ideaStage,
    this.moreInfo,
  );
}

class SaveLevelOfPassionSuccessState extends GraphqlState {
  final int passion;

  const SaveLevelOfPassionSuccessState(
    this.passion,
  );
}

class SaveHoursPerWeekSuccessState extends GraphqlState {
  final int hours;

  const SaveHoursPerWeekSuccessState(
    this.hours,
  );
}

class SaveMotivationListSuccessState extends GraphqlState {
  final Motivation motivation;

  const SaveMotivationListSuccessState(
    this.motivation,
  );
}

class SaveProfileVisibilityListSuccessState extends GraphqlState {
  final ProfileVisibility profileVisibility;

  const SaveProfileVisibilityListSuccessState(
    this.profileVisibility,
  );
}

class SaveSkillsLookingForListSuccessState extends GraphqlState {
  final List<Skills> skillsLookingFor;

  const SaveSkillsLookingForListSuccessState(
    this.skillsLookingFor,
  );
}

class SavePersonalSkillsListSuccessState extends GraphqlState {
  final List<Skills> personalSkills;

  const SavePersonalSkillsListSuccessState(
    this.personalSkills,
  );
}

class SaveInterestListSuccessState extends GraphqlState {
  final List<Skills> interests;

  const SaveInterestListSuccessState(
    this.interests,
  );
}

class ReadMatchCountSuccessState extends GraphqlState {
  final int count;

  const ReadMatchCountSuccessState(
    this.count,
  );
}

class UpdateNotificationReadSuccessStatus extends GraphqlState {
  final String notificationId;

  const UpdateNotificationReadSuccessStatus(
    this.notificationId,
  );
}

class UpdateAccountDetailsSuccessState extends GraphqlState {
  final String firstname;
  final String lastname;
  final String city;
  final String email;
  final String dob;

  const UpdateAccountDetailsSuccessState({
    required this.firstname,
    required this.lastname,
    required this.city,
    required this.email,
    required this.dob,
  });
}

class QueryLoadingState extends GraphqlState {}
class SkillsLoadingState extends GraphqlState {}

class MatchLoadingState extends GraphqlState {}

class PrivacyScreenValuesUpdateSuccessState extends GraphqlState {
  final bool isAllowMatchesMessage;
  final bool isAllowPeopleToSendManualRequest;
  final bool isPushNotificationOn;

  const PrivacyScreenValuesUpdateSuccessState(
    this.isAllowMatchesMessage,
    this.isAllowPeopleToSendManualRequest,
    this.isPushNotificationOn,
  );
}

class QuestionnaireReadSuccessState extends GraphqlState {
  final List<Questionnaire> questionnaireList;

  const QuestionnaireReadSuccessState(
    this.questionnaireList,
  );
}

class SkillsListReadSuccessState extends GraphqlState {
  List<Skills> skills = [];
  List<Skills> interests = [];
  List<Skills> businessIdea = [];

  SkillsListReadSuccessState(
    this.skills,
    this.interests,
    this.businessIdea,
  );
}

class InterestsListReadSuccessState extends GraphqlState {
  final List<Skills> list;

  const InterestsListReadSuccessState(
    this.list,
  );
}

class ReadUserSuccessState extends GraphqlState {
  const ReadUserSuccessState();
}

class QueryUpdateSuccessState extends GraphqlState {}

class UserStageUpdateToServerSuccessState extends GraphqlState {
  final int stage;

  const UserStageUpdateToServerSuccessState(this.stage);
}

class MyQualityOrderUpdateSuccess extends GraphqlState {
  final List<Skills> qualityList;

  const MyQualityOrderUpdateSuccess(this.qualityList);
}

class SkillsSearchSuccessState extends GraphqlState {
  final List<Skills> list;

  const SkillsSearchSuccessState(
    this.list,
  );
}

class UserDetailState extends GraphqlState {
  final UserInfoModel? user;

  const UserDetailState({this.user});
}

class FetchMatchesState extends GraphqlState {
  final List<UserInfoModel> matches;

  const FetchMatchesState({required this.matches});
}

class BlockSuccessState extends GraphqlState {
  const BlockSuccessState();
}

class UnBlockSuccessState extends GraphqlState {
  const UnBlockSuccessState();
}

class PlayerIdSuccessState extends GraphqlState {
  const PlayerIdSuccessState();
}

class MatchSuccessState extends GraphqlState {
  final String error;
  final bool isMatch;
  final UserInfoModel user;
  final bool itsMatch;

  MatchSuccessState({
    required this.error,
    required this.isMatch,
    required this.itsMatch,
    required this.user,
  });
}

class GetBlockedUsersState extends GraphqlState {
  final List<BlockedUserModel> users;

  GetBlockedUsersState({required this.users});
}
