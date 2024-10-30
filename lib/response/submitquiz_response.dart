// To parse this JSON data, do
//
//     final submitQuizResponse = submitQuizResponseFromJson(jsonString);

import 'dart:convert';

SubmitQuizResponse submitQuizResponseFromJson(String str) => SubmitQuizResponse.fromJson(json.decode(str));

String submitQuizResponseToJson(SubmitQuizResponse data) => json.encode(data.toJson());

class SubmitQuizResponse {
  bool ?success;
  String ?message;

  SubmitQuizResponse({
    this.success,
    this.message,
  });

  factory SubmitQuizResponse.fromJson(Map<String, dynamic> json) => SubmitQuizResponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
