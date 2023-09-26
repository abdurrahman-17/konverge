import '../skills/skills.dart';

class PreQuestionnaireInfoModel {
  bool? isAllowNotification;
  String? lookingForInvestOrPartner;
  String? businessStage;
  String? businessStageMoreInfo;
  List<Skills>? skillsLookingFor;
  List<Skills>? myPersonalSkills;

  PreQuestionnaireInfoModel({
    this.isAllowNotification,
    this.lookingForInvestOrPartner,
    this.businessStage,
    this.businessStageMoreInfo,
    this.skillsLookingFor,
    this.myPersonalSkills,
  });
}
