// To parse this JSON data, do
//
//     final ChildAttendanceResponse = ChildAttendanceResponseFromJson(jsonString);

import 'dart:convert';

ChildAttendanceResponse ChildAttendanceResponseFromJson(String str) => ChildAttendanceResponse.fromJson(json.decode(str));

String ChildAttendanceResponseToJson(ChildAttendanceResponse data) => json.encode(data.toJson());

class ChildAttendanceResponse {
  ChildAttendanceResponse({
    this.success,
    this.allAttendance,
  });

  bool ? success;
  List<dynamic> ?  allAttendance;

  factory ChildAttendanceResponse.fromJson(Map<String, dynamic> json) => ChildAttendanceResponse(
    success: json["success"],
    allAttendance: List<dynamic>.from(json["allAttendance"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "allAttendance": List<dynamic>.from(allAttendance!.map((x) => x.toJson())),
  };
}

// class AllAttendance {
//   AllAttendance({
//     this.moduleTitle,
//     this.presentDays,
//     this.absentDays,
//     this.percentage,
//   });
//
//   String moduleTitle;
//   int presentDays;
//   int absentDays;
//   int percentage;
//
//   factory AllAttendance.fromJson(Map<String, dynamic> json) => AllAttendance(
//     moduleTitle: json["moduleTitle"],
//     presentDays: json["presentDays"],
//     absentDays: json["absentDays"],
//     percentage: json["percentage"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "moduleTitle": moduleTitle,
//     "presentDays": presentDays,
//     "absentDays": absentDays,
//     "percentage": percentage,
//   };
// }
