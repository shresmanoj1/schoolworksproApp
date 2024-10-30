// To parse this JSON data, do
//
//     final checkAttendanceResponse = checkAttendanceResponseFromJson(jsonString);

import 'dart:convert';

CheckAttendanceResponse checkAttendanceResponseFromJson(String str) =>
    CheckAttendanceResponse.fromJson(json.decode(str));

String checkAttendanceResponseToJson(CheckAttendanceResponse data) =>
    json.encode(data.toJson());

class CheckAttendanceResponse {
  CheckAttendanceResponse({
    this.success,
    this.message,
    this.attendanceStatus,
  });

  bool? success;
  String? message;
  bool? attendanceStatus;

  factory CheckAttendanceResponse.fromJson(Map<String, dynamic> json) =>
      CheckAttendanceResponse(
        success: json["success"],
        message: json["message"],
        attendanceStatus: json["attendanceStatus"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "attendanceStatus": attendanceStatus,
      };
}
