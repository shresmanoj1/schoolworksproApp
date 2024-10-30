// To parse this JSON data, do
//
//     final createNewAttendanceResponse = createNewAttendanceResponseFromJson(jsonString);

import 'dart:convert';

CreateNewAttendanceResponse createNewAttendanceResponseFromJson(String str) => CreateNewAttendanceResponse.fromJson(json.decode(str));

String createNewAttendanceResponseToJson(CreateNewAttendanceResponse data) => json.encode(data.toJson());

class CreateNewAttendanceResponse {
  CreateNewAttendanceResponse({
    this.success,
    this.message,
    this.attendance,
  });

  bool ?success;
  String ? message;
  Attendance ? attendance;

  factory CreateNewAttendanceResponse.fromJson(Map<String, dynamic> json) => CreateNewAttendanceResponse(
    success: json["success"],
    message: json["message"],
    attendance: Attendance.fromJson(json["attendance"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "attendance": attendance?.toJson(),
  };
}

class Attendance {
  Attendance({
    this.presentStudents,
    this.absentStudents,
    this.id,
    this.moduleSlug,
    this.batch,
    this.institution,
    this.attendanceBy,
    this.date,
    this.createdAt,
  });

  List<dynamic> ? presentStudents;
  List<dynamic> ? absentStudents;
  String  ? id;
  String ? moduleSlug;
  String ? batch;
  String ? institution;
  String ? attendanceBy;
  DateTime ? date;
  DateTime ? createdAt;

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    presentStudents: List<dynamic>.from(json["present_students"].map((x) => x)),
    absentStudents: List<dynamic>.from(json["absent_students"].map((x) => x)),
    id: json["_id"],
    moduleSlug: json["moduleSlug"],
    batch: json["batch"],
    institution: json["institution"],
    attendanceBy: json["attendanceBy"],
    date: DateTime.parse(json["date"]),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "present_students": List<dynamic>.from(presentStudents!.map((x) => x)),
    "absent_students": List<dynamic>.from(absentStudents!.map((x) => x)),
    "_id": id,
    "moduleSlug": moduleSlug,
    "batch": batch,
    "institution": institution,
    "attendanceBy": attendanceBy,
    "date": date?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
  };
}
