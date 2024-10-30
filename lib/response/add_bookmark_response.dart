// To parse this JSON data, do
//
//     final addBookMarkResponse = addBookMarkResponseFromJson(jsonString);

import 'dart:convert';

AddBookMarkResponse addBookMarkResponseFromJson(String str) => AddBookMarkResponse.fromJson(json.decode(str));

String addBookMarkResponseToJson(AddBookMarkResponse data) => json.encode(data.toJson());

class AddBookMarkResponse {
  AddBookMarkResponse({
    this.success,
    this.message,
    this.bookmark,
  });

  bool ? success;
  String ? message;
  dynamic bookmark;

  factory AddBookMarkResponse.fromJson(Map<String, dynamic> json) => AddBookMarkResponse(
    success: json["success"],
    message: json["message"],
    bookmark: json["bookmark"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "bookmark": bookmark,
  };
}
