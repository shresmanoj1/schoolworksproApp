// To parse this JSON data, do
//
//     final passwordupdateresponse = passwordupdateresponseFromJson(jsonString);

import 'dart:convert';

Passwordupdateresponse passwordupdateresponseFromJson(String str) =>
    Passwordupdateresponse.fromJson(json.decode(str));

String passwordupdateresponseToJson(Passwordupdateresponse data) =>
    json.encode(data.toJson());

class Passwordupdateresponse {
  Passwordupdateresponse({
    this.message,
    this.success,
  });

  String? message;
  bool? success;

  factory Passwordupdateresponse.fromJson(Map<String, dynamic> json) =>
      Passwordupdateresponse(
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
      };
}
