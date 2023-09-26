// ignore_for_file: non_constant_identifier_names

import '../skills/skills.dart';
import 'interests.dart';

class UserInfoModel {
  String? userId;
  String? firstname;
  String? lastname = "";
  String? fullname = "";
  String? country;
  String? city;
  String? dob;
  String? email = "";
  String? profilePicUrlPath = "";
  bool is_notification = false;
  String? login_type;
  List<Skills>? looking_for_skills;
  List<String>? match_code;
  String? my_code;
  List<Skills>? personal_skills;
  List<Interests>? personal_interests;
  String? phonenumber;
  int? stage;
  bool user_verified = false;
  String? username;
  String? business_idea;
  String business_idea_info;
  String? my_journey;
  String? last_login;
  String biography;
  List<String>? qualities;
  int? level_of_passion;
  int? hours_per_week;
  bool allow_matches_message = false;
  bool allow_mannualy_match_requests = false;
  String? last_chat_date;
  String? image = "";
  Motivation? motivation;
  ProfileVisibility? profileVisibility;
  String profileImageUrl = "";
  bool interested_on_me = false;
  String? cognitoId;
  bool deleted;
  bool isEmailVerified=false;
  StatusData? statusData;

  UserInfoModel({
    this.userId,
    this.firstname,
    this.lastname,
    this.country,
    this.city,
    this.dob,
    this.email,
    this.profilePicUrlPath,
    this.is_notification = false,
    this.login_type,
    this.looking_for_skills,
    this.match_code,
    this.my_code,
    this.personal_skills,
    this.personal_interests,
    this.phonenumber,
    this.stage,
    this.user_verified = false,
    this.username,
    this.business_idea,
    this.business_idea_info = '',
    this.my_journey,
    this.last_login,
    this.biography = '',
    this.qualities,
    this.level_of_passion,
    this.hours_per_week,
    this.allow_matches_message = false,
    this.allow_mannualy_match_requests = false,
    this.last_chat_date,
    this.motivation,
    this.profileVisibility,
    this.profileImageUrl = '',
    this.interested_on_me = false,
    this.cognitoId,
    this.fullname,
    this.deleted = false,
    this.statusData,
    this.isEmailVerified=false,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      userId: json['_id'] as String?,
      firstname: json['first_name'] as String?,
      lastname: json['last_name'] as String? ?? "",
      country: json['country'] as String?,
      city: json['city'] as String?,
      dob: json['dob'] as String?,
      email: json['email'] as String? ?? "",
      profilePicUrlPath: json['profile_pic'] as String? ?? "",
      is_notification: json['is_notification'] as bool? ?? false,
      login_type: json['login_type'] as String?,
      looking_for_skills: (json['looking_for_skills'] as List<dynamic>?)
          ?.map((skill) => Skills.fromJson(skill as Map<String, dynamic>))
          .toList(),
      match_code: (json['match_code'] as List<dynamic>?)
          ?.map((skill) => skill as String)
          .toList(),
      my_code: json['my_code'] as String?,
      personal_skills: (json['personal_skills'] as List<dynamic>?)
          ?.map((skill) => Skills.fromJson(skill as Map<String, dynamic>))
          .toList(),
      // (json['interests'] as List<dynamic>?)
      //     ?.map((skill) => skill as String)
      //     .toList(),

      personal_interests: (json['interests'] as List<dynamic>?)
          ?.map((interests) =>
              Interests.fromJson(interests as Map<String, dynamic>))
          .toList(),
      phonenumber: json['phonenumber'] as String?,
      stage: json['stage'] as int?,
      user_verified: json['user_verified'] as bool? ?? false,
      username: json['username'] as String?,
      business_idea: (json['business_idea'] is int)
          ? json['business_idea'].toString()
          : BusinessIdea.fromJson(json['business_idea']).business_idea_id,
      //(json['business_idea'] as Map<String, dynamic>)["business_idea_id"].toString(),
      business_idea_info: json['business_idea_info'] as String? ?? '',
      my_journey: json['my_journey'] as String?,
      last_login: json['last_login'] as String?,
      biography: json['biography'] as String? ?? '',
      qualities: (json['qualities'] as List<dynamic>?)
          ?.map((quality) => quality as String)
          .toList(),
      level_of_passion: json['level_of_passion'] as int?,
      hours_per_week: json['hours_per_week'] as int?,
      allow_matches_message: json['allow_matches_message'] as bool? ?? false,
      allow_mannualy_match_requests:
          json['allow_mannualy_match_requests'] as bool? ?? false,
      last_chat_date: json['last_chat_date'] as String?,
      motivation: json['motivation'] != null
          ? Motivation.fromJson(json['motivation'] as Map<String, dynamic>)
          : null,
      profileVisibility: json['visibility'] != null
          ? ProfileVisibility.fromJson(
              json['visibility'] as Map<String, dynamic>)
          : null,
      profileImageUrl: "",
      interested_on_me: json['interested_on_me'] != null
          ? json['interested_on_me'] as bool
          : false,
      cognitoId: json['cognito_id'].toString(),
      fullname: json["full_name"].toString(),
      deleted: json['deleted'] as bool? ?? false,
      statusData: json['get_user_profile_status'] != null
          ? StatusData.fromJson(json['get_user_profile_status'])
          : null,

      isEmailVerified: json['email_verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'first_name': firstname,
      'last_name': lastname,
      'country': country,
      'city': city,
      'full_name': fullname ?? "",
      'dob': dob,
      'email': email,
      'profile_pic': profilePicUrlPath,
      'is_notification': is_notification,
      'login_type': login_type,
      'looking_for_skills': looking_for_skills,
      'match_code': match_code,
      'my_code': my_code,
      'personal_skills': personal_skills,
      'interests': personal_interests,
      'phonenumber': phonenumber,
      'stage': stage,
      'user_verified': user_verified,
      'username': username,
      'business_idea': business_idea,
      'business_idea_info': business_idea_info,
      'my_journey': my_journey,
      'last_login': last_login,
      'biography': biography,
      'qualities': qualities,
      'level_of_passion': level_of_passion,
      'hours_per_week': hours_per_week,
      'allow_matches_message': allow_matches_message,
      'allow_mannualy_match_requests': allow_mannualy_match_requests,
      'last_chat_date': last_chat_date,
      'motivation': motivation?.toJson(),
      'visibility': profileVisibility?.toJson(),
      'cognito_id': cognitoId,
      'deleted': deleted,
      'email_verified': isEmailVerified,
    };
  }
}

class Motivation {
  int money;
  int passion;
  int freedom;
  int better_lifestyle;
  int fame_and_power;
  int changing_the_world;
  int helping_others;

  Motivation({
    required this.money,
    required this.passion,
    required this.freedom,
    required this.better_lifestyle,
    required this.helping_others,
    required this.changing_the_world,
    required this.fame_and_power,
  });

  factory Motivation.fromJson(Map<String, dynamic> json) {
    return Motivation(
      money: json['money'] as int,
      passion: json['passion'] as int,
      freedom: json['freedom'] as int,
      better_lifestyle: json['better_lifestyle'] as int,
      fame_and_power: json['fame_and_power'] as int,
      changing_the_world: json['changing_the_world'] as int,
      helping_others: json['helping_others'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'money': money,
      'passion': passion,
      'freedom': freedom,
      'better_lifestyle': better_lifestyle,
      'fame_and_power': fame_and_power,
      'changing_the_world': changing_the_world,
      'helping_others': helping_others,
    };
  }
}

class ProfileVisibility {
  bool biography;
  bool skills;
  bool qualities;
  bool looking_for_skills;
  bool business_idea;
  bool motivation;
  bool level_of_passion;
  bool interests;
  bool hours_per_week;

  ProfileVisibility({
    required this.biography,
    required this.skills,
    required this.qualities,
    required this.looking_for_skills,
    required this.business_idea,
    required this.motivation,
    required this.level_of_passion,
    required this.interests,
    required this.hours_per_week,
  });

  factory ProfileVisibility.fromJson(Map<String, dynamic> json) {
    return ProfileVisibility(
      biography: json['biography'] as bool? ?? true,
      skills: json['skills'] as bool? ?? true,
      qualities: json['qualities'] as bool? ?? true,
      looking_for_skills: json['looking_for_skills'] as bool? ?? true,
      business_idea: json['business_idea'] as bool? ?? true,
      motivation: json['motivation'] as bool? ?? true,
      level_of_passion: json['level_of_passion'] as bool? ?? true,
      interests: json['interests'] as bool? ?? true,
      hours_per_week: json['hours_per_week'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'biography': biography,
      'skills': skills,
      'qualities': qualities,
      'looking_for_skills': looking_for_skills,
      'business_idea': business_idea,
      'motivation': motivation,
      'level_of_passion': level_of_passion,
      'interests': interests,
      'hours_per_week': hours_per_week,
    };
  }
}

class BusinessIdea {
  String business_idea_id;
  String business_idea;

  BusinessIdea({
    required this.business_idea_id,
    required this.business_idea,
  });

  factory BusinessIdea.fromJson(Map<String, dynamic>? json) {
    if (json != null)
      return BusinessIdea(
        business_idea: json['business_idea'] as String,
        business_idea_id: (json['business_idea_id'] as int).toString(),
      );
    else
      return BusinessIdea(
        business_idea: "1",
        business_idea_id: "1",
      );
  }
}

class StatusData {
  bool? blockStatus;
  String? matchStatus;

  StatusData({this.blockStatus, this.matchStatus});

  StatusData.fromJson(Map<String, dynamic> json) {
    blockStatus = json['block_status'];
    matchStatus = json['match_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['block_status'] = this.blockStatus;
    data['match_status'] = this.matchStatus;
    return data;
  }
}
