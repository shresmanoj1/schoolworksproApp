// To parse this JSON data, do
//
//     final getStaffResponse = getStaffResponseFromJson(jsonString);

import 'dart:convert';

GetStaffResponse getStaffResponseFromJson(String str) =>
    GetStaffResponse.fromJson(json.decode(str));

String getStaffResponseToJson(GetStaffResponse data) =>
    json.encode(data.toJson());

class GetStaffResponse {
  GetStaffResponse({
    this.success,
    this.users,
  });

  bool? success;
  List<dynamic>? users;

  factory GetStaffResponse.fromJson(Map<String, dynamic> json) =>
      GetStaffResponse(
        success: json["success"],
        users: List<dynamic>.from(json["users"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "users": List<dynamic>.from(users!.map((x) => x)),
      };
}
