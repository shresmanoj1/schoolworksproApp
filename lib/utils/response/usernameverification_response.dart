// To parse this JSON data, do
//
//     final usernameverificationresponse = usernameverificationresponseFromJson(jsonString);

import 'dart:convert';

Usernameverificationresponse usernameverificationresponseFromJson(String str) =>
    Usernameverificationresponse.fromJson(json.decode(str));

String usernameverificationresponseToJson(Usernameverificationresponse data) =>
    json.encode(data.toJson());

class Usernameverificationresponse {
  Usernameverificationresponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory Usernameverificationresponse.fromJson(Map<String, dynamic> json) =>
      Usernameverificationresponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
