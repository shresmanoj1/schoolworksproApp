// To parse this JSON data, do
//
//     final supportTicketResponse = supportTicketResponseFromJson(jsonString);

import 'dart:convert';

SupportTicketResponse supportTicketResponseFromJson(String str) => SupportTicketResponse.fromJson(json.decode(str));

String supportTicketResponseToJson(SupportTicketResponse data) => json.encode(data.toJson());

class SupportTicketResponse {
  SupportTicketResponse({
    this.success,
    this.lecturers,
  });

  bool ? success;
  List<Lecturer> ? lecturers;

  factory SupportTicketResponse.fromJson(Map<String, dynamic> json) => SupportTicketResponse(
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
    this.firstname,
    this.lastname,
    this.username,
  });

  String ? firstname;
  String ? lastname;
  String ? username;

  factory Lecturer.fromJson(Map<String, dynamic> json) => Lecturer(
    firstname: json["firstname"],
    lastname: json["lastname"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
  };
}
