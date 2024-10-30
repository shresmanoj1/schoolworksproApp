// To parse this JSON data, do
//
//     final getAllLecturerResponse = getAllLecturerResponseFromJson(jsonString);

import 'dart:convert';

GetAllLecturerResponse getAllLecturerResponseFromJson(String str) => GetAllLecturerResponse.fromJson(json.decode(str));

String getAllLecturerResponseToJson(GetAllLecturerResponse data) => json.encode(data.toJson());

class GetAllLecturerResponse {
  GetAllLecturerResponse({
    this.success,
    this.lecturers,
  });

  bool ? success;
  List<Lecturer> ? lecturers;

  factory GetAllLecturerResponse.fromJson(Map<String, dynamic> json) => GetAllLecturerResponse(
    success: json["success"],
    lecturers: List<Lecturer>.from(json["lecturers"].map((x) => Lecturer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "lecturers": List<dynamic>.from(lecturers!.map((x) => x.toJson())),
  };
}

class Lecturer {
  Lecturer({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.contact,
  });

  String ? id;
  String ? firstname;
  String ? lastname;
  String ? email;
  String  ? contact;

  factory Lecturer.fromJson(Map<String, dynamic> json) => Lecturer(
    id: json["_id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    contact: json["contact"] == null ? null : json["contact"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "contact": contact == null ? null : contact,
  };
}
