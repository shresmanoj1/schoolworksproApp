// To parse this JSON data, do
//
//     final getAllUserResponse = getAllUserResponseFromJson(jsonString);

import 'dart:convert';

GetAllUserResponse getAllUserResponseFromJson(String str) =>
    GetAllUserResponse.fromJson(json.decode(str));

String getAllUserResponseToJson(GetAllUserResponse data) =>
    json.encode(data.toJson());

class GetAllUserResponse {
  GetAllUserResponse({
    this.success,
    this.users,
  });

  bool? success;
  List<dynamic>? users;

  factory GetAllUserResponse.fromJson(Map<String, dynamic> json) =>
      GetAllUserResponse(
        success: json["success"],
        users: List<dynamic>.from(json["users"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "users": List<dynamic>.from(users!.map((x) => x)),
      };
}
