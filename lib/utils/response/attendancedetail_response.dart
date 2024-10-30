// To parse this JSON data, do
//
//     final attendanceDetailResponse = attendanceDetailResponseFromJson(jsonString);

import 'dart:convert';

AttendanceDetailResponse attendanceDetailResponseFromJson(String str) =>
    AttendanceDetailResponse.fromJson(json.decode(str));

String attendanceDetailResponseToJson(AttendanceDetailResponse data) =>
    json.encode(data.toJson());

class AttendanceDetailResponse {
  AttendanceDetailResponse({
    this.success,
    this.allAttendance,
  });

  bool? success;
  List<dynamic>? allAttendance;

  factory AttendanceDetailResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceDetailResponse(
        success: json["success"],
        allAttendance: List<dynamic>.from(json["allAttendance"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "allAttendance": List<dynamic>.from(allAttendance!.map((x) => x)),
      };
}

// class AllAttendance {
//   AllAttendance({
//     this.moduleTitle,
//     this.studentAttendance,
//   });
//
//   String moduleTitle;
//   List<StudentAttendance> studentAttendance;
//
//   factory AllAttendance.fromJson(Map<String, dynamic> json) => AllAttendance(
//     moduleTitle: json["moduleTitle"],
//     studentAttendance: List<StudentAttendance>.from(json["studentAttendance"].map((x) => StudentAttendance.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "moduleTitle": moduleTitle,
//     "studentAttendance": List<dynamic>.from(studentAttendance.map((x) => x.toJson())),
//   };
// }
//
// class StudentAttendance {
//   StudentAttendance({
//     this.date,
//     this.moduleSlug,
//   });
//
//   DateTime date;
//   String moduleSlug;
//
//   factory StudentAttendance.fromJson(Map<String, dynamic> json) => StudentAttendance(
//     date: DateTime.parse(json["date"]),
//     moduleSlug: json["moduleSlug"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "date": date.toIso8601String(),
//     "moduleSlug": moduleSlug,
//   };
// }
