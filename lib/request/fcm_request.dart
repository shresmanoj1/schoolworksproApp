// To parse this JSON data, do
//
//     final fcmTokenRequest = fcmTokenRequestFromJson(jsonString);

import 'dart:convert';

FcmTokenRequest fcmTokenRequestFromJson(String str) =>
    FcmTokenRequest.fromJson(json.decode(str));

String fcmTokenRequestToJson(FcmTokenRequest data) =>
    json.encode(data.toJson());

class FcmTokenRequest {
  FcmTokenRequest({
    this.token,
    this.username,
    this.type,
    this.institution,
    this.batch,
  });

  String? token;
  String? username;
  String? type;
  String? institution;
  String? batch;

  factory FcmTokenRequest.fromJson(Map<String, dynamic> json) =>
      FcmTokenRequest(
        token: json["token"],
        username: json["username"],
        type: json["type"],
        institution: json["institution"],
        batch: json["batch"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "username": username,
        "type": type,
        "institution": institution,
        "batch": batch,
      };
}
