// To parse this JSON data, do
//
//     final addprojectresponse = addprojectresponseFromJson(jsonString);

import 'dart:convert';

Addprojectresponse addprojectresponseFromJson(String str) =>
    Addprojectresponse.fromJson(json.decode(str));

String addprojectresponseToJson(Addprojectresponse data) =>
    json.encode(data.toJson());

class Addprojectresponse {
  Addprojectresponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory Addprojectresponse.fromJson(Map<String, dynamic> json) =>
      Addprojectresponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
