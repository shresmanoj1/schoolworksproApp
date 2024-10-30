// To parse this JSON data, do
//
//     final getAllAttendancePrincipalResponse = getAllAttendancePrincipalResponseFromJson(jsonString);

import 'dart:convert';

GetAllAttendancePrincipalResponse getAllAttendancePrincipalResponseFromJson(
        String str) =>
    GetAllAttendancePrincipalResponse.fromJson(json.decode(str));

String getAllAttendancePrincipalResponseToJson(
        GetAllAttendancePrincipalResponse data) =>
    json.encode(data.toJson());

class GetAllAttendancePrincipalResponse {
  GetAllAttendancePrincipalResponse({
    this.success,
    this.allAttendance,
  });

  bool? success;
  List<AllAttendance>? allAttendance;

  factory GetAllAttendancePrincipalResponse.fromJson(
          Map<String, dynamic> json) =>
      GetAllAttendancePrincipalResponse(
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
    this.name,
    this.username,
    this.presentDays,
    this.absentDays,
    this.totalDays,
    this.percentage,
    this.contact,
  });

  String? name;
  String? username;
  int? presentDays;
  int? absentDays;
  int? totalDays;
  double? percentage;
  String? contact;

  factory AllAttendance.fromJson(Map<String, dynamic> json) => AllAttendance(
        name: json["name"] == null ? null : json["name"],
        username: json["username"] == null ? null : json["username"],
        presentDays: json["presentDays"] == null ? null : json["presentDays"],
        absentDays: json["absentDays"] == null ? null : json["absentDays"],
        totalDays: json["totalDays"] == null ? null : json["totalDays"],
        percentage:
            json["percentage"] == null ? null : json["percentage"].toDouble(),
        contact: json["contact"] == null ? null : json["contact"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "username": username == null ? null : username,
        "presentDays": presentDays == null ? null : presentDays,
        "absentDays": absentDays == null ? null : absentDays,
        "totalDays": totalDays == null ? null : totalDays,
        "percentage": percentage == null ? null : percentage,
        "contact": contact == null ? null : contact,
      };
}
