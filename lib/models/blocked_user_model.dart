class BlockedUserModel {
  Id? iId;
  UserDetails? userDetails;

  BlockedUserModel({this.iId, this.userDetails});

  BlockedUserModel.fromJson(Map<String, dynamic> json) {
    iId = json['_id'] != null
        ? Id.fromJson(json['_id'] as Map<String, dynamic>)
        : null;
    userDetails = json['user_details'] != null
        ? UserDetails.fromJson(json['user_details'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (iId != null) {
      data['_id'] = iId?.toJson();
    }
    if (userDetails != null) {
      data['user_details'] = userDetails?.toJson();
    }
    return data;
  }
}

class Id {
  String? oid;

  Id({this.oid});

  Id.fromJson(Map<String, dynamic> json) {
    oid = json['\$oid'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$oid'] = this.oid;
    return data;
  }
}

class UserDetails {
  Id? iId;
  String? fullName;
  String? profilePic;
  String? myCode;
  String? colorCode;

  UserDetails({
    this.iId,
    this.fullName,
    this.profilePic,
    this.myCode,
    this.colorCode,
  });

  UserDetails.fromJson(Map<String, dynamic> json) {
    print("json $json");

    final value = json['0'];
    if (value != null) {
      fullName = value['full_name'];
      profilePic = value['profile_pic'];
      myCode = value['my_code'];
      colorCode = value['color_code'];
      print("value ${value['_id']}");
      iId = value['_id'] != null
          ? Id.fromJson(value['_id'] as Map<String, dynamic>)
          : null;
    } else {
      fullName = json['full_name'];
      profilePic = json['profile_pic'];
      myCode = json['my_code'];
      colorCode = json['color_code'];
      iId = json['_id'] != null
          ? Id.fromJson(json['_id'] as Map<String, dynamic>)
          : null;
    }
    print("fullname $fullName");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.iId != null) {
      data['_id'] = this.iId!.toJson();
    }
    data['full_name'] = this.fullName;
    data['profile_pic'] = this.profilePic;
    data['my_code'] = this.myCode;
    data['color_code'] = this.colorCode;
    return data;
  }
}
