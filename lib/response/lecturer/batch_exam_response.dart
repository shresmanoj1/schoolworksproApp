// To parse this JSON data, do
//
//     final batchExamResponse = batchExamResponseFromJson(jsonString);

import 'dart:convert';

BatchExamResponse batchExamResponseFromJson(String str) => BatchExamResponse.fromJson(json.decode(str));

String batchExamResponseToJson(BatchExamResponse data) => json.encode(data.toJson());

class BatchExamResponse {
  bool ? success;
  List<Exam>? exam;

  BatchExamResponse({
    this.success,
    this.exam,
  });

  factory BatchExamResponse.fromJson(Map<String, dynamic> json) => BatchExamResponse(
    success: json["success"],
    exam: json["exam"] == null? null : List<Exam>.from(json["exam"].map((x) => Exam.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "exam": exam == null? null : List<dynamic>.from(exam!.map((x) => x.toJson())),
  };
}

class Exam {
  String ? examId;
  String ? examTitle;
  String ? examSlug;

  Exam({
    this.examId,
    this.examTitle,
    this.examSlug,
  });

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
    examId: json["examId"],
    examTitle: json["examTitle"],
    examSlug: json["examSlug"],
  );

  Map<String, dynamic> toJson() => {
    "examId": examId,
    "examTitle": examTitle,
    "examSlug": examSlug,
  };
}
