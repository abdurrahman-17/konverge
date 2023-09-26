import '../../models/skills/skills.dart';

class Interests {
  String? sTypename;
  String? sId;
  String? interest;

  Interests({this.sTypename, this.sId, this.interest});

  Interests.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'] as String?;
    sId = json['_id'] as String?;
    interest = json['interest'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = sTypename;
    data['_id'] = sId;
    data['interest'] = interest;
    return data;
  }

  /*to handle changes of db schema changes*/
  static List<Skills> convertInterestsAsSkills(List<Interests>? interests) {
    List<Skills> interestsListInSkillFormat = [];
    if (interests != null) {
      for (Interests item in interests) {
        interestsListInSkillFormat
            .add(Skills(skill: item.interest ?? "", id: item.sId));
      }
    }
    return interestsListInSkillFormat;
  }
}
