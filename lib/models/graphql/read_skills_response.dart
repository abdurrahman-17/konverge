import '../skills/skills.dart';

class ReadSkillsListResponse {
  List<Skills> skills = [];
  List<Skills> interests = [];
  List<Skills> businessIdea = [];
  ReadSkillsListResponse({
    required this.skills,
    required this.interests,
    required this.businessIdea,
  });
}
