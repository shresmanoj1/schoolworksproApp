// To parse this JSON data, do
//
//     final studentAttendanceResponse = studentAttendanceResponseFromJson(jsonString);

import 'dart:convert';

StudentAttendanceResponse studentAttendanceResponseFromJson(String str) =>
    StudentAttendanceResponse.fromJson(json.decode(str));

String studentAttendanceResponseToJson(StudentAttendanceResponse data) =>
    json.encode(data.toJson());

class StudentAttendanceResponse {
  StudentAttendanceResponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory StudentAttendanceResponse.fromJson(Map<String, dynamic> json) =>
      StudentAttendanceResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
