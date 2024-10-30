// To parse this JSON data, do
//
//     final lecturerStudentReportResponse = lecturerStudentReportResponseFromJson(jsonString);

import 'dart:convert';

LecturerStudentReportResponse lecturerStudentReportResponseFromJson(
    String str) =>
    LecturerStudentReportResponse.fromJson(json.decode(str));

String lecturerStudentReportResponseToJson(
    LecturerStudentReportResponse data) =>
    json.encode(data.toJson());

class LecturerStudentReportResponse {
  LecturerStudentReportResponse({
    this.success,
    this.lessonStatus,
  });

  bool? success;
  List<LessonStatus>? lessonStatus;

  factory LecturerStudentReportResponse.fromJson(Map<String, dynamic> json) =>
      LecturerStudentReportResponse(
        success: json["success"],
        lessonStatus: List<LessonStatus>.from(
            json["lessonStatus"].map((x) => LessonStatus.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "lessonStatus":
    List<dynamic>.from(lessonStatus!.map((x) => x.toJson())),
  };
}

class LessonStatus {
  LessonStatus({
    this.username,
    this.name,
    this.batch,
    this.timeSpent,
  });

  String? username;
  String? name;
  String? batch;
  String? timeSpent;

  factory LessonStatus.fromJson(Map<String, dynamic> json) => LessonStatus(
    username: json["username"],
    name: json["name"],
    batch: json["batch"],
    timeSpent: json["timeSpent"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "name": name,
    "batch": batch,
    "timeSpent": timeSpent,
  };
}
