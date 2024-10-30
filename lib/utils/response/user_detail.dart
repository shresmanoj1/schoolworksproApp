// To parse this JSON data, do
//
//     final userdetailresponse = userdetailresponseFromJson(jsonString);

import 'dart:convert';

Userdetailresponse userdetailresponseFromJson(String str) =>
    Userdetailresponse.fromJson(json.decode(str));

String userdetailresponseToJson(Userdetailresponse data) =>
    json.encode(data.toJson());

class Userdetailresponse {
  Userdetailresponse({
    this.success,
    this.user,
  });

  bool? success;
  User? user;

  factory Userdetailresponse.fromJson(Map<String, dynamic> json) =>
      Userdetailresponse(
        success: json["success"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "user": user!.toJson(),
      };
}

class User {
  User({
    this.gender,
    this.address,
    this.city,
    this.province,
    this.school,
    this.college,
    this.background,
    this.contact,
    this.parentsContact,
    this.bio,
    this.institution,
  });

  String? gender;
  String? address;
  String? city;
  String? province;
  String? school;
  String? college;
  String? background;
  String? contact;
  String? parentsContact;
  String? bio;
  String? institution;

  factory User.fromJson(Map<String, dynamic> json) => User(
        gender: json["gender"],
        address: json["address"],
        city: json["city"],
        province: json["province"],
        school: json["school"],
        college: json["college"],
        background: json["background"],
        contact: json["contact"],
        parentsContact: json["parentsContact"],
        bio: json["bio"],
        institution: json["institution"],
      );

  Map<String, dynamic> toJson() => {
        "gender": gender,
        "address": address,
        "city": city,
        "province": province,
        "school": school,
        "college": college,
        "background": background,
        "contact": contact,
        "parentsContact": parentsContact,
        "bio": bio,
        "institution": institution,
      };
}
