// To parse this JSON data, do
//
//     final userdetailresponse = userdetailresponseFromJson(jsonString);

import 'dart:convert';

Userdetailresponse userdetailresponseFromJson(String str) => Userdetailresponse.fromJson(json.decode(str));

String userdetailresponseToJson(Userdetailresponse data) => json.encode(data.toJson());

class Userdetailresponse {
  Userdetailresponse({
    this.success,
    this.user,
  });

  bool ?success;
  UserDetail ?user;

  factory Userdetailresponse.fromJson(Map<String, dynamic> json) => Userdetailresponse(
    success: json["success"],
    user: UserDetail.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "user": user?.toJson(),
  };
}

class UserDetail {
  UserDetail({
    this.gender,
    this.address,
    this.city,
    this.province,
    this.school,
    this.college,
    this.background,
    this.contact,
    this.parentFirstName,
    this.parentLastName,
    this.parentsEmail,
    this.parentsContact,
    this.maritalStatus,
    this.bio,
    this.coventryId,
    this.registrationId,
    this.institution,
    this.panNumber,
    this.pfNumber,
    this.bankAccount,
  });

  String ?gender;
  String ?address;
  String ?city;
  String ?province;
  String ?school;
  String ?college;
  String ?background;
  String ?contact;
  String ?parentFirstName;
  String ?parentLastName;
  String ?parentsEmail;
  String ?parentsContact;
  String ?maritalStatus;
  String ?bio;
  String ?coventryId;
  String ?registrationId;
  String ?institution;
  String ?panNumber;
  String ?pfNumber;
  String ?bankAccount;

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
    gender: json["gender"],
    address: json["address"],
    city: json["city"],
    province: json["province"],
    school: json["school"],
    college: json["college"],
    background: json["background"],
    contact: json["contact"],
    parentFirstName: json["parentFirstName"],
    parentLastName: json["parentLastName"],
    parentsEmail: json["parentsEmail"],
    parentsContact: json["parentsContact"],
    maritalStatus: json["maritalStatus"],
    bio: json["bio"],
    coventryId: json["coventryID"],
    registrationId: json["registrationID"],
    institution: json["institution"],
    panNumber: json["pan_number"],
    pfNumber: json["pf_number"],
    bankAccount: json["bank_account"],
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
    "parentFirstName": parentFirstName,
    "parentLastName": parentLastName,
    "parentsEmail": parentsEmail,
    "parentsContact": parentsContact,
    "maritalStatus": maritalStatus,
    "bio": bio,
    "coventryID": coventryId,
    "registrationID": registrationId,
    "institution": institution,
    "pan_number": panNumber,
    "pf_number": pfNumber,
    "bank_account": bankAccount,
  };
}