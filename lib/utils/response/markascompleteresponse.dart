// To parse this JSON data, do
//
//     final markascompleteresponse = markascompleteresponseFromJson(jsonString);

import 'dart:convert';

Markascompleteresponse markascompleteresponseFromJson(String str) =>
    Markascompleteresponse.fromJson(json.decode(str));

String markascompleteresponseToJson(Markascompleteresponse data) =>
    json.encode(data.toJson());

class Markascompleteresponse {
  Markascompleteresponse({
    this.success,
    this.lessonStatus,
  });

  bool? success;
  LessonStatus? lessonStatus;

  factory Markascompleteresponse.fromJson(Map<String, dynamic> json) =>
      Markascompleteresponse(
        success: json["success"],
        lessonStatus: LessonStatus.fromJson(json["lessonStatus"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "lessonStatus": lessonStatus!.toJson(),
      };
}

class LessonStatus {
  LessonStatus({
    this.isCompleted,
    this.id,
    this.lesson,
    this.moduleSlug,
    this.startDate,
    this.institution,
    this.student,
    this.endDate,
  });

  bool? isCompleted;
  String? id;
  String? lesson;
  String? moduleSlug;
  DateTime? startDate;
  String? institution;
  String? student;
  DateTime? endDate;

  factory LessonStatus.fromJson(Map<String, dynamic> json) => LessonStatus(
        isCompleted: json["isCompleted"],
        id: json["_id"],
        lesson: json["lesson"],
        moduleSlug: json["moduleSlug"],
        startDate: DateTime.parse(json["startDate"]),
        institution: json["institution"],
        student: json["student"],
        endDate: DateTime.parse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "isCompleted": isCompleted,
        "_id": id,
        "lesson": lesson,
        "moduleSlug": moduleSlug,
        "startDate": startDate!.toIso8601String(),
        "institution": institution,
        "student": student,
        "endDate": endDate!.toIso8601String(),
      };
}
