// To parse this JSON data, do
//
//     final postMessageRequest = postMessageRequestFromJson(jsonString);

import 'dart:convert';

PostMessageRequest postMessageRequestFromJson(String str) =>
    PostMessageRequest.fromJson(json.decode(str));

String postMessageRequestToJson(PostMessageRequest data) =>
    json.encode(data.toJson());

class PostMessageRequest {
  PostMessageRequest({
    this.message,
    this.to,
  });

  String? message;
  String? to;

  factory PostMessageRequest.fromJson(Map<String, dynamic> json) =>
      PostMessageRequest(
        message: json["message"],
        to: json["to"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "to": to,
      };
}
