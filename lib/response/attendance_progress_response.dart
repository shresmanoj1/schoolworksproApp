// To parse this JSON data, do
//
//     final attendanceProgressResponse = attendanceProgressResponseFromJson(jsonString);

import 'dart:convert';

AttendanceProgressResponse attendanceProgressResponseFromJson(String str) => AttendanceProgressResponse.fromJson(json.decode(str));

String attendanceProgressResponseToJson(AttendanceProgressResponse data) => json.encode(data.toJson());

class AttendanceProgressResponse {
  bool? success;
  Attendance? attendance;

  AttendanceProgressResponse({
    this.success,
    this.attendance,
  });

  factory AttendanceProgressResponse.fromJson(Map<String, dynamic> json) => AttendanceProgressResponse(
    success: json["success"],
    attendance: Attendance.fromJson(json["attendance"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "attendance": attendance?.toJson(),
  };
}

class Attendance {
  String? username;
  num? completed;
  num? total;

  Attendance({
    this.username,
    this.completed,
    this.total,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    username: json["username"],
    completed: json["completed"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "completed": completed,
    "total": total,
  };
}
