import 'package:equatable/equatable.dart';
import '../../models/graphql/user_info.dart';
import '../../models/skills/skills.dart';
import '../../models/graphql/pre_questionnaire_info_request.dart';

abstract class GraphqlEvent extends Equatable {
  const GraphqlEvent();

  @override
  List<Object> get props => [];
}

class GraphqlInitialEvent extends GraphqlEvent {}

// class CreateUserEvent extends GraphqlEvent {
//   final User user;
//
//   const CreateUserEvent({
//     required this.user,
//   });
// }

class UpdateNotificationStatusEvent extends GraphqlEvent {
  final String userName;
  final bool isNotificationOn;

  const UpdateNotificationStatusEvent({
    required this.userName,
    required this.isNotificationOn,
  });
}

class UpdatePreQuestionnaireInfoEvent extends GraphqlEvent {
  final PreQuestionnaireInfoModel requestModel;

  const UpdatePreQuestionnaireInfoEvent({
    required this.requestModel,
  });
}

class UpdateNavigationStageInfoEvent extends GraphqlEvent {
  final int stage;

  const UpdateNavigationStageInfoEvent({
    required this.stage,
  });
}

class UpdateMyQualityOrderEvent extends GraphqlEvent {
  final List<Skills> myQualityList;

  const UpdateMyQualityOrderEvent({
    required this.myQualityList,
  });
}

class ReadLoggedInUserInfoEvent extends GraphqlEvent {
  const ReadLoggedInUserInfoEvent();
}

class ReadSkillsListEvent extends GraphqlEvent {
  const ReadSkillsListEvent();
}


class ReadInterestsListEvent extends GraphqlEvent {
  const ReadInterestsListEvent();
}

class ReadQuestionnaireListEvent extends GraphqlEvent {
  const ReadQuestionnaireListEvent();
}

class UpdateInvestOrBusinessPartnerEvent extends GraphqlEvent {
  final String userName;
  final String investmentTypeValue;

  const UpdateInvestOrBusinessPartnerEvent({
    required this.userName,
    required this.investmentTypeValue,
  });
}

class UpdatePrivacyScreenDataEvent extends GraphqlEvent {
  final bool isAllowMatchesMessage;
  final bool isAllowPeopleToSendManualRequest;
  final bool isPushNotificationOn;

  const UpdatePrivacyScreenDataEvent({
    required this.isAllowMatchesMessage,
    required this.isPushNotificationOn,
    required this.isAllowPeopleToSendManualRequest,
  });
}

class UpdateBiographyEvent extends GraphqlEvent {
  final String biography;

  const UpdateBiographyEvent({
    required this.biography,
  });
}

class SearchSkillsListEvent extends GraphqlEvent {
  final String query;
  final List<Skills> skills;

  const SearchSkillsListEvent({required this.skills, required this.query});
}

class UpdateBusinessStageEvent extends GraphqlEvent {
  final String moreInfo;
  final String ideaStage;

  const UpdateBusinessStageEvent({
    required this.ideaStage,
    required this.moreInfo,
  });
}

class UpdateLevelOfPassionEvent extends GraphqlEvent {
  final int passion;

  const UpdateLevelOfPassionEvent({
    required this.passion,
  });
}

class UpdateHoursPerWeekEvent extends GraphqlEvent {
  final int hours;

  const UpdateHoursPerWeekEvent({
    required this.hours,
  });
}

class UpdateMotivationListEvent extends GraphqlEvent {
  final Motivation motivation;

  const UpdateMotivationListEvent({
    required this.motivation,
  });
}

class UpdateProfileVisibilityListEvent extends GraphqlEvent {
  final ProfileVisibility profileVisibility;

  const UpdateProfileVisibilityListEvent({
    required this.profileVisibility,
  });
}

class UpdateSkillsLookingForListEvent extends GraphqlEvent {
  final List<Skills> skills;

  const UpdateSkillsLookingForListEvent({
    required this.skills,
  });
}

class UpdateInterestListEvent extends GraphqlEvent {
  final List<Skills> interests;

  const UpdateInterestListEvent({
    required this.interests,
  });
}

class UpdatePersonalSkillsListEvent extends GraphqlEvent {
  final List<Skills> skills;

  const UpdatePersonalSkillsListEvent({
    required this.skills,
  });
}

class ReadMatchCountEvent extends GraphqlEvent {
  const ReadMatchCountEvent();
}
class UpdateNotificationReadStatusEvent extends GraphqlEvent {
  final String notificationId;

  const UpdateNotificationReadStatusEvent({
    required this.notificationId,
  });
}

class ReadUserDetailsEvent extends GraphqlEvent {
  final String userId;
  final String cognitoID;
  final String searchId;

  const ReadUserDetailsEvent({
    required this.userId,
    required this.searchId,
    required this.cognitoID,
  });
}

class GetBlockedUserEvent extends GraphqlEvent {
  final String userId;

  const GetBlockedUserEvent({
    required this.userId,
  });
}

class FetchMatchUserListEvent extends GraphqlEvent {
  final String userId;
  final int skip;

  const FetchMatchUserListEvent({required this.userId, required this.skip});
}

class UnblockUserEvent extends GraphqlEvent {
  final String userId;
  final String interestedId;

  const UnblockUserEvent({required this.userId, required this.interestedId});
}

class BlockUserEvent extends GraphqlEvent {
  final String userId;
  final String interestedId;

  const BlockUserEvent({required this.userId, required this.interestedId});
}

class MatchUserEvent extends GraphqlEvent {
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

class MatchUserSearchEvent extends GraphqlEvent {
  final String userId;
  final String interestedId;
  final String name;

  const MatchUserSearchEvent(
      {required this.userId, required this.interestedId, required this.name});
}

class AddPlayerIdEvent extends GraphqlEvent {
  final String userId;
  final String playerId;

  const AddPlayerIdEvent({required this.userId, required this.playerId});
}

class DeletePlayerIdEvent extends GraphqlEvent {
  final String userId;
  final String playerId;

  const DeletePlayerIdEvent({required this.userId, required this.playerId});
}

class UpdateAccountInfoEvent extends GraphqlEvent {
  final String firstname;
  final String lastname;
  final String city;
  final String email;
  final String dob;

  const UpdateAccountInfoEvent({
    required this.firstname,
    required this.lastname,
    required this.city,
    required this.email,
    required this.dob,
  });
}

class ReadUserEvent extends GraphqlEvent {}
