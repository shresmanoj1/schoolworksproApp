// To parse this JSON data, do
//
//     final getmodulerequest = getmodulerequestFromJson(jsonString);

import 'dart:convert';

Getmodulerequest getmodulerequestFromJson(String str) => Getmodulerequest.fromJson(json.decode(str));

String getmodulerequestToJson(Getmodulerequest data) => json.encode(data.toJson());

class Getmodulerequest {
  Getmodulerequest({
    this.email,
  });

  String ? email;

  factory Getmodulerequest.fromJson(Map<String, dynamic> json) => Getmodulerequest(
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
  };
}
