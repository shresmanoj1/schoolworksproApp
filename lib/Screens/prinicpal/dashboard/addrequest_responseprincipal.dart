// To parse this JSON data, do
//
//     final principalAddTaskResponse = principalAddTaskResponseFromJson(jsonString);

import 'dart:convert';

PrincipalAddTaskResponse principalAddTaskResponseFromJson(String str) =>
    PrincipalAddTaskResponse.fromJson(json.decode(str));

String principalAddTaskResponseToJson(PrincipalAddTaskResponse data) =>
    json.encode(data.toJson());

class PrincipalAddTaskResponse {
  PrincipalAddTaskResponse({
    this.success,
    this.message,
    this.request,
  });

  bool? success;
  String? message;
  dynamic request;

  factory PrincipalAddTaskResponse.fromJson(Map<String, dynamic> json) =>
      PrincipalAddTaskResponse(
        success: json["success"],
        message: json["message"],
        request: json["request"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "request": request,
      };
}
