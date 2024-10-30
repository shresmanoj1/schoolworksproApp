// To parse this JSON data, do
//
//     final markasreadresponse = markasreadresponseFromJson(jsonString);

import 'dart:convert';

Markasreadresponse markasreadresponseFromJson(String str) =>
    Markasreadresponse.fromJson(json.decode(str));

String markasreadresponseToJson(Markasreadresponse data) =>
    json.encode(data.toJson());

class Markasreadresponse {
  Markasreadresponse({
    this.success,
    this.notice,
  });

  bool? success;
  dynamic notice;

  factory Markasreadresponse.fromJson(Map<String, dynamic> json) =>
      Markasreadresponse(
        success: json["success"],
        notice: json["notice"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "notice": notice,
      };
}
