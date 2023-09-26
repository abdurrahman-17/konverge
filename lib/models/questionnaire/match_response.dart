class MatchResponse {
  MatchData? data;

  MatchResponse({this.data});

  MatchResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? MatchData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MatchData {
  UpdateOneUser? updateOneUser;

  MatchData({this.updateOneUser});

  MatchData.fromJson(Map<String, dynamic> json) {
    updateOneUser = json['updateOneUser'] != null
        ? UpdateOneUser.fromJson(json['updateOneUser'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (updateOneUser != null) {
      data['updateOneUser'] = updateOneUser!.toJson();
    }
    return data;
  }
}

class UpdateOneUser {
  String? sId;
  String? email;
  String? firstname;
  String? lastname;
  List<String>? matchCode;
  String? myCode;
  List<String>? qualities;

  UpdateOneUser({
    this.sId,
    this.email,
    this.firstname,
    this.lastname,
    this.matchCode,
    this.myCode,
    this.qualities,
  });

  UpdateOneUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'].toString();
    email = json['email'].toString();
    firstname = json['firstname'].toString();
    lastname = json['lastname'].toString();
    matchCode = json['match_code'].cast<String>() as List<String>;
    myCode = json['my_code'].toString();
    qualities = json['qualities'].cast<String>() as List<String>;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['email'] = email;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['match_code'] = matchCode;
    data['my_code'] = myCode;
    data['qualities'] = qualities;
    return data;
  }
}
