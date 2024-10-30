// To parse this JSON data, do
//
//     final getSupportStaffResponse = getSupportStaffResponseFromJson(jsonString);

import 'dart:convert';

GetSupportStaffResponse getSupportStaffResponseFromJson(String str) =>
    GetSupportStaffResponse.fromJson(json.decode(str));

String getSupportStaffResponseToJson(GetSupportStaffResponse data) =>
    json.encode(data.toJson());

class GetSupportStaffResponse {
  GetSupportStaffResponse({
    this.success,
    this.message,
    this.staff,
  });

  bool? success;
  String? message;
  Staff? staff;

  factory GetSupportStaffResponse.fromJson(Map<String, dynamic> json) =>
      GetSupportStaffResponse(
        success: json["success"],
        message: json["message"],
        staff: Staff.fromJson(json["staff"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "staff": staff?.toJson(),
      };
}

class Staff {
  Staff({
    this.batches,
    this.id,
    this.username,
    this.institution,
  });

  List<String>? batches;
  String? id;
  String? username;
  String? institution;

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        batches: List<String>.from(json["batches"].map((x) => x)),
        id: json["_id"],
        username: json["username"],
        institution: json["institution"],
      );

  Map<String, dynamic> toJson() => {
        "batches": List<dynamic>.from(batches!.map((x) => x)),
        "_id": id,
        "username": username,
        "institution": institution,
      };
}
