import 'package:dartz/dartz.dart';
import '../models/notification/notification_model.dart';
import '../models/repo/match_model.dart';
import '../models/search/auto_complete_response.dart';
import '../core/locator.dart';
import '../models/blocked_user_model.dart';
import '../models/graphql/pre_questionnaire_info_request.dart';
import '../models/graphql/read_questionnaire_response.dart';
import '../models/graphql/read_skills_response.dart';
import '../models/graphql/user_info.dart';
import '../models/repo/error_model.dart';
import '../models/repo/success_base_model.dart';
import '../models/skills/skills.dart';
import '../services/graphql/qql_service.dart';
import '../services/shared_preference_service.dart';

class GraphqlRepo {
  // Future<Either<ErrorModel, CreateUserResultModel>> registerUser(
  //     User user) async {
  //   return await Locator.instance.get<GraphqlService>().registerUser(user);
  // }

  Future<Either<ErrorModel, SuccessBaseModel>> updateNotificationStatus(
    String userName,
    bool isNotificationOn,
  ) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updateNotificationStatus(userName, isNotificationOn);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateBusinessStage(
      String ideaStage, String moreInfo) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updateBusinessIdea(ideaStage, moreInfo);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateLevelOfPassion(
    int passionLevel,
  ) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updateLevelOfPassion(passionLevel);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateHoursPerWeek(
    int hours,
  ) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updateHoursPerWeek(hours);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateMotivationList(
    Motivation motivation,
  ) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updateMotivationScreenData(motivation);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateProfileVisibilityList(
      ProfileVisibility profileVisibility) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updateProfileVisibilityList(profileVisibility);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateSkillsLookingForList(
      List<Skills> skillsLookingFor) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updateSkillsLookingForList(skillsLookingFor);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updatePersonalSkillsList(
      List<Skills> skillsLookingFor) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updatePersonalSkillsList(skillsLookingFor);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updatePersonalInterestsList(
      List<Skills> skillsLookingFor) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updatePersonalInterestsList(skillsLookingFor);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateLoginTimeToDb(
      {String userId = ""}) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updateLoginTimeToDb(userId: userId);
  }

  Future<Either<ErrorModel, SuccessBaseModel>>
      triggerEmailVerificationProcess() async {
    return await Locator.instance
        .get<GraphqlService>()
        .triggerEmailVerificationProcess();
  }

  Future<Either<ErrorModel, SuccessBaseModel>>
      verifyEmailOtpVerificationProcess(String otp) async {
    return await Locator.instance
        .get<GraphqlService>()
        .verifyEmailOtpVerificationProcess(otp);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateAccountInformation(
      String firstname,
      String lastname,
      String city,
      String email,
      String dob) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updateAccountInformation(firstname, lastname, city, email, dob);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateProfilePictureUrl(
      String userId, String url) async {
    return await Locator.instance
        .get<GraphqlService>()
        .uploadProfilePic(userId: userId, profilePic: url);
  }

  Future<Either<ErrorModel, SuccessBaseModel>>
      updateLookingForInvestOrBusinessPartner(String value) async {
    var username = Locator.instance.get<SharedPrefServices>().getUserName();

    return await Locator.instance
        .get<GraphqlService>()
        .updateLookingForInvestOrBusinessPartner(username, value);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updatePrivacyScreenData(
      bool allowMatchesToMessage,
      bool allowPushNotification,
      bool isAllowPeopleToSendManualRequest) async {
    return await Locator.instance.get<GraphqlService>().updatePrivacyScreenData(
        allowMatchesToMessage,
        allowPushNotification,
        isAllowPeopleToSendManualRequest);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateBiography(
      String biography) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updateBiography(biography);
  }

  /*read logged in user model*/
  Future<Either<ErrorModel, UserInfoModel>> readUserInfo(
      String cognitoId) async {
    return await Locator.instance
        .get<GraphqlService>()
        .readUserModel(cognitoId);
  }

  /*read skills in user model*/
  Future<Either<ErrorModel, ReadSkillsListResponse>> readSkillsList() async {
    return await Locator.instance.get<GraphqlService>().readSkills();
  }

  /*read interests list in user model*/
  Future<Either<ErrorModel, ReadSkillsListResponse>> readInterests() async {
    return await Locator.instance.get<GraphqlService>().readSkills();
  }

  /*read questionnaire list*/
  Future<Either<ErrorModel, ReadQuestionnaireListResponse>>
      readQuestionnaire() async {
    return await Locator.instance.get<GraphqlService>().readQuestionnaire();
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updatePreQuestionnaireInfo(
      PreQuestionnaireInfoModel requestModel) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updatePreQuestionnaireInfo(requestModel);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateUserStageStatus(
      int stage) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updateUserStageStatus(stage);
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateMyQualityOrder(
      List<Skills> qulaityList) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updateMyQualityOrder(qulaityList);
  }

  /*getBlocked Users*/
  Future<Either<ErrorModel, List<BlockedUserModel>>> getBlockedUsers(
      {required String userId}) async {
    return await Locator.instance
        .get<GraphqlService>()
        .getBlockedUsers(userId: userId);
  }

  /*bockUser*/
  Future<Either<ErrorModel, SuccessBaseModel>> blockUser(
      {required String userId,
      required String interestId,
      required String time}) async {
    return await Locator.instance
        .get<GraphqlService>()
        .blockUser(userId, interestId, true);
  }

/*unblockUser*/
  Future<Either<ErrorModel, SuccessBaseModel>> unBlockUser(
      {required String userId,
      required String interestId,
      required String time}) async {
    return await Locator.instance
        .get<GraphqlService>()
        .unBlockUser(userId, interestId, "");
  }

  /*read details*/
  Future<Either<ErrorModel, UserInfoModel?>> readUserDetails(String username,
      {required String searchId, required String userId}) async {
    return await Locator.instance
        .get<GraphqlService>()
        .readUserDetails(username, searchId: searchId, userId: userId);
  }

  /*read matchData*/
  Future<Either<ErrorModel, List<UserInfoModel>>> fetchMatchUsers(
      String userId, int skip) async {
    return await Locator.instance
        .get<GraphqlService>()
        .getMatchedUsers(userId: userId, skip: skip);
  }

  /*auto complete text Name*/
  Future<Either<ErrorModel, AutoCompleteResponse?>> autoCompleteName(
      String query) async {
    return await Locator.instance
        .get<GraphqlService>()
        .getAutoCompleteName(query: query);
  }

  /*SEARCH text Name*/
  Future<Either<ErrorModel, List<UserInfoModel>>> searchUsers(
      String fullName, String userId) async {
    return await Locator.instance
        .get<GraphqlService>()
        .searchUsers(fullNameSkills: fullName, userId: userId);
  }

  /*add playerId*/
  Future<Either<ErrorModel, SuccessBaseModel>> addPlayerID(
      {required String userId, required String playerId}) async {
    return await Locator.instance
        .get<GraphqlService>()
        .addPlayerId(userId: userId, playerId: playerId);
  }

  /*delete playerId*/
  Future<Either<ErrorModel, SuccessBaseModel>> deletePlayerId(
      {required String userId, required String playerId}) async {
    return await Locator.instance
        .get<GraphqlService>()
        .deletePlayerId(userId: userId, playerId: playerId);
  }

  /*match user*/
  Future<Either<ErrorModel, MatchModel>> matchUser(
      {required String userId,
      required String interestedId,
      required String matchType,
      required bool isMatch}) async {
    return isMatch
        ? await Locator.instance.get<GraphqlService>().matchUser(
            userId: userId, interestedId: interestedId, matchType: matchType)
        : await Locator.instance.get<GraphqlService>().unMatchUser(
            userId: userId, interestedId: interestedId, matchType: matchType);
  }

  /*match user*/
  Future<Either<ErrorModel, MatchModel>> unMatchUser(
      {required String userId,
      required String interestedId,
      required String matchType}) async {
    return await Locator.instance.get<GraphqlService>().unMatchUser(
        userId: userId, interestedId: interestedId, matchType: matchType);
  }

  /*match user from search*/
  Future<Either<ErrorModel, SuccessBaseModel>> matchUserFromSearch(
      {required String userId,
      required String interestedId,
      required String name}) async {
    return await Locator.instance
        .get<GraphqlService>()
        .matchUserFromSearchQuery(
            userId: userId, interestedId: interestedId, name: name);
  }

  /*fetch notification*/
  Future<Either<ErrorModel, List<NotificationModel>>> fetchNotificationList(
      {required String userId, required String matchType}) async {
    return await Locator.instance
        .get<GraphqlService>()
        .fetchNotificationList(userId: userId, matchType: matchType);
  }

  /*getMatchCount*/
  Future<Either<ErrorModel, int>> getMatchCount() async {
    return await Locator.instance.get<GraphqlService>().getMatchCount();
  }

  /*update notification count*/
  Future<Either<ErrorModel, int>> updateNotificationReadStatus(
      String notificationId) async {
    return await Locator.instance
        .get<GraphqlService>()
        .updateNotificationReadStatus(notificationId);
  }
}
