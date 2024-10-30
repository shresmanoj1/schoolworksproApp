// To parse this JSON data, do
//
//     final lecturerGetExamResponse = lecturerGetExamResponseFromJson(jsonString);

import 'dart:convert';

LecturerGetExamResponse lecturerGetExamResponseFromJson(String str) =>
    LecturerGetExamResponse.fromJson(json.decode(str));

String lecturerGetExamResponseToJson(LecturerGetExamResponse data) =>
    json.encode(data.toJson());

class LecturerGetExamResponse {
  LecturerGetExamResponse({
    this.success,
    this.exam,
  });

  bool? success;
  List<dynamic>? exam;

  factory LecturerGetExamResponse.fromJson(Map<String, dynamic> json) =>
      LecturerGetExamResponse(
        success: json["success"],
        exam: List<dynamic>.from(json["exam"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "exam": List<dynamic>.from(exam!.map((x) => x)),
      };
}
