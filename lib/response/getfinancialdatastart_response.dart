// To parse this JSON data, do
//
//     final getfinancialdatastart = getfinancialdatastartFromJson(jsonString);

import 'dart:convert';

Getfinancialdatastart getfinancialdatastartFromJson(String str) => Getfinancialdatastart.fromJson(json.decode(str));

String getfinancialdatastartToJson(Getfinancialdatastart data) => json.encode(data.toJson());

class Getfinancialdatastart {
  Getfinancialdatastart({
    this.success,
    this.message,
  });

  bool ? success;
  String ? message;

  factory Getfinancialdatastart.fromJson(Map<String, dynamic> json) => Getfinancialdatastart(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
