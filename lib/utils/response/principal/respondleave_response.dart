// To parse this JSON data, do
//
//     final respondToLeaveResponse = respondToLeaveResponseFromJson(jsonString);

import 'dart:convert';

RespondToLeaveResponse respondToLeaveResponseFromJson(String str) =>
    RespondToLeaveResponse.fromJson(json.decode(str));

String respondToLeaveResponseToJson(RespondToLeaveResponse data) =>
    json.encode(data.toJson());

class RespondToLeaveResponse {
  RespondToLeaveResponse({
    this.success,
    this.leave,
  });

  bool? success;
  dynamic leave;

  factory RespondToLeaveResponse.fromJson(Map<String, dynamic> json) =>
      RespondToLeaveResponse(
        success: json["success"],
        leave: json["leave"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "leave": leave,
      };
}
