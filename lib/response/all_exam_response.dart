// To parse this JSON data, do
//
//     final allExamResponse = allExamResponseFromJson(jsonString);

import 'dart:convert';

AllExamResponse allExamResponseFromJson(String str) => AllExamResponse.fromJson(json.decode(str));

String allExamResponseToJson(AllExamResponse data) => json.encode(data.toJson());

class AllExamResponse {
  bool? success;
  List<AllExam>? allExams;
  String? message;

  AllExamResponse({
    this.success,
    this.allExams,
    this.message,
  });

  factory AllExamResponse.fromJson(Map<String, dynamic> json) => AllExamResponse(
    success: json["success"],
    allExams: List<AllExam>.from(json["allExams"].map((x) => AllExam.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "allExams": List<dynamic>.from(allExams!.map((x) => x.toJson())),
    "message": message,
  };
}

class AllExam {
  String? id;
  List<String>? batch;
  List<dynamic>? resit;
  String? examTitle;
  DateTime? startDate;
  DateTime? endDate;
  String? moduleSlug;
  String? moduleTitle;

  AllExam({
    this.id,
    this.batch,
    this.resit,
    this.examTitle,
    this.startDate,
    this.endDate,
    this.moduleSlug,
    this.moduleTitle
  });

  factory AllExam.fromJson(Map<String, dynamic> json) => AllExam(
    id: json["_id"],
    batch: List<String>.from(json["batch"].map((x) => x)),
    resit: List<dynamic>.from(json["resit"].map((x) => x)),
    examTitle: json["examTitle"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    moduleSlug: json["moduleSlug"],
    moduleTitle: json["moduleTitle"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "batch": List<dynamic>.from(batch!.map((x) => x)),
    "resit": List<dynamic>.from(resit!.map((x) => x)),
    "examTitle": examTitle,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "moduleSlug": moduleSlug,
    "moduleTitle": moduleTitle,
  };
}
