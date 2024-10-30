// To parse this JSON data, do
//
//     final addrequestresponse = addrequestresponseFromJson(jsonString);

import 'dart:convert';

Addrequestresponse addrequestresponseFromJson(String str) =>
    Addrequestresponse.fromJson(json.decode(str));

String addrequestresponseToJson(Addrequestresponse data) =>
    json.encode(data.toJson());

class Addrequestresponse {
  Addrequestresponse({
    this.success,
    this.message,

  });

  bool? success;
  String? message;

  factory Addrequestresponse.fromJson(Map<String, dynamic> json) =>
      Addrequestresponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
