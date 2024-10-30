// To parse this JSON data, do
//
//     final academicRequestResponse = academicRequestResponseFromJson(jsonString);

import 'dart:convert';

AcademicRequestResponse academicRequestResponseFromJson(String str) =>
    AcademicRequestResponse.fromJson(json.decode(str));

String academicRequestResponseToJson(AcademicRequestResponse data) =>
    json.encode(data.toJson());

class AcademicRequestResponse {
  AcademicRequestResponse({
    this.success,
    this.requests,
  });

  bool? success;
  List<dynamic>? requests;

  factory AcademicRequestResponse.fromJson(Map<String, dynamic> json) =>
      AcademicRequestResponse(
        success: json["success"],
        requests: List<dynamic>.from(json["requests"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "requests": List<dynamic>.from(requests!.map((x) => x)),
      };
}
