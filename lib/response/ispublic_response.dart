// To parse this JSON data, do
//
//     final publicresponse = publicresponseFromJson(jsonString);

import 'dart:convert';

Publicresponse publicresponseFromJson(String str) => Publicresponse.fromJson(json.decode(str));

String publicresponseToJson(Publicresponse data) => json.encode(data.toJson());

class Publicresponse {
  Publicresponse({
    this.success,
    this.message,
  });

  bool ?success;
  String ?message;

  factory Publicresponse.fromJson(Map<String, dynamic> json) => Publicresponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
