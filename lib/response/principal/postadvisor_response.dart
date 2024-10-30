// To parse this JSON data, do
//
//     final postAdvisorResponse = postAdvisorResponseFromJson(jsonString);

import 'dart:convert';

PostAdvisorResponse postAdvisorResponseFromJson(String str) => PostAdvisorResponse.fromJson(json.decode(str));

String postAdvisorResponseToJson(PostAdvisorResponse data) => json.encode(data.toJson());

class PostAdvisorResponse {
  PostAdvisorResponse({
    this.success,
    this.advisor,
  });

  bool ? success;
  dynamic advisor;

  factory PostAdvisorResponse.fromJson(Map<String, dynamic> json) => PostAdvisorResponse(
    success: json["success"],
    advisor: json["advisor"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "advisor": advisor,
  };
}
