// To parse this JSON data, do
//
//     final addLeaveTypePrincipalResponse = addLeaveTypePrincipalResponseFromJson(jsonString);

import 'dart:convert';

AddLeaveTypePrincipalResponse addLeaveTypePrincipalResponseFromJson(
        String str) =>
    AddLeaveTypePrincipalResponse.fromJson(json.decode(str));

String addLeaveTypePrincipalResponseToJson(
        AddLeaveTypePrincipalResponse data) =>
    json.encode(data.toJson());

class AddLeaveTypePrincipalResponse {
  AddLeaveTypePrincipalResponse({
    this.success,
    this.message,
    this.leave,
  });

  bool? success;
  String? message;
  dynamic leave;

  factory AddLeaveTypePrincipalResponse.fromJson(Map<String, dynamic> json) =>
      AddLeaveTypePrincipalResponse(
        success: json["success"],
        message: json["message"],
        leave: json["leave"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "leave": leave,
      };
}
