// To parse this JSON data, do
//
//     final forgetpasswordresponse = forgetpasswordresponseFromJson(jsonString);

import 'dart:convert';

Forgetpasswordresponse forgetpasswordresponseFromJson(String str) =>
    Forgetpasswordresponse.fromJson(json.decode(str));

String forgetpasswordresponseToJson(Forgetpasswordresponse data) =>
    json.encode(data.toJson());

class Forgetpasswordresponse {
  Forgetpasswordresponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory Forgetpasswordresponse.fromJson(Map<String, dynamic> json) =>
      Forgetpasswordresponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
