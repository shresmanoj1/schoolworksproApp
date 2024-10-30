// To parse this JSON data, do
//
//     final commonresponse = commonresponseFromJson(jsonString);

import 'dart:convert';

Commonresponse commonresponseFromJson(String str) => Commonresponse.fromJson(json.decode(str));

String commonresponseToJson(Commonresponse data) => json.encode(data.toJson());

class Commonresponse {
  Commonresponse({
    this.success,
    this.message,
  });

  bool ? success;
  String ? message;

  factory Commonresponse.fromJson(Map<String, dynamic> json) => Commonresponse(
    success: json["success"],
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message
  };
}
