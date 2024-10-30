// To parse this JSON data, do
//
//     final examFromCourseResponse = examFromCourseResponseFromJson(jsonString);

import 'dart:convert';

ExamFromCourseResponse examFromCourseResponseFromJson(String str) => ExamFromCourseResponse.fromJson(json.decode(str));

String examFromCourseResponseToJson(ExamFromCourseResponse data) => json.encode(data.toJson());

class ExamFromCourseResponse {
  ExamFromCourseResponse({
    this.success,
    this.allExams,
  });

  bool ? success;
  List<AllExam> ? allExams;

  factory ExamFromCourseResponse.fromJson(Map<String, dynamic> json) => ExamFromCourseResponse(
    success: json["success"],
    allExams: List<AllExam>.from(json["allExams"].map((x) => AllExam.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "allExams": List<dynamic>.from(allExams!.map((x) => x.toJson())),
  };
}

class AllExam {
  AllExam({
    this.id,
    this.examTitle,
    this.examSlug,
  });

  String ? id;
  String ? examTitle;
  String ? examSlug;

  factory AllExam.fromJson(Map<String, dynamic> json) => AllExam(
    id: json["_id"] == null ? null : json["_id"],
    examTitle: json["examTitle"] == null ? null : json["examTitle"],
    examSlug: json["examSlug"] == null ? null : json["examSlug"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "examTitle": examTitle == null ? null : examTitle,
    "examSlug": examSlug == null ? null : examSlug,
  };
}
