// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class UserModel {
//   late String id;
//   late String userName;
//   String? email;
//   String? phoneNumber;
//   late String loginType;
//   String? profileImage;
//   bool? emailVerified;
//   Timestamp? createdAt;
//   String? errorType;
//   String? profileImageUrl;
//   UserModel({
//     required this.id,
//     required this.userName,
//     required this.loginType,
//     this.createdAt,
//     this.profileImage,
//     this.email,
//     this.phoneNumber,
//     this.emailVerified,
//     this.errorType,
//
//   });
//
//   UserModel.fromJson(Map<String, dynamic> json) {
//     id = json["id"].toString();
//     userName = json["userName"].toString();
//     profileImage = json["profileImage"].toString();
//     loginType = json["loginType"].toString();
//     phoneNumber = json["phoneNumber"].toString();
//     email = json["email"].toString();
//     emailVerified = json["emailVerified"] as bool? ?? false;
//     createdAt = json['createdOn'] as Timestamp?;
//
//   }
//
//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> data = {};
//     data['id'] = id;
//     data["email"] = email;
//     data["userName"] = userName;
//     data["profileImage"] = profileImage;
//     data["loginType"] = loginType;
//     data["phoneNumber"] = phoneNumber;
//     data['emailVerified'] = emailVerified?? false;
//     data['createdOn'] = createdAt;
//     return data;
//   }
// }
