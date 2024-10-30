// To parse this JSON data, do
//
//     final postdocumentResponse = postdocumentResponseFromJson(jsonString);

import 'dart:convert';

PostdocumentResponse postdocumentResponseFromJson(String str) =>
    PostdocumentResponse.fromJson(json.decode(str));

String postdocumentResponseToJson(PostdocumentResponse data) =>
    json.encode(data.toJson());

class PostdocumentResponse {
  PostdocumentResponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory PostdocumentResponse.fromJson(Map<String, dynamic> json) =>
      PostdocumentResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
