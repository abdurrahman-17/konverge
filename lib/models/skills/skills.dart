class Skills{
  String skill;
  String? id;
  Skills({required this.skill,String? id}) : id = id;
  factory Skills.fromJson(Map<String, dynamic> json) {
    return Skills(
      id: json['_id'] as String,
      skill: json['skill'] as String,
    );
  }
  factory Skills.fromJsonForInterests(Map<String, dynamic> json) {
    return Skills(
      id: json['_id'] as String,
      skill: json['interest'] as String,
    );
  }
  factory Skills.fromJsonForBusinessIdea(Map<String, dynamic> json) {
    return Skills(
      id: (json['business_idea_id'] as int).toString(),
      skill: json['business_idea'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'skill': skill,
    };
  }
}
