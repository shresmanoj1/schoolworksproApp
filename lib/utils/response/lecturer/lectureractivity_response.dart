// To parse this JSON data, do
//
//     final lecturerActivityResponse = lecturerActivityResponseFromJson(jsonString);

import 'dart:convert';

LecturerActivityResponse lecturerActivityResponseFromJson(String str) =>
    LecturerActivityResponse.fromJson(json.decode(str));

String lecturerActivityResponseToJson(LecturerActivityResponse data) =>
    json.encode(data.toJson());

class LecturerActivityResponse {
  LecturerActivityResponse({
    this.success,
    this.assessments,
  });

  bool? success;
  List<dynamic>? assessments;

  factory LecturerActivityResponse.fromJson(Map<String, dynamic> json) =>
      LecturerActivityResponse(
        success: json["success"],
        assessments: List<dynamic>.from(json["assessments"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "assessments": List<dynamic>.from(assessments!.map((x) => x)),
      };
}
