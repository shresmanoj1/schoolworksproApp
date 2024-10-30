// To parse this JSON data, do
//
//     final postQuizAnswerResponse = postQuizAnswerResponseFromJson(jsonString);

import 'dart:convert';

PostQuizAnswerResponse postQuizAnswerResponseFromJson(String str) => PostQuizAnswerResponse.fromJson(json.decode(str));

String postQuizAnswerResponseToJson(PostQuizAnswerResponse data) => json.encode(data.toJson());

class PostQuizAnswerResponse {
  bool ?success;
  String ?message;

  PostQuizAnswerResponse({
    this.success,
    this.message,
  });

  factory PostQuizAnswerResponse.fromJson(Map<String, dynamic> json) => PostQuizAnswerResponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
