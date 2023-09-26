// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../models/search/auto_complete_response.dart';
import '../../core/app_export.dart';
import '../../models/blocked_user_model.dart';
import '../../models/graphql/interest_model.dart';
import '../../models/graphql/read_questionnaire_response.dart';
import '../../models/graphql/read_skills_response.dart';
import '../../models/graphql/user_info.dart';
import '../../models/graphql/user_setting.dart';
import '../../models/notification/notification_model.dart';
import '../../models/questionnaire/questionnaire.dart';
import '../../models/repo/match_model.dart';
import '../../models/skills/skills.dart';
import '../../core/locator.dart';
import '../../models/graphql/pre_questionnaire_info_request.dart';
import '../../models/graphql/user.dart';
import '../../models/repo/error_model.dart';
import '../../models/repo/success_base_model.dart';
import '../../utilities/enums.dart';
import '../../utilities/title_string.dart';
import '../amplify/amplify_service.dart';
import '../graphql/qql_queries.dart';
import '../shared_preference_service.dart';
import '../comet_chat.dart';
import 'gql_manager.dart';
import 'mutations.dart';

class GraphqlService {
  static GraphQLClient? client;

  //the below graphql base url is the one with new db changes. old url='https://eu-west-1.aws.realm.mongodb.com/api/client/v2.0/app/application-0-dsszp/graphql'
  // String graphQlBaseUrl = dotenv.env['GRAPHQL_BASE_URL']!;

  /*initial configuration of graphql client.
  * [idToken] represents the authentication token (jwt token) from -
  * amplify/aws cognito for authenticate user access.
  * */
  Future<Either<ErrorModel, UserInfoModel>> readUserModel(
      String cognitoId) async {
    try {
      final data = await GqlManager().executeQuery(
        query: QueriesConst().readUserFromCognitoIdQuery(cognitoId),
        pollInterval: const Duration(seconds: 10),
        fetchPolicy: FetchPolicy.noCache,
      );
      return data.fold((l) => Left(l), (result) {
        if (result.hasException) {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_session_expired,
            ),
          );
        } else {
          if (result.data != null && (result.data!)['user'] != null) {
            var userInfo = (result.data!)['user'] as Map<String, dynamic>;
            var userSetting =
                (result.data!)['user_setting'] as Map<String, dynamic>;

            var user = UserInfoModel.fromJson(userInfo);
            if (userSetting.isNotEmpty) {
              var singleItem = userSetting;
              var userSettings = UserSettings.fromJson(singleItem);
              user.is_notification = userSettings.enableNotification;
              user.allow_matches_message = userSettings.allowMatchesMessage;
              user.allow_mannualy_match_requests =
                  userSettings.allowManualMatchRequests;
              user.profileVisibility = userSettings.visibility;
              user.isEmailVerified = userSettings.isEmailVerified;
            }
            Locator.instance
                .get<SharedPrefServices>()
                .setUserId(user.userId ?? "");

            if (user.userId != null) {
              cometChatLogin(user.userId!);
              //checking whether the login is already updated
              if (!Locator.instance
                  .get<SharedPrefServices>()
                  .isUpdatedLoginToDb()) {
                Locator.instance
                    .get<SharedPrefServices>()
                    .updateLoginToDb(true);
              }
            }
            // log("Reading user: ${user.toJson()}");
            // activeUser = user;
            return Right(user);
          } else if (result.data != null && (result.data!)['user'] == null) {
            //api success but there is no data in backend in case of social login
            return Right(UserInfoModel());
          }
        }
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_session_expired,
          ),
        );
      });
    } catch (e) {
      log("readUserModelException: $e");
    }
    return Left(
      ErrorModel(
        type: ErrorType.normalWarning,
        message: TitleString.error_session_expired,
      ),
    );
  }

  Future<Either<ErrorModel, UserInfoModel?>> readUserDetails(
    String userName, {
    required String userId,
    required String searchId,
  }) async {
    String cognitoId = userName;
    if (userName.isEmpty) {
      cognitoId = await AmplifyService().getCognitoId();
    }

    final data = await GqlManager().executeQuery(
      query: QueriesConst()
          .readUserDetailFromCognitoIdQuery(cognitoId, userId, searchId),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold((l) => Left(l), (result) {
      UserInfoModel? user;
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_session_expired,
          ),
        );
      } else {
        if (result.data != null) {
          if (result.data!['user'] == null) {
            return Right(user);
          }
          var userInfo = (result.data!)['user'] as Map<String, dynamic>;

          try {
            var userSetting =
                (result.data!)['user_setting'] as Map<String, dynamic>;

            user = UserInfoModel.fromJson(userInfo);
            var userSettings = UserSettings.fromJson(userSetting);
            user.allow_mannualy_match_requests =
                userSettings.allowManualMatchRequests;
            user.allow_matches_message = userSettings.allowMatchesMessage;
            user.is_notification = userSettings.enableNotification;
            user.isEmailVerified = userSettings.isEmailVerified;
            user.profileVisibility = userSettings.visibility;

            if ((result.data!)['get_user_profile_status'] != null) {
              var status = (result.data!)['get_user_profile_status']
                  as Map<String, dynamic>;
              StatusData statusData = StatusData.fromJson(status);
              user.statusData = statusData;
            }
          } catch (e) {
            log("Error while readUserDetails : $e");
          }
        }
        return Right(user);
      }
    });
  }

  Future<Either<ErrorModel, List<BlockedUserModel>>> getBlockedUsers({
    required String userId,
  }) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().getBlockedUserQuery(userId),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_session_expired,
          ),
        );
      } else {
        List<BlockedUserModel> users = [];
        if (result.data != null) {
          try {
            final userData = result.data!["get_blocked_users"];

            final data = jsonDecode(userData.toString());

            final List<dynamic> userInfoList = data as List<dynamic>;

            for (dynamic userInfo in userInfoList) {
              users.add(
                  BlockedUserModel.fromJson(userInfo as Map<String, dynamic>));
            }
          } catch (e) {
            log("Error while getBlockedUsers information: $e");
          }
        }
        return Right(users);
      }
    });
  }

  Future<Either<ErrorModel, List<UserInfoModel>>> getMatchedUsers({
    required String userId,
    required int skip,
  }) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().getMatchUsersQuery(userId, skip,
          limit: Constants.matchItemInEachPage),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_update_profile,
          ),
        );
      } else {
        List<UserInfoModel> users = [];
        if (result.data != null) {
          try {
            var userInfoList =
                (result.data!)['users_interested_algorithmic']['results'];
            users = [];
            if (userInfoList != null) {
              for (dynamic userInfo in userInfoList as List<dynamic>) {
                users.add(
                    UserInfoModel.fromJson(userInfo as Map<String, dynamic>));
              }
            }
          } catch (e) {
            log("Error while getMatchedUsers information: $e");
          }
        }
        return Right(users);
      }
    });
  }

  Future<Either<ErrorModel, ReadSkillsListResponse>> readSkills() async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().readSkillsQuery(),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold(
      (l) => Left(l),
      (result) {
        if (result.hasException) {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_session_expired,
            ),
          );
        } else {
          if (result.data != null) {
            var skillInfoList = (result.data!)['skills_list'];
            var interestInfoList = (result.data!)['interest_list'];
            var businessIdeaInfoList =
                (result.data!)['business_idea_collection'];

            try {
              List<Skills> businessIdeaList = [];
              List<dynamic> businessIdeaListCasted =
                  businessIdeaInfoList as List<dynamic>;
              for (var item in businessIdeaListCasted) {
                Skills businessIdea = Skills.fromJsonForBusinessIdea(
                    item as Map<String, dynamic>);
                businessIdeaList.add(businessIdea);
              }
              List<Skills> skillsList = [];
              List<dynamic> skillInfoListCasted =
                  skillInfoList as List<dynamic>;
              for (var skillInfo in skillInfoListCasted) {
                Skills skill =
                    Skills.fromJson(skillInfo as Map<String, dynamic>);
                skillsList.add(skill);
              }
              List<Skills> interestList = [];
              List<dynamic> interestListCasted =
                  interestInfoList as List<dynamic>;
              for (var item in interestListCasted) {
                Skills interest =
                    Skills.fromJsonForInterests(item as Map<String, dynamic>);
                interestList.add(interest);
              }
              return Right(
                ReadSkillsListResponse(
                  skills: skillsList,
                  interests: interestList,
                  businessIdea: businessIdeaList,
                ),
              );
            } catch (e) {
              log(e.toString());
            }
          }
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_no_skills_interest_business_idea,
            ),
          );
        }
      },
    );
  }

  Future<Either<ErrorModel, ReadQuestionnaireListResponse>>
      readQuestionnaire() async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().readQuestionnaire(),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );
    return data.fold(
      (l) => Left(l),
      (result) {
        List<Questionnaire> questionnairesListResult = [];
        if (result.hasException) {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_read_questionnaire,
            ),
          );
        } else {
          if (result.data != null) {
            var list1 = (result.data!)['questionnaire_configs'];

            if (list1 != null && list1 is List) {
              for (var item in list1) {
                if (item is Map<String, dynamic>) {
                  questionnairesListResult.add(Questionnaire.fromJson(item));
                }
              }
            }
          }
          return Right(
            ReadQuestionnaireListResponse(
              questionnaires: questionnairesListResult,
            ),
          );
        }
      },
    );
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateNotificationStatus(
    String userName,
    bool isNotificationOn,
  ) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().updateNotificationStatusQuery(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'status': isNotificationOn,
      },
    );

    return data.fold(
      (l) => Left(l),
      (result) {
        if (result.hasException) {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_update_notification,
            ),
          );
        } else {
          return Right(
            SuccessBaseModel(
              message: TitleString.success_query_reading,
            ),
          );
        }
      },
    );
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateBusinessIdea(
      String idea, String info) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().updateBusinessIdeaQuery(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'business_idea': int.parse(idea),
        'business_idea_info': info,
      },
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_update_business_idea,
          ),
        );
      } else {
        return Right(
          SuccessBaseModel(
            message: TitleString.success_query_reading,
          ),
        );
      }
    });
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateMotivationScreenData(
      Motivation motivation) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().updateMotivationQuery(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'money': motivation.money,
        'passion': motivation.passion,
        'freedom': motivation.freedom,
        'better_lifestyle': motivation.better_lifestyle,
        'fame_and_power': motivation.fame_and_power,
        'changing_the_world': motivation.changing_the_world,
        'helping_others': motivation.helping_others,
      },
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_update_motivation,
          ),
        );
      } else {
        return Right(
          SuccessBaseModel(
            message: TitleString.success_query_reading,
          ),
        );
      }
    });
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateProfileVisibilityList(
      ProfileVisibility profileVisibility) async {
    try {
      final data = await GqlManager().executeQuery(
        query: QueriesConst().updateProfileVisibilityQuery(getUserId()),
        pollInterval: const Duration(seconds: 10),
        fetchPolicy: FetchPolicy.noCache,
        variables: {
          'biography': profileVisibility.biography,
          'skills': profileVisibility.skills,
          'qualities': profileVisibility.qualities,
          'looking_for_skills': profileVisibility.looking_for_skills,
          'business_idea': profileVisibility.business_idea,
          'motivation': profileVisibility.motivation,
          'level_of_passion': profileVisibility.level_of_passion,
          'hours_per_week': profileVisibility.hours_per_week,
          'interests': profileVisibility.interests,
        },
      );

      return data.fold((l) => Left(l), (result) {
        if (result.hasException) {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_update_profile_visibility,
            ),
          );
        } else {
          return Right(
            SuccessBaseModel(
              message: TitleString.success_query_reading,
            ),
          );
        }
      });
    } catch (e) {
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: TitleString.error_update_profile_visibility,
        ),
      );
    }
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateSkillsLookingForList(
      List<Skills> skillsList) async {
    List<String> skillsListString = [];

    for (Skills itemSkills in skillsList) {
      skillsListString.add(itemSkills.skill);
    }

    final data = await GqlManager().executeQuery(
      query: QueriesConst().updateSkillsLookingForListQuery(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'lookingForSkills': skillsList,
      },
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        print(result.exception);
        return Left(
          ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_update_skills_looking_for),
        );
      } else {
        return Right(
          SuccessBaseModel(
            message: TitleString.success_query_reading,
          ),
        );
      }
    });
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updatePersonalSkillsList(
      List<Skills> skillsList) async {
    List<String> skillsListString = [];

    for (Skills itemSkills in skillsList) {
      skillsListString.add(itemSkills.skill);
    }

    final data = await GqlManager().executeQuery(
      query: QueriesConst().updatePersonalSkillsListQuery(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'personal_skills': skillsList,
      },
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        print(result.exception);
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_update_skills_looking_for,
          ),
        );
      } else {
        return Right(
          SuccessBaseModel(
            message: TitleString.success_query_reading,
          ),
        );
      }
    });
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updatePersonalInterestsList(
      List<Skills> interestsList) async {
    List<InterestsModelForUpdate> interestsListString = [];

    for (Skills item in interestsList) {
      interestsListString.add(InterestsModelForUpdate(item.skill, item.id!));
    }

    final data = await GqlManager().executeQuery(
      query: QueriesConst().updatePersonalInterestsListQuery(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'personal_interests': interestsListString,
      },
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        print(result.exception);
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_update_skills_looking_for,
          ),
        );
      } else {
        return Right(SuccessBaseModel(
          message: TitleString.success_query_reading,
        ));
      }
    });
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateLoginTimeToDb({
    String userId = "",
  }) async {
    try {
      String dateTime = "${DateTime.now().toUtc().toIso8601String()}";
      if (userId.isEmpty) {
        userId = getUserId();
      }
      final data = await GqlManager().executeQuery(
        query: QueriesConst().updateLastLoginTimeQuery(userId, dateTime),
        pollInterval: const Duration(seconds: 10),
        fetchPolicy: FetchPolicy.noCache,
      );

      return data.fold((l) => left(l), (result) {
        if (result.hasException) {
          print(result.exception);
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_update_login_time,
            ),
          );
        } else {
          return Right(
            SuccessBaseModel(
              message: TitleString.success_query_reading,
            ),
          );
        }
      });
    } catch (e) {
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: TitleString.error_update_login_time,
        ),
      );
    }
  }

  Future<Either<ErrorModel, SuccessBaseModel>>
      triggerEmailVerificationProcess() async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().triggerEmailVerificationProcessQuery(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold(
      (l) => Left(l),
      (result) {
        if (result.hasException) {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_email_verification_trigger,
            ),
          );
        } else {
          var data = result.data;
          bool status = data?["send_otp_email"]["status"];
          String message = data?["send_otp_email"]["message"];
          if (status) {
            return Right(
              SuccessBaseModel(
                message: message,
              ),
            );
          } else {
            return Left(
              ErrorModel(
                type: ErrorType.normalWarning,
                message: message,
              ),
            );
          }
        }
      },
    );
  }

  Future<Either<ErrorModel, SuccessBaseModel>>
      verifyEmailOtpVerificationProcess(String otp) async {
    try {
      final data = await GqlManager().executeQuery(
        query: QueriesConst().verifyEmailOtpQuery(getUserId(), otp),
        pollInterval: const Duration(seconds: 10),
        fetchPolicy: FetchPolicy.noCache,
      );

      return data.fold((l) => left(l), (result) {
        if (result.hasException) {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_email_verification,
            ),
          );
        } else {
          var data = result.data;
          bool status = data?["otp_verification"]["status"];
          String message = data?["otp_verification"]["message"];
          if (status) {
            return Right(
              SuccessBaseModel(
                message: message,
              ),
            );
          } else {
            return Left(
              ErrorModel(
                type: ErrorType.normalWarning,
                message: message,
              ),
            );
          }
        }
      });
    } catch (e) {
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: TitleString.error_email_something_wrong,
        ),
      );
    }
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateAccountInformation(
    String firstname,
    String lastname,
    String city,
    String email,
    String dob,
  ) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().updateAccountInformationQuery(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'firstname': firstname,
        'lastname': lastname,
        'city': city,
        'email': email,
        'dob': "${convertToDateTime(dob).toIso8601String()}+00:00",
      },
    );

    return data.fold(
      (l) => left(l),
      (result) {
        if (result.hasException) {
          print(result.exception);
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_update_skills_looking_for,
            ),
          );
        } else {
          return Right(
            SuccessBaseModel(
              message: TitleString.success_query_reading,
            ),
          );
        }
      },
    );
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateProfilePictureUrl(
    String profilePicUrl,
  ) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().updateProfilePictureQuery(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'profile_pic': profilePicUrl,
      },
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_update_skills_looking_for,
          ),
        );
      } else {
        return Right(
          SuccessBaseModel(
            message: TitleString.success_query_reading,
          ),
        );
      }
    });
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateLevelOfPassion(
      int passionLevel) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().updateLevelOfPassionQuery(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'passionLevel': passionLevel,
      },
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        print(result.exception);

        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_update_level_passion,
          ),
        );
      } else {
        return Right(
          SuccessBaseModel(
            message: TitleString.success_query_reading,
          ),
        );
      }
    });
  }

  Future<Either<ErrorModel, SuccessBaseModel>> updateHoursPerWeek(
      int hours) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().updateHoursPerWeekQuery(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'hours': hours,
      },
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        print(result.exception);

        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_update_hours_per_week,
          ),
        );
      } else {
        return Right(SuccessBaseModel(
          message: TitleString.success_query_reading,
        ));
      }
    });
  }

  Future<Either<ErrorModel, SuccessBaseModel>>
      updateLookingForInvestOrBusinessPartner(
          String userName, String myJourney) async {
    final data = await GqlManager().executeQuery(
      query:
          QueriesConst().updateLookingForInvestOrBusinessPartner(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'my_journey': myJourney,
      },
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_update_business_idea,
          ),
        );
      } else {
        return Right(
          SuccessBaseModel(
            message: TitleString.success_query_reading,
          ),
        );
      }
    });
  }

  /*To update get push notification status and only allow matches to message from privacy screen */
  Future<Either<ErrorModel, SuccessBaseModel>> updatePrivacyScreenData(
    bool allowMatchesMessage,
    bool allowPushNotification,
    bool isAllowPeopleToSendManualRequest,
  ) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().updatePrivacyScreenData(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'allow_matches_message': allowMatchesMessage,
        'is_notification': allowPushNotification,
        'allow_mannualy_match_requests': isAllowPeopleToSendManualRequest,
      },
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_update_allow_matches_message,
          ),
        );
      } else {
        return Right(SuccessBaseModel(
          message: TitleString.success_query_reading,
        ));
      }
    });
  }

  /*To update biography of a user.*/
  Future<Either<ErrorModel, SuccessBaseModel>> updateBiography(
      String biography) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().updateBiography(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'biography': biography,
      },
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        print(result.exception);
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_update_biography,
          ),
        );
      } else {
        return Right(
          SuccessBaseModel(
            message: TitleString.success_query_reading,
          ),
        );
      }
    });
  }

  /*get match count*/
  Future<Either<ErrorModel, int>> getMatchCount() async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().matchCountMatchCountQuery(userId: getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold(
      (l) => Left(l),
      (result) {
        if (result.hasException) {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_read_match_count,
            ),
          );
        } else {
          if (result.data != null) {
            var count = (result.data)?['unread_notification_count']["count"];
            return Right(
              int.parse(count),
            );
          }
          return Right(0);
        }
      },
    );
  }

/*  update notification read status*/
  Future<Either<ErrorModel, int>> updateNotificationReadStatus(
      String notificationId) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst()
          .notificationReadStatusUpdateQuery(notificationId: notificationId),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold(
      (l) => Left(l),
      (result) {
        if (result.hasException) {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_read_match_count,
            ),
          );
        } else {
          if (result.data?['unread_notification_count'] == null) {
            return Right(0);
          }
          if (result.data != null) {
            var count = (result.data)?['unread_notification_count']["count"];
            return Right(
              int.parse(count),
            );
          }
          return Right(0);
        }
      },
    );
  }

  /*To update all the information (stay up to date - business stage screen)
   together to mongodb.
   *   @params [requestModel] contains all the collected
   information from (stay up to date - business stage screen
   */
  Future<Either<ErrorModel, SuccessBaseModel>> updatePreQuestionnaireInfo(
      PreQuestionnaireInfoModel requestModel) async {
    try {
      final data = await GqlManager().executeQuery(
        query: QueriesConst().updatePreQuestionnaireStatusQuery(getUserId()),
        pollInterval: const Duration(seconds: 10),
        fetchPolicy: FetchPolicy.noCache,
        variables: {
          'isNotification': requestModel.isAllowNotification,
          'idea': requestModel.businessStage,
          'businessInfo': requestModel.businessStageMoreInfo,
          'lookingForType': requestModel.lookingForInvestOrPartner,
          'lookingForSkills': requestModel.skillsLookingFor,
          'personalSkills': requestModel.myPersonalSkills,
          'stage': Constants.navigationStageBusinessStageCompleted,
        },
      );

      return data.fold((l) => Left(l), (result) {
        if (result.hasException) {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_update_pre_questionnaire,
            ),
          );
        } else {
          return Right(
            SuccessBaseModel(
              message: TitleString.success_query_reading,
            ),
          );
        }
      });
    } catch (e) {
      print("error: $e");
    }
    return Left(
      ErrorModel(
        type: ErrorType.normalWarning,
        message: TitleString.error_update_pre_questionnaire,
      ),
    );
  }

  /*To update the status about how far the user have completed the
     * sign up process.
     * @params [stage] contains value according to constant
     */
  Future<Either<ErrorModel, SuccessBaseModel>> updateUserStageStatus(
      int stage) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().updateUserStageStatusQuery(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'stage': stage,
      },
    );

    return data.fold(
      (l) => Left(l),
      (result) {
        if (result.hasException) {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_update_pre_questionnaire,
            ),
          );
        } else {
          return Right(
            SuccessBaseModel(
              message: TitleString.success_query_reading,
            ),
          );
        }
      },
    );
  }

  Future<Either<ErrorModel, SuccessBaseModel>> blockUser(
    String userId,
    String interestedId,
    bool accepted,
  ) async {
    final data = await GqlManager().executeQuery(
      query: accepted
          ? QueriesConst().blockUserQuery(userId, interestedId)
          : QueriesConst().unblockUserQuery(userId, interestedId),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_update_my_quality_list,
          ),
        );
      } else {
        return Right(
          SuccessBaseModel(
            message: TitleString.success_query_reading,
          ),
        );
      }
    });
  }

  Future<Either<ErrorModel, SuccessBaseModel>> unBlockUser(
    String userId,
    String interestedId,
    String time,
  ) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().unblockUserQuery(userId, interestedId),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );
    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_update_my_quality_list,
          ),
        );
      } else {
        return Right(
          SuccessBaseModel(
            message: TitleString.success_query_reading,
          ),
        );
      }
    });
  }

  /*To update the re arranged order of my qualities from  result screen or quality screen from edit profile.
     * @params [stage] contains value according to constant
     */
  Future<Either<ErrorModel, SuccessBaseModel>> updateMyQualityOrder(
      List<Skills> qualityList) async {
    List<String> qualityStringList = [];
    for (Skills item in qualityList) {
      qualityStringList.add(item.skill);
    }

    final data = await GqlManager().executeQuery(
      query: QueriesConst().updateOrderOfMyQualityListQuery(getUserId()),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'listQuality': qualityStringList,
      },
    );

    return data.fold((l) => left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_update_my_quality_list,
          ),
        );
      } else {
        return Right(
          SuccessBaseModel(
            message: TitleString.success_query_reading,
          ),
        );
      }
    });
  }

  /*auto complete query*/
  Future<Either<ErrorModel, AutoCompleteResponse?>> getAutoCompleteName(
      {required String query}) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().autocompleteSearchQuery(query),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_session_expired,
          ),
        );
      } else {
        if (result.data != null) {
          try {
            AutoCompleteResponse response = AutoCompleteResponse.fromJson(
                result.data as Map<String, dynamic>);
            return Right(response);
          } catch (e) {
            log("Error while getAutoCompleteName information: $e");
          }
        }
        return const Right(null);
      }
    });
  }

  /*search items query*/
  Future<Either<ErrorModel, List<UserInfoModel>>> searchUsers({
    required String fullNameSkills,
    required String userId,
  }) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().searchUserByFullNameQuery(fullNameSkills, userId),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );
    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_session_expired,
          ),
        );
      } else {
        List<UserInfoModel> users = [];
        if (result.data != null) {
          try {
            var userInfoList =
                (result.data)?['manual_search_fullname_skills']['data'];
            users = [];
            if (userInfoList != null) {
              for (dynamic userInfo in userInfoList as List<dynamic>) {
                users.add(
                  UserInfoModel.fromJson(
                    userInfo as Map<String, dynamic>,
                  ),
                );
              }
            }
            return Right(users);
          } catch (e) {
            log("Error while searchUsers: $e");
          }
        }
        return Right(users);
      }
    });
  }

  /*addPlayerId*/
  Future<Either<ErrorModel, SuccessBaseModel>> addPlayerId({
    required String userId,
    required String playerId,
  }) async {
    if (playerId.isEmpty) {
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: TitleString.error_no_player_id,
        ),
      );
    }
    final data = await GqlManager().executeQuery(
      query: QueriesConst().addPlayerIdQuery(
        userId: userId,
        playerId: playerId,
      ),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );
    return data.fold(
      (l) => Left(l),
      (result) {
        if (result.hasException) {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_add_player_id,
            ),
          );
        } else {
          return Right(
            SuccessBaseModel(
              message: TitleString.success_query_reading,
            ),
          );
        }
      },
    );
  }

  /*deletePlayerId*/
  Future<Either<ErrorModel, SuccessBaseModel>> deletePlayerId({
    required String userId,
    required String playerId,
  }) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst()
          .deletePlayerIdQuery(userId: userId, playerId: playerId),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_add_player_id,
          ),
        );
      } else {
        return Right(
          SuccessBaseModel(
            message: TitleString.success_query_reading,
          ),
        );
      }
    });
  }

  /*match user Query*/
  Future<Either<ErrorModel, MatchModel>> matchUser({
    required String userId,
    required String interestedId,
    required String matchType,
  }) async {
    String cognitoId = await AmplifyService().getCognitoId();
    final data = await GqlManager().executeQuery(
      query: QueriesConst().matchUserQuery(
        userId: userId,
        interestedId: interestedId,
        matchType: matchType,
        cognitoId: cognitoId,
      ),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold((l) => left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_add_player_id,
          ),
        );
      } else {
        bool itsMatch = false;
        String message = "";
        final data = result.data;
        if (data != null) {
          if (data.containsKey("match_request")) {
            try {
              final matchRequest = (data["match_request"]);

              message = matchRequest["data"] ?? "Match Request Sent";
              if (message.contains("It's a Match!") ||
                  message.contains("Its a match")) {
                itsMatch = true;
              }
              if (message.contains("already raised")) {
                message = "Match request already sent";
              }
            } catch (e) {
              message = "Match Request Sent";
              if (data["match_request"]
                  .toString()
                  .contains("Match request already sent!")) {
                message = "Match request already sent";
              }
            }
          }
        }

        return Right(
          MatchModel(
            isMatch: true,
            itsMatch: itsMatch,
            message: message,
          ),
        );
      }
    });
  }

  /*un match user Query*/
  Future<Either<ErrorModel, MatchModel>> unMatchUser({
    required String userId,
    required String interestedId,
    required String matchType,
  }) async {
    String message = "";
    final data = await GqlManager().executeQuery(
      query: QueriesConst().unMatchUserQuery(
        userId: userId,
        interestedId: interestedId,
        matchType: matchType,
      ),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_add_player_id,
          ),
        );
      } else {
        final data = result.data;
        if (data != null) {
          if (data.containsKey("match_request")) {
            try {
              final matchRequest = jsonDecode(data["match_request"]);
              message = matchRequest["data"] ?? "";
            } catch (e) {
              message = e.toString();
              print("error $e");
            }
          }
        }
        return Right(
            MatchModel(itsMatch: false, isMatch: false, message: message));
      }
    });
  }

  /*match user from search Query*/
  Future<Either<ErrorModel, SuccessBaseModel>> matchUserFromSearchQuery(
      {required String userId,
      required String interestedId,
      required String name}) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst().matchUserFromSearchQuery(
          userId: userId, interestedId: interestedId, name: name),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_add_player_id,
          ),
        );
      } else {
        return Right(
          SuccessBaseModel(
            message: TitleString.success_query_reading,
          ),
        );
      }
    });
  }

  Future<Either<ErrorModel, SuccessBaseModel>> uploadProfilePic({
    required String userId,
    required String profilePic,
  }) async {
    final data = await GqlManager().executeQuery(
      query: QueriesConst()
          .updateProfilePicQuery(userId: userId, profilePic: profilePic),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_add_player_id,
          ),
        );
      } else {
        return Right(
          SuccessBaseModel(
            message: TitleString.success_query_reading,
          ),
        );
      }
    });
  }

  /*get logged in userId.*/
  String getUserId() {
    String userId = Locator.instance.get<SharedPrefServices>().getUserId();
    return userId;
  }

  ///create User
  Future<Either<ErrorModel, User>> saveUserData(
      Map<String, dynamic> userJson) async {
    try {
      var accessTokenFromClient = await GqlManager().getAccessToken2();
      final query = GQLMutations().createUser(
          firstName: userJson['firstName'],
          lastName: userJson['lastName'],
          email: userJson['email'],
          dob: "${convertToDateTime(userJson['dob']).toIso8601String()}+00:00",
          phoneNumber: userJson['phoneNumber'],
          city: userJson['city'],
          loginType: userJson['loginType'],
          cognitoId: userJson['cognitoId'],
          accessToken: accessTokenFromClient);

      final data = await GqlManager().executeQuery(
        query: query,
        pollInterval: const Duration(seconds: 10),
        fetchPolicy: FetchPolicy.noCache,
      );
      return data.fold((l) => Left(l), (result) {
        if (!result.hasException) {
          if (result.data != null) {
            final temp = jsonDecode(result.data?['save_social_login_users']);
            if (temp['code'] != null && temp['code'] == "403") {
              return Left(
                ErrorModel(
                  type: ErrorType.normalWarning,
                  message: temp['data'],
                ),
              );
            } else {
              return Right(User());
            }
          }
          return Left(ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_add_user_data,
          ));
        } else {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_add_user_data,
            ),
          );
        }
      });
    } catch (e) {
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: TitleString.error_add_user_data,
        ),
      );
    }
  }

  Future<Either<ErrorModel, List<NotificationModel>>> fetchNotificationList({
    required String userId,
    required String matchType,
  }) async {
    final dateTime = "${DateTime.now().toIso8601String()}Z";

    final data = await GqlManager().executeQuery(
      query: QueriesConst().notificationListQuery(
        userId: userId,
        matchType: matchType,
        createdAt: dateTime,
      ),
      pollInterval: const Duration(seconds: 10),
      fetchPolicy: FetchPolicy.noCache,
    );

    return data.fold((l) => Left(l), (result) {
      if (result.hasException) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.error_add_player_id,
          ),
        );
      } else {
        List<NotificationModel> notifications = [];
        final data = result.data;
        if (data != null) {
          try {
            final List<dynamic> notificationList =
                data["notification_lists"] as List<dynamic>;
            for (dynamic notificationItem in notificationList) {
              final notification = notificationItem as Map<String, dynamic>;

              notifications.add(NotificationModel.fromJson(notification));
            }
          } catch (e) {
            log('error: $e');
          }
        }

        return Right(notifications);
      }
    });
  }

  Future<Either<ErrorModel, bool>> deleteUserAccount(String userId) async {
    try {
      final query = GQLMutations().deleteUser(userId: userId);
      final data = await GqlManager().executeQuery(
        query: query,
        pollInterval: const Duration(seconds: 10),
        fetchPolicy: FetchPolicy.noCache,
      );
      return data.fold((l) => Left(l), (result) {
        if (!result.hasException) {
          if (result.data != null) {
            final temp = result.data?['delete_user'];
            if (temp['data'] != null && temp['data'] == "User Deleted") {
              return Right(true);
            } else {
              Left(
                ErrorModel(
                  type: ErrorType.normalWarning,
                  message: TitleString.error_delete_user_account,
                ),
              );
            }
          }
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_delete_user_account,
            ),
          );
        } else {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: TitleString.error_delete_user_account,
            ),
          );
        }
      });
    } catch (e) {
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: TitleString.error_delete_user_account,
        ),
      );
    }
  }
}
