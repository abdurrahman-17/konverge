import '../graphql/user_info.dart';

class UserSettings {
  bool allowManualMatchRequests;
  bool allowMatchesMessage;
  // bool deleted;
  bool enableNotification;
  bool isEmailVerified;
  ProfileVisibility visibility;

  UserSettings({
    required this.allowManualMatchRequests,
    required this.allowMatchesMessage,
    // required this.deleted,
    required this.enableNotification,
    required this.visibility,
    required this.isEmailVerified,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      allowManualMatchRequests:
          json['allow_mannualy_match_requests'] as bool? ?? false,
      allowMatchesMessage: json['allow_matches_message'] as bool? ?? false,
      // deleted: json['deleted'] as bool? ?? false,
      enableNotification: json['enable_notification'] as bool? ?? false,
      visibility: ProfileVisibility.fromJson(
          json['visibility'] as Map<String, dynamic>),
      isEmailVerified: json['email_verified'] as bool? ?? false,
    );
  }
}
