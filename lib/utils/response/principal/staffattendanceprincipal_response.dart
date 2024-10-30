// To parse this JSON data, do
//
//     final staffAttendancePrincipalResponse = staffAttendancePrincipalResponseFromJson(jsonString);

import 'dart:convert';

StaffAttendancePrincipalResponse staffAttendancePrincipalResponseFromJson(
        String str) =>
    StaffAttendancePrincipalResponse.fromJson(json.decode(str));

String staffAttendancePrincipalResponseToJson(
        StaffAttendancePrincipalResponse data) =>
    json.encode(data.toJson());

class StaffAttendancePrincipalResponse {
  StaffAttendancePrincipalResponse({
    this.success,
    this.message,
    this.attendanceData,
  });

  bool? success;
  String? message;
  List<AttendanceDatum>? attendanceData;

  factory StaffAttendancePrincipalResponse.fromJson(
          Map<String, dynamic> json) =>
      StaffAttendancePrincipalResponse(
        success: json["success"],
        message: json["message"],
        attendanceData: List<AttendanceDatum>.from(
            json["attendanceData"].map((x) => AttendanceDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "attendanceData":
            List<dynamic>.from(attendanceData!.map((x) => x.toJson())),
      };
}

class AttendanceDatum {
  AttendanceDatum(
      {this.firstname,
      this.lastname,
      this.email,
      this.username,
      this.attendance,
      this.punchInOut,
      this.userImage,
      this.type});

  String? firstname;
  String? lastname;
  String? email;
  String? username;
  int? attendance;
  dynamic punchInOut;
  String? type;
  String? userImage;

  factory AttendanceDatum.fromJson(Map<String, dynamic> json) =>
      AttendanceDatum(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        username: json["username"],
        attendance: json["attendance"],
        type: json["type"],
        punchInOut: json["punchIn_Out"],
        userImage: json["userImage"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "username": username,
        "attendance": attendance,
        "punchIn_Out": punchInOut,
        "userImage": userImage,
        "type": type
      };
}
