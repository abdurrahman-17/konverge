import '../../core/app_export.dart';
import '../graphql/user_info.dart';
import '../../utilities/title_string.dart';

import '../skills/skills.dart';

class User {
  String name;
  String place;
  String age;
  bool isCurrentUser;
  List<Skills> skills;
  Biography? biography;
  String? image;
  String? profileImage;
  String? profileImageUrl;

  User({
    this.biography,
    this.isCurrentUser = false,
    required this.skills,
    required this.name,
    this.image,
    required this.age,
    required this.place,
    this.profileImage,
  });

  factory User.fromUserInfoModel(UserInfoModel userInfoModel) {
    String fullName =
        "${userInfoModel.firstname ?? ""} ${userInfoModel.lastname}";
    List<Skills> skills = userInfoModel.personal_skills ?? [];
    String age = calculateAge(userInfoModel.dob ?? "").toString();
    bool isCurrentUser = true;
    String city = userInfoModel.city ?? "";
    String businessIdea = "";
    String profileImage = userInfoModel.profilePicUrlPath ?? "";
    switch (userInfoModel.business_idea) {
      case Constants.ideaScreenOption1:
        businessIdea = TitleString.titleIdeaScreenOption1;
        break;
      case Constants.ideaScreenOption2:
        businessIdea = TitleString.titleIdeaScreenOption2;
        break;
      case Constants.ideaScreenOption3:
        businessIdea = TitleString.titleIdeaScreenOption3;
        break;
      case Constants.ideaScreenOption4:
        businessIdea = TitleString.titleIdeaScreenOption4;
        break;
      default:
        {
          businessIdea = "";
        }
    }
    var biography = Biography(
      biography: userInfoModel.biography,
      title: TitleString.businessIdeaTitle,
      subTitle: businessIdea,
      description: userInfoModel.business_idea_info,
    );
    User user = User(
      isCurrentUser: isCurrentUser,
      skills: skills,
      name: fullName,
      age: age,
      place: city,
      profileImage: profileImage,
      biography: biography,
    );
    return (user);
  }
}

class Biography {
  String biography;
  String title;
  String subTitle;
  String description;

  Biography({
    required this.title,
    required this.subTitle,
    required this.description,
    this.biography = '',
  });
}

Biography getBiography(UserInfoModel userInfoModel) {
  String businessIdea = "";
  String mainTitle = "Business Idea";

  switch (userInfoModel.business_idea) {
    case Constants.ideaScreenOption1:
      businessIdea = TitleString.titleIdeaScreenOption1;
      if (userInfoModel.biography.isNotEmpty) {
        mainTitle = "Biography";
      }
      break;
    case Constants.ideaScreenOption2:
      businessIdea = TitleString.titleIdeaScreenOption2;
      break;
    case Constants.ideaScreenOption3:
      businessIdea = TitleString.titleIdeaScreenOption3;
      break;
    case Constants.ideaScreenOption4:
      businessIdea = TitleString.titleIdeaScreenOption4;
      break;
    default:
      businessIdea = "";
      break;
  }

  return Biography(
    biography: userInfoModel.biography,
    title: mainTitle,
    subTitle: businessIdea,
    description: userInfoModel.business_idea_info,
  );
}
