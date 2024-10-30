// To parse this JSON data, do
//
//     final activityLogsResponse = activityLogsResponseFromJson(jsonString);

import 'dart:convert';

ActivityLogsResponse activityLogsResponseFromJson(String str) =>
    ActivityLogsResponse.fromJson(json.decode(str));

String activityLogsResponseToJson(ActivityLogsResponse data) =>
    json.encode(data.toJson());

class ActivityLogsResponse {
  ActivityLogsResponse({
    this.success,
    this.monthlyAttendance,
  });

  bool? success;
  List<MonthlyAttendance>? monthlyAttendance;

  factory ActivityLogsResponse.fromJson(Map<String, dynamic> json) =>
      ActivityLogsResponse(
        success: json["success"],
        monthlyAttendance: List<MonthlyAttendance>.from(
            json["monthlyAttendance"]
                .map((x) => MonthlyAttendance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "monthlyAttendance":
            List<dynamic>.from(monthlyAttendance!.map((x) => x.toJson())),
      };
}

class MonthlyAttendance {
  MonthlyAttendance({
    this.status,
    this.time,
    this.username,
    this.institution,
    this.attendanceDate,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.workingHours,
  });

  String? status;
  List<Time>? time;
  String? username;
  String? institution;
  String? attendanceDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? workingHours;

  factory MonthlyAttendance.fromJson(Map<String, dynamic> json) =>
      MonthlyAttendance(
        status: json["status"],
        time: List<Time>.from(json["time"].map((x) => Time.fromJson(x))),
        username: json["username"],
        institution: json["institution"],
        attendanceDate: json["attendanceDate"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        workingHours: json["workingHours"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "time": List<dynamic>.from(time!.map((x) => x.toJson())),
        "username": username,
        "institution": institution,
        "attendanceDate": attendanceDate,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "workingHours": workingHours,
      };
}

class Time {
  Time({
    this.id,
    this.punchIn,
    this.punchOut,
  });

  String? id;
  DateTime? punchIn;
  DateTime? punchOut;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        id: json["_id"],
        punchIn: DateTime.parse(json["punchIn"]),
        punchOut: DateTime.parse(json["punchOut"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "punchIn": punchIn?.toIso8601String(),
        "punchOut": punchOut?.toIso8601String(),
      };
}
