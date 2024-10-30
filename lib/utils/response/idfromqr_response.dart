// To parse this JSON data, do
//
//     final idRequestFromQr = idRequestFromQrFromJson(jsonString);

import 'dart:convert';

IdRequestFromQr idRequestFromQrFromJson(String str) => IdRequestFromQr.fromJson(json.decode(str));

String idRequestFromQrToJson(IdRequestFromQr data) => json.encode(data.toJson());

class IdRequestFromQr {
  IdRequestFromQr({
    this.username,
    this.institution,
  });

  String ? username;
  String ? institution;

  factory IdRequestFromQr.fromJson(Map<String, dynamic> json) => IdRequestFromQr(
    username: json["username"],
    institution: json["institution"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "institution": institution,
  };
}
