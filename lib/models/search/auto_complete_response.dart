// class AutoCompleteResponse {
//   Data? data;
//
//   AutoCompleteResponse({this.data});
//
//   AutoCompleteResponse.fromJson(Map<String, dynamic> json) {
//     data = json['data'] != null
//         ? Data.fromJson(json['data'] as Map<String, dynamic>)
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

class AutoCompleteResponse {
  AutocompleteNamesSkills? autocompleteNamesSkills;

  AutoCompleteResponse({this.autocompleteNamesSkills});

  AutoCompleteResponse.fromJson(Map<String, dynamic> json) {
    autocompleteNamesSkills = json['autocomplete_names_skills'] != null
        ? AutocompleteNamesSkills.fromJson(
            json['autocomplete_names_skills'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (autocompleteNamesSkills != null) {
      data['autocomplete_names_skills'] = autocompleteNamesSkills!.toJson();
    }
    return data;
  }
}

class AutocompleteNamesSkills {
  List<String>? fullName;
  List<String>? skills;

  AutocompleteNamesSkills({this.fullName, this.skills});

  AutocompleteNamesSkills.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'] ?? [];
    skills = json['skills'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['skills'] = skills;
    return data;
  }
}
