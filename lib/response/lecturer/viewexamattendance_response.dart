// To parse this JSON data, do
//
//     final viewExamAttendanceResponse = viewExamAttendanceResponseFromJson(jsonString);

import 'dart:convert';

ViewExamAttendanceResponse viewExamAttendanceResponseFromJson(String str) => ViewExamAttendanceResponse.fromJson(json.decode(str));

String viewExamAttendanceResponseToJson(ViewExamAttendanceResponse data) => json.encode(data.toJson());

class ViewExamAttendanceResponse {
  ViewExamAttendanceResponse({
    this.sucess,
    this.allStudents,
  });

  bool ? sucess;
  List<AllStudent> ? allStudents;

  factory ViewExamAttendanceResponse.fromJson(Map<String, dynamic> json) => ViewExamAttendanceResponse(
    sucess: json["sucess"],
    allStudents: json["allStudents"] == null ? null : List<AllStudent>.from(json["allStudents"].map((x) => AllStudent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sucess": sucess,
    "allStudents": allStudents == null ? null : List<dynamic>.from(allStudents!.map((x) => x.toJson())),
  };
}

class AllStudent {
  AllStudent({
    this.status,
    this.time,
    this.attendanceDate,
    this.firstname,
    this.lastname,
    this.username,
    this.batch,
    this.isResit,
  });

  String ? status;
  List<Time> ? time;
  String ? attendanceDate;
  String ? firstname;
  String ? lastname;
  String ? username;
  String ? batch;
  bool ? isResit;

  factory AllStudent.fromJson(Map<String, dynamic> json) => AllStudent(
    status: json["status"] == null ? null : json["status"],
    time: json["time"] == null ? null : List<Time>.from(json["time"].map((x) => Time.fromJson(x))),
    attendanceDate: json["attendanceDate"] == null ? null : json["attendanceDate"],
    firstname: json["firstname"] == null ? null : json["firstname"],
    lastname: json["lastname"] == null ? null : json["lastname"],
    username: json["username"] == null ? null : json["username"],
    batch: json["batch"] == null ? null : json["batch"],
    isResit: json["isResit"] == null ? null : json["isResit"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "time": time == null ? null : List<dynamic>.from(time!.map((x) => x.toJson())),
    "attendanceDate": attendanceDate == null ? null : attendanceDate,
    "firstname": firstname == null ? null :firstname,
    "lastname": lastname == null ? null : lastname,
    "username": username == null ? null :username,
    "batch": batch == null ? null :batch,
    "isResit": isResit == null ? null : isResit,
  };
}

class Time {
  Time({
    this.punchIn,
    this.punchOut,
  });

  DateTime ? punchIn;
  DateTime ? punchOut;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
    // punchIn: DateTime.parse(json["punchIn"]),
    punchIn: json["punchIn"] == null ? null : DateTime.parse(json["punchIn"]),
    punchOut: json["punchOut"] == null ? null : DateTime.parse(json["punchOut"]),
  );

  Map<String, dynamic> toJson() => {
    "punchIn": punchIn == null ? null : punchIn?.toIso8601String(),
    "punchOut": punchOut == null ? null : punchOut?.toIso8601String(),
  };
}
