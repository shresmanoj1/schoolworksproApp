// To parse this JSON data, do
//
//     final attendanceReportforPrincipalResponse = attendanceReportforPrincipalResponseFromJson(jsonString);

import 'dart:convert';

AttendanceReportforPrincipalResponse
    attendanceReportforPrincipalResponseFromJson(String str) =>
        AttendanceReportforPrincipalResponse.fromJson(json.decode(str));

String attendanceReportforPrincipalResponseToJson(
        AttendanceReportforPrincipalResponse data) =>
    json.encode(data.toJson());

class AttendanceReportforPrincipalResponse {
  AttendanceReportforPrincipalResponse({
    this.success,
    this.attendances,
    this.attendanceTaken,
    this.attendanceNotTaken,
    this.totalAttendance,
    this.totalPresent,
    this.totalStudents,
    this.remainingAttendance,
  });

  bool? success;
  List<Attendance>? attendances;
  List<AttendanceTaken>? attendanceTaken;
  List<AttendanceNotTaken>? attendanceNotTaken;
  int? totalAttendance;
  int? totalPresent;
  int? totalStudents;
  int? remainingAttendance;

  factory AttendanceReportforPrincipalResponse.fromJson(
          Map<String, dynamic> json) =>
      AttendanceReportforPrincipalResponse(
        success: json["success"],
        attendances: List<Attendance>.from(
            json["attendances"].map((x) => Attendance.fromJson(x))),
        attendanceTaken: List<AttendanceTaken>.from(
            json["attendanceTaken"].map((x) => AttendanceTaken.fromJson(x))),
        attendanceNotTaken: List<AttendanceNotTaken>.from(
            json["attendanceNotTaken"]
                .map((x) => AttendanceNotTaken.fromJson(x))),
        totalAttendance: json["totalAttendance"],
        totalPresent: json["totalPresent"],
        totalStudents: json["totalStudents"],
        remainingAttendance: json["remainingAttendance"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "attendances": List<dynamic>.from(attendances!.map((x) => x.toJson())),
        "attendanceTaken":
            List<dynamic>.from(attendanceTaken!.map((x) => x.toJson())),
        "attendanceNotTaken":
            List<dynamic>.from(attendanceNotTaken!.map((x) => x.toJson())),
        "totalAttendance": totalAttendance,
        "totalPresent": totalPresent,
        "totalStudents": totalStudents,
        "remainingAttendance": remainingAttendance,
      };
}

class AttendanceNotTaken {
  AttendanceNotTaken({
    this.title,
    this.batch,
    this.lecturer,
  });

  String? title;
  String? batch;
  String? lecturer;

  factory AttendanceNotTaken.fromJson(Map<String, dynamic> json) =>
      AttendanceNotTaken(
        title: json["title"],
        batch: json["batch"],
        lecturer: json["lecturer"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "batch": batch,
        "lecturer": lecturer,
      };
}

class AttendanceTaken {
  AttendanceTaken({
    this.present,
    this.absent,
    this.batch,
    this.title,
    this.lecturer,
  });

  int? present;
  int? absent;
  String? batch;
  String? title;
  String? lecturer;

  factory AttendanceTaken.fromJson(Map<String, dynamic> json) =>
      AttendanceTaken(
        present: json["present"],
        absent: json["absent"],
        batch: json["batch"],
        title: json["title"],
        lecturer: json["lecturer"],
      );

  Map<String, dynamic> toJson() => {
        "present": present,
        "absent": absent,
        "batch": batch,
        "title": title,
        "lecturer": lecturer,
      };
}

class Attendance {
  Attendance({
    this.moduleTitle,
    this.status,
    this.batch,
    this.lecturer,
  });

  String? moduleTitle;
  bool? status;
  String? batch;
  String? lecturer;

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        moduleTitle: json["moduleTitle"],
        status: json["status"],
        batch: json["batch"],
        lecturer: json["lecturer"],
      );

  Map<String, dynamic> toJson() => {
        "moduleTitle": moduleTitle,
        "status": status,
        "batch": batch,
        "lecturer": lecturer,
      };
}
