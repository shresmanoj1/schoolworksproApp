
// To parse this JSON data, do
//
//     final attendanceReportResponse = attendanceReportResponseFromJson(jsonString);

import 'dart:convert';

AttendanceReportResponse attendanceReportResponseFromJson(String str) => AttendanceReportResponse.fromJson(json.decode(str));

String attendanceReportResponseToJson(AttendanceReportResponse data) => json.encode(data.toJson());

class AttendanceReportResponse {
  AttendanceReportResponse({
    this.success,
    this.allAttendance,
  });

  bool ? success;
  List<AllAttendance> ? allAttendance;

  factory AttendanceReportResponse.fromJson(Map<String, dynamic> json) => AttendanceReportResponse(
    success: json["success"],
    allAttendance: List<AllAttendance>.from(json["allAttendance"].map((x) => AllAttendance.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "allAttendance": List<dynamic>.from(allAttendance!.map((x) => x.toJson())),
  };
}

class AllAttendance {
  AllAttendance({
    this.name,
    this.username,
    this.contact,
    this.presentDays,
    this.absentDays,
    this.totalDays,
    this.percentage,
  });

  String ? name;
  String ? username;
  String ? contact;
  int ? presentDays;
  int ? absentDays;
  int ? totalDays;
  double ? percentage;

  factory AllAttendance.fromJson(Map<String, dynamic> json) => AllAttendance(
    name: json["name"],
    username: json["username"],
    contact: json["contact"] == null ? null : json["contact"],
    presentDays: json["presentDays"],
    absentDays: json["absentDays"],
    totalDays: json["totalDays"],
    percentage: json["percentage"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "username": username,
    "contact": contact == null ? null : contact,
    "presentDays": presentDays,
    "absentDays": absentDays,
    "totalDays": totalDays,
    "percentage": percentage,
  };
}
