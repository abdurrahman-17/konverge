class Questionnaire {
  String? id;
  String question;
  String? category;
  AnswerCodeInfo? agree;
  AnswerCodeInfo? disagree;
  int percentage;
  String code;

  Questionnaire({
    this.id,
    required this.question,
    this.category,
    this.agree,
    this.disagree,
    this.percentage = -1,
    this.code = "",
  });

  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    return Questionnaire(
      id: json['_id'] as String?,
      question: json['question'] as String,
      category: json['category'] as String?,
      agree: json['agree'] != null
          ? AnswerCodeInfo.fromJson(json['agree'] as Map<String, dynamic>)
          : null,
      disagree: json['disagree'] != null
          ? AnswerCodeInfo.fromJson(json['disagree'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AnswerCodeInfo {
  String code;
  String name;

  AnswerCodeInfo({
    required this.code,
    required this.name,
  });

  factory AnswerCodeInfo.fromJson(Map<String, dynamic> json) {
    return AnswerCodeInfo(
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }
}

enum AnswerType {
  agree,
  neutral,
  disAgree,
}
