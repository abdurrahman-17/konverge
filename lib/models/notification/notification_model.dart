class NotificationModel {
  String? sId;
  String? colorCode;
  String? createdAt;
  String? fullName;
  bool? isRead;
  String? matchType;
  String? message;
  String? myCode;
  String? profilePic;
  String? receiverId;
  String? requestType;
  String? senderId;
  String? updatedAt;
  String? cognitoId;

  NotificationModel(
      {this.sId,
      this.colorCode,
      this.createdAt,
      this.fullName,
      this.isRead,
      this.matchType,
      this.message,
      this.myCode,
      this.profilePic,
      this.receiverId,
      this.requestType,
      this.senderId,
      this.updatedAt,
      this.cognitoId});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    colorCode = json['color_code'];
    createdAt = json['created_at'].toString();
    fullName = json['full_name'];
    isRead = json['is_Read'];
    matchType = json['match_type'];
    message = json['message'];
    myCode = json['my_code'];
    profilePic = json['profile_pic'];
    receiverId = json['receiver_id'];
    requestType = json['request_type'];
    senderId = json['sender_id'];
    updatedAt = json['updated_at'].toString();
    cognitoId = json['cognito_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['color_code'] = this.colorCode;
    data['created_at'] = this.createdAt;
    data['full_name'] = this.fullName;
    data['is_Read'] = this.isRead;
    data['match_type'] = this.matchType;
    data['message'] = this.message;
    data['my_code'] = this.myCode;
    data['profile_pic'] = this.profilePic;
    data['receiver_id'] = this.receiverId;
    data['request_type'] = this.requestType;
    data['sender_id'] = this.senderId;
    data['updated_at'] = this.updatedAt;
    data['cognito_id'] = this.cognitoId;
    return data;
  }
}
