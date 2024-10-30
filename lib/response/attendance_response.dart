// To parse this JSON data, do
//
//     final attendanceresponse = attendanceresponseFromJson(jsonString);

import 'dart:convert';

Attendanceresponse attendanceresponseFromJson(String str) =>
    Attendanceresponse.fromJson(json.decode(str));

String attendanceresponseToJson(Attendanceresponse data) =>
    json.encode(data.toJson());

class Attendanceresponse {
  Attendanceresponse({
    this.success,
    this.allAttendance,
  });

  bool? success;
  List<AllAttendance>? allAttendance;

  factory Attendanceresponse.fromJson(Map<String, dynamic> json) =>
      Attendanceresponse(
        success: json["success"],
        allAttendance: List<AllAttendance>.from(
            json["allAttendance"].map((x) => AllAttendance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "allAttendance":
            List<dynamic>.from(allAttendance!.map((x) => x.toJson())),
      };
}

class AllAttendance {
  AllAttendance({
    this.moduleTitle,
    this.presentDays,
    this.absentDays,
    this.percentage,
  });

  String? moduleTitle;
  int? presentDays;
  int? absentDays;
  double? percentage;

  factory AllAttendance.fromJson(Map<String, dynamic> json) => AllAttendance(
        moduleTitle: json["moduleTitle"],
        presentDays: json["presentDays"],
        absentDays: json["absentDays"],
        percentage: json["percentage"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "moduleTitle": moduleTitle,
        "presentDays": presentDays,
        "absentDays": absentDays,
        "percentage": percentage,
      };
}
