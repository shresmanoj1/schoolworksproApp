// To parse this JSON data, do
//
//     final examAttendanceRequest = examAttendanceRequestFromJson(jsonString);

import 'dart:convert';

ExamAttendanceRequest examAttendanceRequestFromJson(String str) => ExamAttendanceRequest.fromJson(json.decode(str));

String examAttendanceRequestToJson(ExamAttendanceRequest data) => json.encode(data.toJson());

class ExamAttendanceRequest {
  ExamAttendanceRequest({
    this.username,
    this.institution,
    this.exam,
    this.token
  });

  String ? username;
  String ? institution;
  String ? exam;
  String ? token;

  factory ExamAttendanceRequest.fromJson(Map<String, dynamic> json) => ExamAttendanceRequest(
    username: json["username"],
    institution: json["institution"],
    exam: json["exam"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "institution": institution,
    "exam": exam,
    "token": token,
  };
}
