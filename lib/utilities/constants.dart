import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String appName = 'Konverge';
  static const int successStatusCode = 200;
  static const String emailValidationPattern =
      r"^[\w-]+('[\w-]+)*(\.[\w-]+)*('[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$";
  // r'''^[\w-]+(\.[\w-]+)*('[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$''';

  // Regular expressions for special characters and numbers and alphabet
  static const String passwordCharacterRegex = r'[a-zA-Z]';
  static const String passwordSpecialCharRegex =
      r'''[~`@$\[\]#!%*?&^(){}<>"\\|\/:;.,=+_'-]''';
  static const String passwordNumberRegex = r'\d';

  static const String passwordValidationPattern =
      r'''^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[~`@$\[\]#!%*?&^(){}<>"\\|\/:;.,=+_'-])[A-Za-z\d~`@$\[\]#!%*?&^(){}<>"\\|\/:;.,=+_'-]{8,}$''';
  static const String phoneNumberValidationPattern = r'^-?[0-9]+$';
  static const String phoneNumberValidationPattern2 = r'^(?!(?:\D*0)+\D*$)';
  static const String dateOfBirthFormat = r'^\d{2}/\d{2}/\d{4}$';
  static const String nameValidationRegex = r'^[a-zA-Z0-9\-\s]+$';

//shared pref keys
  static const String userName =
      'userName'; //in konverge project phone number is the username.
  static const String userId = 'userId';
  static const String premiumUser = 'premiumUser';
  static const String matchSwipeCount = 'isMatchSwipeCount';
  static const String isChatPage = 'isChatPage';
  static const String email = 'email';
  static const String phone = 'phoneNumber';
  static const String password = 'password';
  static const String isLocalAuth = 'isLocalAuth';
  static const String userModelJson = 'userModelJson';
  static const String loginType = "loginType";
  static const String updateLogin = "updateLogin";

// this id will helps once we have different flavours
  static const String uniqueFlavourId = 'konvergeApp';

//remote config keys
  static const String loginTypes = 'login_types';
  static const String mobileUpdateVersion = 'mobile_app_version';

//collection names
  static const String userProfile = 'userProfile';
  static const String userLocations = "userLocations";

//storage folder name
  static const profileImages = "profileImages";

  //validator constants
  static const int nameLength = 32;
  static const String isRequired = "is required";
  static const String lookingForTypeInvestor = "investor";
  static const String lookingForTypeBusiness = "business";

  static const String editProfileBiography = "Biography";
  static const String editProfilePicture = "Profile picture";
  static const String editProfileSkills = "Skills";
  static const String editProfileQualities = "Qualities";
  static const String editProfileSkillsLookingFor = "Skills you're looking for";
  static const String editProfileBusinessIdea = "Business idea";
  static const String editProfileMotivation = "Motivation";
  static const String editProfilePassion = "Level of passion";
  static const String editProfileHoursPerWeek = "Hours per week";
  static const String editProfileInterests = "Interests";

  static const String ideaScreenOption1 = "1";
  static const String ideaScreenOption2 = "2";
  static const String ideaScreenOption3 = "3";
  static const String ideaScreenOption4 = "4";

  static const int navigationStagePhoneVerificationCompleted =
      3; //first time login after sign up
  static const int navigationStageBusinessStageCompleted =
      4; //updated the signup process till business stage. show from almost there screen.
  static const int navigationStageQuestionnaireCompleted =
      5; //questionnaire updated successfully,show from results screen.
  static const int navigationStageResultScreenAccepted =
      6; //show investment competition screen.
  static const int navigationStageShowHome = 7; //show home screen

// //DATABASE
// static const String databaseName = "konverge.db";
// static const databaseVersion = 1;

// static const mediaTable = "media_links";
// static const mediaLink = "link";
// static const mediaIsDownloaded = "is_downloaded";
// static const mediaLocalFileName = "file_name";
// static const mediaType = "media_type";
// static const String videoFileThumb = "video_file_thumb";
// static const isAudioFeed = "is_audio_feed";
// static const String clientSecret = "client_secret";
// static const String error = "error";

  static String baseUrl = dotenv.env['API_BASE_URL']!;
  static String saveScoreUrl = "$baseUrl/v1/profile-engine/save-score/";
  static const int fileLimit = 5;

  static String s3BaseUrl = dotenv.env['S3_BASE_URL']!;
  static String storageUrl = "$s3BaseUrl/";
  static String devApiUrl = dotenv.env['DEV_API']!;
  static const String matchTypeAlgorithm = "algorithmic_match";
  static const String matchTypeManual = "manual_match";
  static const String awsUsernameTail = "_konverge";

  static String getProfileUrl(String path) {
    if (path.contains(storageUrl))
      return path;
    else if(path.contains("public/"))
      return storageUrl + path;
    else
      return storageUrl +"public/"+ path;
  }

  static String uploadPicUrl =
      "$baseUrl/v1/profile-engine/upload-profile-picture";
  // "$devApiUrl/v1/konverge/users/upload-profile-picture";//new url not working.

  static String checkEmailUrl =
      "$devApiUrl/v1/konverge/users/check-email-exists";
  static String checkPhoneNumberExistsUrl =
      "$devApiUrl/v1/konverge/users/check-phonenumber-exists";
  static int matchItemInEachPage =30;

}
