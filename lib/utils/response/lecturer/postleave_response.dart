// To parse this JSON data, do
//
//     final postLeaveResponse = postLeaveResponseFromJson(jsonString);

import 'dart:convert';

PostLeaveResponse postLeaveResponseFromJson(String str) =>
    PostLeaveResponse.fromJson(json.decode(str));

String postLeaveResponseToJson(PostLeaveResponse data) =>
    json.encode(data.toJson());

class PostLeaveResponse {
  PostLeaveResponse({
    this.success,
    this.message,
    this.leave,
  });

  bool? success;
  String? message;
  dynamic leave;

  factory PostLeaveResponse.fromJson(Map<String, dynamic> json) =>
      PostLeaveResponse(
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
