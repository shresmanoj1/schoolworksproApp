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
  });

  bool? success;
  String? message;
  User? user;

  factory Authenticateduserresponse.fromJson(Map<String, dynamic> json) =>
      Authenticateduserresponse(
        success: json["success"],
        message: json["message"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "user": user!.toJson(),
      };
}

class User {
  User({
    this.firstname,
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
  });

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
        "bio": bio,
        "email": email,
        "courseSlug": courseSlug,
        "institution": institution,
      };
}
