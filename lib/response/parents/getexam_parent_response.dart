// To parse this JSON data, do
//
//     final getExamParentResponse = getExamParentResponseFromJson(jsonString);

import 'dart:convert';

GetExamParentResponse getExamParentResponseFromJson(String str) => GetExamParentResponse.fromJson(json.decode(str));

String getExamParentResponseToJson(GetExamParentResponse data) => json.encode(data.toJson());

class GetExamParentResponse {
  GetExamParentResponse({
    this.success,
    this.allExams,
  });

  bool ? success;
  List<AllExam> ? allExams;

  factory GetExamParentResponse.fromJson(Map<String, dynamic> json) => GetExamParentResponse(
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
    id: json["_id"],
    examTitle: json["examTitle"],
    examSlug: json["examSlug"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "examTitle": examTitle,
    "examSlug": examSlug,
  };
}
