// To parse this JSON data, do
//
//     final referralDetailsRequest = referralDetailsRequestFromJson(jsonString);

import 'dart:convert';

SubmitQuizRequest SubmitQuizRequestFromJson(String str) =>
    SubmitQuizRequest.fromJson(json.decode(str));

String SubmitQuizRequestToJson(SubmitQuizRequest data) =>
    json.encode(data.toJson());

class SubmitQuizRequest {
  SubmitQuizRequest({
    this.message,
    this.success,
  });

  String? message;

  bool? success;

  factory SubmitQuizRequest.fromJson(Map<String, dynamic> json) =>
      SubmitQuizRequest(
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
      };
}
