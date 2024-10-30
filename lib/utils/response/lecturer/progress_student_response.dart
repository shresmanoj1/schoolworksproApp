// To parse this JSON data, do
//
//     final progressStudentResponse = progressStudentResponseFromJson(jsonString);

import 'dart:convert';

ProgressStudentResponse progressStudentResponseFromJson(String str) =>
    ProgressStudentResponse.fromJson(json.decode(str));

String progressStudentResponseToJson(ProgressStudentResponse data) =>
    json.encode(data.toJson());

class ProgressStudentResponse {
  ProgressStudentResponse({
    this.success,
    this.allProgress,
  });

  bool? success;
  List<dynamic>? allProgress;

  factory ProgressStudentResponse.fromJson(Map<String, dynamic> json) =>
      ProgressStudentResponse(
        success: json["success"],
        allProgress: List<dynamic>.from(json["allProgress"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "allProgress": List<dynamic>.from(allProgress!.map((x) => x)),
      };
}
