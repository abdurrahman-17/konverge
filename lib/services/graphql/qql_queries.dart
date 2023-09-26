import 'dart:developer';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../repository/user_repository.dart';

class QueriesConst {
//   String createUserQuery() {
//     return """
//   mutation createUserQuery(
//   \$firstname:String!
//   \$lastname:String!
//   \$email:String!
//   \$city:String!
//   \$phonenumber:String!
//   ){
//   insertOneUser(data: {
//       first_name: \$firstname,
//       last_name: \$lastname,
//       email: \$email,
//       city: \$city,
//       phonenumber: \$phonenumber,
//   }) {
//     _id
//   }
// }
// """;
//   }

  String updateNotificationStatusQuery(String userId) {
    return """
  mutation updateOneUser(
  \$status:Boolean! 
  ){
  updateOneUser(
  query:
  { _id:"$userId"},
  set:{is_notification: \$status}) {
    _id,is_notification
  }
}
""";
  }

  String updateBusinessIdeaQuery(String userId) {
    return """
  mutation updateOneUser(
  \$business_idea:Int! 
  \$business_idea_info:String! 
  ){
  updateOneUser(
  query:{ _id:"$userId"},
  set:{
        business_idea:{link: \$business_idea}
        business_idea_info: \$business_idea_info}) {
    _id
  }
}
""";
  }

  String updateMotivationQuery(String userId) {
    return """
  mutation updateOneUser(
  \$money:Int! 
  \$passion:Int! 
  \$freedom:Int! 
  \$better_lifestyle:Int! 
  \$fame_and_power:Int! 
  \$changing_the_world:Int! 
  \$helping_others:Int! 
  ){
  updateOneUser(
  query:{ _id:"$userId"},
  set:{motivation : 
        {
        money: \$money,
        passion: \$passion,
        freedom: \$freedom,
        better_lifestyle: \$better_lifestyle,
        fame_and_power: \$fame_and_power,
        changing_the_world: \$changing_the_world,
        helping_others: \$helping_others
        }
      }) {
    _id
  }
}
""";
  }

  String updateProfileVisibilityQuery(String userId) {
    return """
  mutation updateOneUser_setting(
  \$biography:Boolean! 
  \$skills:Boolean! 
  \$qualities:Boolean! 
  \$looking_for_skills:Boolean! 
  \$business_idea:Boolean! 
  \$motivation:Boolean! 
  \$level_of_passion:Boolean! 
  \$hours_per_week:Boolean! 
  \$interests:Boolean! 
  ){
  updateOneUser_setting(
  query:{user_id:{_id: "$userId"}}, set :{
        visibility: {
        interests: \$interests,
        looking_for_skills: \$looking_for_skills
        buisness_idea: \$business_idea
        level_of_passion: \$level_of_passion
        hours_per_week: \$hours_per_week
        biography: \$biography
        skills: \$skills
        qualities: \$qualities
        motivation: \$motivation
      }
  }){
    visibility {
      biography
    }
  }
}

""";
  }

  String updateLevelOfPassionQuery(String userId) {
    return """
  mutation updateOneUser(
  \$passionLevel:Int!  
  ){
  updateOneUser(
  query:{ _id:"$userId"},
  set:{level_of_passion: \$passionLevel, }) {
    _id
  }
}
""";
  }

  String updateHoursPerWeekQuery(String userId) {
    return """
  mutation updateOneUser(
  \$hours:Int!  
  ){
  updateOneUser(
  query:{ _id:"$userId"},
  set:{hours_per_week: \$hours, }) {
    _id
  }
}
""";
  }

  String updatePreQuestionnaireStatusQuery(String userId) {
    return """
      mutation updateOneUser(
      \$idea:Int! 
      \$isNotification:Boolean! 
      \$businessInfo:String! 
      \$lookingForType:String! 
      \$lookingForSkills:[UserLooking_for_skillUpdateInput] 
      \$personalSkills:[UserPersonal_skillUpdateInput] 
      \$stage:Int
      ){
        updateOneUser(query:{_id:"$userId"},set : {
        business_idea:{link: \$idea}
        business_idea_info: \$businessInfo
        my_journey: \$lookingForType
        personal_skills: \$personalSkills
        looking_for_skills:\$lookingForSkills
        stage: \$stage
      }){
      _id
      }
       updateOneUser_setting(query:{user_id:{_id: "$userId"}}, 
       set : {
	      enable_notification: \$isNotification,
        }){
        enable_notification
      }
      
     }
""";
  }

  String updateUserStageStatusQuery(String userId) {
    return """
  mutation updateOneUser(
  \$stage:Int 
  ){
  updateOneUser(
  query:{ _id:"$userId"},
  set:{
  stage:\$stage}) {
    _id,
  }
}
""";
  }

  String updateOrderOfMyQualityListQuery(String userId) {
    return """
  mutation updateOneUser(
  \$listQuality:[String!] 
  ){
  updateOneUser(
  query:
  { _id:"$userId"},
  set:{
  qualities:\$listQuality,  }) {
    _id,
  }
}
""";
  }

  String updateSkillsLookingForListQuery(String userId) {
    return """
  mutation updateOneUser(
  \$lookingForSkills:[UserLooking_for_skillUpdateInput]  
  
  ){
  updateOneUser(
  query:
  { _id:"$userId"},
  set:{ 
  looking_for_skills:\$lookingForSkills,}) {
    _id,
  }
}
""";
  }

  String updatePersonalSkillsListQuery(String userId) {
    return """
  mutation updateOneUser(
  \$personal_skills:[UserPersonal_skillUpdateInput]  
  
  ){
  updateOneUser(
  query:
  { _id:"$userId"},
  set:{ 
  personal_skills:\$personal_skills,}) {
    _id,
  }
}
""";
  }

  String updatePersonalInterestsListQuery(String userId) {
    return """
  mutation updateOneUser(
  \$personal_interests:[UserInterestUpdateInput]  
  
  ){
  updateOneUser(
  query:
  { _id:"$userId"},
  set:{ 
  interests:\$personal_interests,}) {
    _id,
  }
}
""";
  }

  String updateLastLoginTimeQuery(String userId, String loginTime) {
    return """
mutation{
  update_last_login_date(
  input:
  { user_id: "$userId", 
    last_login_date:"$loginTime"
  })
}
""";
  }

  String triggerEmailVerificationProcessQuery(String userId) {
    return """
mutation{
  send_otp_email(input:{
    user_id: "$userId"
  }) {
    message
    status
  }
}
""";
  }

  String verifyEmailOtpQuery(String userId, String otp) {
    return """

mutation{
  otp_verification(input:{
   user_id: "$userId"
    otp: $otp
  }) {
    message
    status
  }
}

""";
  }

  String updateAccountInformationQuery(String userId) {
    return """
  mutation updateOneUser(
  \$firstname:String! 
  \$lastname:String! 
  \$city:String!
  \$email:String! 
  \$dob:DateTime! 
   
  
  ){
  updateOneUser(
  query:
  { _id:"$userId"},
  set:{ 
  first_name:\$firstname,
  last_name:\$lastname,
  email:\$email,
  city:\$city, 
  dob:\$dob, 
  
  }) {
    _id,
  }
}
""";
  }

  String updateProfilePictureQuery(String userId) {
    return """
  mutation updateOneUser(
  \$profile_pic:String! 
  ){
  updateOneUser(
  query:
  { _id:"$userId"},
  set:{ 
  profile_pic:\$profile_pic, 
  }) {
    _id,
  }
}
""";
  }

  String updateLookingForInvestOrBusinessPartner(String userId) {
    return """
  mutation updateOneUser(
  \$my_journey:String!  
  ){
  updateOneUser(
  query:{ _id:"$userId"},
  set:{ my_journey: \$my_journey}) {
    _id
  }
}
""";
  }

  String updatePrivacyScreenData(String userId) {
    return """
  mutation updateOneUser_setting(
  \$allow_matches_message:Boolean!  
  \$is_notification:Boolean!  
  \$allow_mannualy_match_requests:Boolean!  
  ){
  updateOneUser_setting(query:{user_id:{_id: "$userId"}}, 
       set : {
	      enable_notification: \$is_notification,
	      allow_matches_message: \$allow_matches_message,
	      allow_mannualy_match_requests: \$allow_mannualy_match_requests,
        }){
        enable_notification,allow_matches_message,allow_mannualy_match_requests
      }
}
""";
  }

  String updateBiography(String userId) {
    return """
  mutation updateOneUser(
  \$biography:String!
  ){
  updateOneUser(
  query:{ _id:"$userId"},
  set:{ biography: \$biography,}) {
    _id,biography
  }
}
""";
  }

  // String readUserQuery(String userName) {
  //   /*  is_notification,,
  //       visibility{
  //       biography,
  //       skills,
  //       qualities,
  //       looking_for_skills,
  //       business_idea,
  //       motivation,
  //       level_of_passion,
  //       hours_per_week,
  //       last_login,
  //       username,
  //
  //       allow_matches_message,
  //       allow_mannualy_match_requests,
  //       last_chat_date,
  //       }*/
  //   return """
  //   query {
  //     user(query: { phonenumber: "$userName" }) {
  //       _id,
  //       first_name,
  //       last_name,
  //       country,
  //       city,
  //       dob,
  //       email,
  //       login_type,
  //       looking_for_skills{
  //     _id
  //     skill
  //   },
  //       match_code,
  //       my_code,
  //       personal_skills{
  //     _id
  //     skill
  //   },
  //       phonenumber,
  //       profile_pic,
  //       stage,
  //       user_verified,
  //       business_idea_info,
  //       my_journey,
  //       biography,
  //       qualities,
  //       level_of_passion,
  //       hours_per_week,
  //       interests {
  //         _id
  //         interest
  //       },
  //       motivation{
  //         money,
  //         passion,
  //         freedom,
  //         better_lifestyle,
  //         fame_and_power,
  //         changing_the_world,
  //         helping_others
  //       },
  //     }
  //     user_settings(query: { user_id: { phonenumber: "$userName" } }) {
  //     allow_mannualy_match_requests
  //     allow_matches_message
  //     enable_notification
  //     visibility {
  //     biography
  //     buisness_idea
  //     hours_per_week
  //     interests
  //     level_of_passion
  //     looking_for_skills
  //     motivation
  //     qualities
  //     skills
  //   }
  // }
  //   }
  // """;
  // }

  String readSkillsQuery() {
    return """
    query {
      business_idea_collection: business_ideas {
        business_idea_id
        business_idea
      }
      skills_list: skills(limit:700) {
        _id
        skill
      }
      interest_list: interests(limit:700) {
        _id
        interest
      }
    }
  """;
  }

  String readQuestionnaire() {
    return """
    query{
      questionnaire_configs(sortBy:_ID_ASC) {
        _id
        question
        category
        agree {
          code
          name
        }
        disagree {
          code
          name
        }
      }
    }
  """;
  }

  String updateQuestionnaire() {
    return """ mutation(\$user_id:String!, \$questionnaires:[User_questionnaireQuestionnaireInsertInput!]!) {
                        insertOneUser_questionnaire(data:
                        {
                        user_id: \$user_id,
                        questionnaires:\$questionnaires
                    }
                        ) {
                        _id
                        user_id
                        questionnaires{
                            question_id
                            percentage
                            code
                        }
                        }
                    }
  """;
  }

  String getBlockedUserQuery(String userId) {
    print("userID $userId");
    return """
        query{
      get_blocked_users(input : {
        user_id: "$userId"
      })
    }
  """;
  }

  String unblockUserQuery(String userId, String unblockedId) {
    return """
        mutation{
      unblock_user(input:{blocker_id:"$userId", profile_id:"$unblockedId"})
    }
  """;
  }

  String blockUserQuery(String userId, String blockedId) {
    return """
    mutation{
  block_user_request(input:{blocker_id:"$userId", profile_id:"$blockedId" })
    }

  """;
  }

  String getMatchUsersQuery(String userId, int skip, {int limit = 30}) {
    return """
          {
            users_interested_algorithmic(input:{current_user_id: "$userId",
              skip: $skip,
              limit: $limit,
              is_algorithmic: false})
            {
             results{
               _id
            biography
            business_idea
            business_idea_info
            category_wise_avg {
              E
              F
              I
              J
              N
              P
              S
              T
              category
            }
            city
            country
            created_at
            dob
            email
            first_name
            full_name
            hours_per_week
            interests {
              _id
              interest
            }
            last_name
            level_of_passion
            login_type
            looking_for_skills {
              _id
              skill
            }
            match_code
            motivation {
              better_lifestyle
              changing_the_world
              fame_and_power
              freedom
              helping_others
              money
              passion
            }
            my_code
            my_code_color
            my_journey
            personal_skills {
              _id
              skill
            }
            phonenumber
            profile_pic
            qualities
            stage
            updated_at
            user_verified
              my_code_color
             interested_on_me
          cognito_id
            }
              is_algorithmic
              skip
              limit
            }
          }
  """;
  }

  String searchUserByFullNameQuery(String fullNameSkills, String userId) {
    return """
      query {
        manual_search_fullname_skills(input:{data:"$fullNameSkills", limit:200, skip:0,
        current_user_id:"$userId"}) {
         count
          skip
          limit
          data{
             _id
             cognito_id
          biography
          business_idea
          business_idea_info
          category_wise_avg {
            E
            F
            I
            J
            N
            P
            S
            T
            category
          }
          city
          country
          created_at
          dob
          email
          first_name
          full_name
          hours_per_week
          interests {
            _id
            interest
          }
          last_name
          level_of_passion
          login_type
          looking_for_skills {
            _id
            skill
          }
          match_code
          motivation {
            better_lifestyle
            changing_the_world
            fame_and_power
            freedom
            helping_others
            money
            passion
          }
          my_code
          my_code_color
          my_journey
          personal_skills {
            _id
            skill
          }
          phonenumber
          profile_pic
          qualities
          stage
          updated_at
          user_verified
        my_code_color
          }
        }
    }
  """;
  }

  String autocompleteSearchQuery(String query) {
    return """
      query{
        autocomplete_names_skills(input:{search_term:"$query", limit:100}) {
            full_name
        skills
          }
    }
  """;
  }

  String readUserFromCognitoIdQuery(String cognitoId) {
    return """
    query
      {
        user(query: { cognito_id: "$cognitoId"}){
          first_name
          _id
          last_name
          full_name
          cognito_id
          email
          dob
          city
          phonenumber
          user_verified
          stage
          login_type
          my_journey
          personal_skills {
            _id
            skill
          }
          looking_for_skills {
            _id
            skill
          }
          business_idea{
            business_idea
            business_idea_id
          }
          business_idea_info
          biography
          qualities
          my_code
          match_code
          profile_pic
          interests {
            _id
            interest
          }
          motivation {
            better_lifestyle
            changing_the_world
            fame_and_power
            freedom
            helping_others
            money
            passion
          }
          level_of_passion
          hours_per_week
        }
        user_setting(query: {user_id: {cognito_id: "$cognitoId"}}){
          enable_notification
          allow_matches_message
          allow_mannualy_match_requests
          email_verified
          visibility {
            biography
            buisness_idea
            hours_per_week
            interests
            level_of_passion
            looking_for_skills
            motivation
            qualities
            skills
          }
          
        }
      }

  """;
  }

  String readUserDetailFromCognitoIdQuery(
      String cognitoId, String userId, String searchProfileId) {
    return """
        query{
      user(query: { cognito_id: "$cognitoId"}){
        first_name
        last_name
        full_name
        _id
        email
        dob
        city
        phonenumber
        user_verified
        stage
        login_type
        my_journey
        personal_skills {
          _id
          skill
        }
        looking_for_skills {
          _id
          skill
        }
        business_idea{
          business_idea
          business_idea_id
        }
        business_idea_info
        biography
        qualities
        my_code
        match_code
        profile_pic
        interests {
          _id
          interest
        }
        motivation {
          better_lifestyle
          changing_the_world
          fame_and_power
          freedom
          helping_others
          money
          passion
        } 
        level_of_passion
        hours_per_week
      }
      
      user_setting(query: {user_id: {cognito_id: "$cognitoId"}}){
        enable_notification
        allow_matches_message
        allow_mannualy_match_requests
        email_verified
        visibility {
          biography
          buisness_idea
          hours_per_week
          interests
          level_of_passion
          looking_for_skills
          motivation
          qualities
          skills
        }
       
      
      }
      get_user_profile_status(input:{search_profile_id:"$searchProfileId", user_id:"$userId"}){
        block_status
        match_status
        
      }
    }

  """;
  }

  String addPlayerIdQuery({required String userId, required String playerId}) {
    return """
 mutation{
  add_player_id(input:{user_id: "$userId", player_id: "$playerId"})
}
""";
  }

  String deletePlayerIdQuery(
      {required String userId, required String playerId}) {
    return """
  mutation{
  delete_player_id(input:{user_id:"$userId", player_id:"$playerId"})
}
""";
  }

  String matchUserQuery({
    required String userId,
    required String interestedId,
    required String matchType,
    required String cognitoId,
  }) {
    final activeUser = Locator.instance.get<UserRepo>().getCurrentUserData();
    String profilePic = Constants.storageUrl + activeUser!.profilePicUrlPath!;
    String name = activeUser.firstname!;
    String fullName = activeUser.fullname!;
    String colorCode = activeUser.my_code!;

    log("profile Pic: $profilePic\n name:$name\n fullName: $fullName\n color code: $colorCode\n user id: $userId\n interested Id: $interestedId");
    log("mutation{match_request(input: {interested_user_id:$interestedId, user_id:$userId, full_name: $fullName, match_type: $matchType, color_code:$colorCode, profile_pic: $profilePic,cognito_id: $cognitoId}){data}}");
    return """
            mutation{
        match_request(input: {
      interested_user_id:"$interestedId", 
      user_id:"$userId", 
      full_name: "$fullName", 
      match_type: "$matchType", 
      color_code:"$colorCode", 
      profile_pic: "$profilePic",
      cognito_id: "$cognitoId"})
          { 
            data
          }
        }
""";
  }

  String unMatchUserQuery(
      {required String userId,
      required String interestedId,
      required String matchType}) {
    return """
         mutation{
          reject_request(input: {user_id:"$userId", 
        interested_user_id:"$interestedId", 
        match_type: "$matchType"})
       
      }
""";
  }

  String matchUserFromSearchQuery(
      {required String userId,
      required String interestedId,
      required String name}) {
    return """
     mutation{
  match_request(input: {user_id: "$userId", interested_user_id:"$interestedId", name: "$name"})
    
  }
""";
  }

  String updateProfilePicQuery(
      {required String userId, required String profilePic}) {
    return """
     mutation{
  update_profile_pic(input:{user_id:"$userId", profile_pic:"$profilePic"})
}
""";
  }

  String insertRecentViewQuery(
      {required String userId, required String viewedId}) {
    return """
     mutation{
      insertOneRecent_viewed(data: {
        viewed_by: "$userId",
        viewed_to: "$viewedId" 
        created_at: ""
        updated_at: ""
      })
    }
""";
  }

  String notificationListQuery({
    required String userId,
    required String matchType,
    required String createdAt,
  }) {
    return """
    query{
  notification_lists(sortBy: CREATED_AT_DESC, query : { receiver_id: "$userId", match_type: "$matchType"
  } ) {
    _id
    color_code
    created_at
    full_name
    is_Read
    match_type
    message
    my_code
    profile_pic
    receiver_id
    request_type
    sender_id,
    updated_at,
    cognito_id
  }
}
""";
  }

  /*String matchCountMatchCountQuery({required String userId}) {
    return """
    {
      interested_algorithmic_count(input:{current_user_id:"$userId"}){
      count
      }
    }
""";
  }*/
  String matchCountMatchCountQuery({required String userId}) {
    return """
    query{
  unread_notification_count(input:{user_id: "$userId"}){
    count
  }
}
""";
  }

  String notificationReadStatusUpdateQuery({required String notificationId}) {
    return """
    mutation{
      updateOneNotification_list(query:{_id:"$notificationId"},set:{
      is_Read: true
    }){
    _id
    }
}
""";
  }
}
