// To parse this JSON data, do
//
//     final qrDataExamRequest = qrDataExamRequestFromJson(jsonString);

import 'dart:convert';

QrDataExamRequest qrDataExamRequestFromJson(String str) =>
    QrDataExamRequest.fromJson(json.decode(str));

String qrDataExamRequestToJson(QrDataExamRequest data) =>
    json.encode(data.toJson());

class QrDataExamRequest {
  QrDataExamRequest({
    this.firstname,
    this.lastname,
    this.batch,
    this.institution,
    this.username,
    this.exams,
    this.token
  });

  String? firstname;
  String? lastname;
  String? batch;
  String? institution;
  String? username;
  String? token;
  List<String>? exams;

  factory QrDataExamRequest.fromJson(Map<String, dynamic> json) =>
      QrDataExamRequest(
        firstname: json["firstname"],
        lastname: json["lastname"],
        batch: json["batch"],
        institution: json["institution"],
        username: json["username"],
        token: json["token"],
        exams: List<String>.from(json["exams"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "batch": batch,
        "institution": institution,
        "username": username,
        "token": token,
        "exams": List<dynamic>.from(exams!.map((x) => x)),
      };
}
