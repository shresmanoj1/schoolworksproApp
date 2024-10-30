// To parse this JSON data, do
//
//     final postMessageResponse = postMessageResponseFromJson(jsonString);

import 'dart:convert';

PostMessageResponse postMessageResponseFromJson(String str) => PostMessageResponse.fromJson(json.decode(str));

String postMessageResponseToJson(PostMessageResponse data) => json.encode(data.toJson());

class PostMessageResponse {
  PostMessageResponse({
    this.success,
    this.message,
  });

  bool ? success;
  String ? message;

  factory PostMessageResponse.fromJson(Map<String, dynamic> json) => PostMessageResponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
