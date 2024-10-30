// To parse this JSON data, do
//
//     final examDetailResponse = examDetailResponseFromJson(jsonString);

import 'dart:convert';

ExamDetailResponse examDetailResponseFromJson(String str) => ExamDetailResponse.fromJson(json.decode(str));

String examDetailResponseToJson(ExamDetailResponse data) => json.encode(data.toJson());

class ExamDetailResponse {
  bool? success;
  Exam? exam;
  bool? completed;
  String? message;

  ExamDetailResponse({
    this.success,
    this.exam,
    this.completed,
    this.message,
  });

  factory ExamDetailResponse.fromJson(Map<String, dynamic> json) => ExamDetailResponse(
    success: json["success"],
    exam: Exam.fromJson(json["exam"]),
    completed: json["completed"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "exam": exam?.toJson(),
    "completed": completed,
    "message": message,
  };
}

class Exam {
  String? id;
  String? status;
  num? fullMarks;
  num? passMarks;
  bool? examCodeEnabled;
  bool? singleSessionEnabled;
  String? examTitle;
  DateTime? startDate;
  DateTime? endDate;
  String? remarks;
  String? duration;

  Exam({
    this.id,
    this.status,
    this.fullMarks,
    this.passMarks,
    this.examCodeEnabled,
    this.singleSessionEnabled,
    this.examTitle,
    this.startDate,
    this.endDate,
    this.remarks,
    this.duration,
  });

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
    id: json["_id"],
    status: json["status"],
    fullMarks: json["fullMarks"],
    passMarks: json["passMarks"],
    examCodeEnabled: json["examCodeEnabled"],
    singleSessionEnabled: json["singleSessionEnabled"],
    examTitle: json["examTitle"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    remarks: json["remarks"],
    duration: json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "status": status,
    "fullMarks": fullMarks,
    "passMarks": passMarks,
    "examCodeEnabled": examCodeEnabled,
    "singleSessionEnabled": singleSessionEnabled,
    "examTitle": examTitle,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "remarks": remarks,
    "duration": duration,
  };
}
