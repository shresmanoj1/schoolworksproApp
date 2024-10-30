// To parse this JSON data, do
//
//     final startlessonresponse = startlessonresponseFromJson(jsonString);

import 'dart:convert';

Startlessonresponse startlessonresponseFromJson(String str) =>
    Startlessonresponse.fromJson(json.decode(str));

String startlessonresponseToJson(Startlessonresponse data) =>
    json.encode(data.toJson());

class Startlessonresponse {
  Startlessonresponse({
    this.success,
    this.message,
    this.status,
  });

  bool? success;
  String? message;
  Status? status;

  factory Startlessonresponse.fromJson(Map<String, dynamic> json) =>
      Startlessonresponse(
        success: json["success"],
        message: json["message"],
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "status": status!.toJson(),
      };
}

class Status {
  Status({
    this.isCompleted,
    this.id,
    this.lesson,
    this.moduleSlug,
    this.startDate,
    this.institution,
    this.student,
  });

  bool? isCompleted;
  String? id;
  String? lesson;
  String? moduleSlug;
  DateTime? startDate;
  String? institution;
  String? student;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        isCompleted: json["isCompleted"],
        id: json["_id"],
        lesson: json["lesson"],
        moduleSlug: json["moduleSlug"],
        startDate: DateTime.parse(json["startDate"]),
        institution: json["institution"],
        student: json["student"],
      );

  Map<String, dynamic> toJson() => {
        "isCompleted": isCompleted,
        "_id": id,
        "lesson": lesson,
        "moduleSlug": moduleSlug,
        "startDate": startDate!.toIso8601String(),
        "institution": institution,
        "student": student,
      };
}
