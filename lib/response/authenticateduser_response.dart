// To parse this JSON data, do
//
//     final authenticateduserresponse = authenticateduserresponseFromJson(jsonString);

import 'dart:convert';

Authenticateduserresponse authenticateduserresponseFromJson(String str) =>
    Authenticateduserresponse.fromJson(json.decode(str));

String authenticateduserresponseToJson(Authenticateduserresponse data) =>
    json.encode(data.toJson());

class Authenticateduserresponse {
  Authenticateduserresponse({
    this.success,
    this.message,
    this.user,
    this.privateFlag
  });

  bool? success;
  String? message;
  User? user;
  bool? privateFlag;

  factory Authenticateduserresponse.fromJson(Map<String, dynamic> json) =>
      Authenticateduserresponse(
        success: json["success"],
        message: json["message"],
        privateFlag: json["privateFlag"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "privateFlag": privateFlag,
        "user": user!.toJson(),
      };
}

class User {
  User(
      {this.firstname,
      this.lastname,
      this.username,
      this.userImage,
      this.address,
      this.contact,
      this.city,
      this.type,
      this.batch,
      this.bio,
      this.email,
      this.courseSlug,
      this.institution,
      this.designation,
      this.dues,
      this.examId,
      this.coventryID});

  String? firstname;
  String? lastname;
  String? username;
  String? userImage;
  String? address;
  String? contact;
  String? city;
  String? type;
  String? batch;
  String? bio;
  String? email;
  String? courseSlug;
  String? institution;
  String? designation;
  bool? dues;
  String? examId;
  String? coventryID;

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        userImage: json["userImage"],
        address: json["address"],
        contact: json["contact"],
        city: json["city"],
        type: json["type"],
        batch: json["batch"],
        bio: json["bio"],
        email: json["email"],
        courseSlug: json["courseSlug"],
        institution: json["institution"],
        designation: json["designation"],
        coventryID: json["coventryID"],
        dues: json["dues"],
        examId: json["examId"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "userImage": userImage,
        "address": address,
        "contact": contact,
        "city": city,
        "type": type,
        "batch": batch,
        "coventryID": coventryID,
        "bio": bio,
        "email": email,
        "courseSlug": courseSlug,
        "institution": institution,
        "dues": dues,
        "examId": examId,
      };
}
