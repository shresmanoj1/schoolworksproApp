// To parse this JSON data, do
//
//     final changeStudentStatusResponse = changeStudentStatusResponseFromJson(jsonString);

import 'dart:convert';

ChangeStudentStatusResponse changeStudentStatusResponseFromJson(String str) =>
    ChangeStudentStatusResponse.fromJson(json.decode(str));

String changeStudentStatusResponseToJson(ChangeStudentStatusResponse data) =>
    json.encode(data.toJson());

class ChangeStudentStatusResponse {
  ChangeStudentStatusResponse({
    this.success,
    this.message,
    this.updated,
  });

  bool? success;
  String? message;
  dynamic updated;

  factory ChangeStudentStatusResponse.fromJson(Map<String, dynamic> json) =>
      ChangeStudentStatusResponse(
        success: json["success"],
        message: json["message"],
        updated: json["updated"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "updated": updated,
      };
}
