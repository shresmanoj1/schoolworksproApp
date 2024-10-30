// To parse this JSON data, do
//
//     final fcmTokenResponse = fcmTokenResponseFromJson(jsonString);

import 'dart:convert';

FcmTokenResponse fcmTokenResponseFromJson(String str) =>
    FcmTokenResponse.fromJson(json.decode(str));

String fcmTokenResponseToJson(FcmTokenResponse data) =>
    json.encode(data.toJson());

class FcmTokenResponse {
  FcmTokenResponse({
    this.success,
    this.message,
  });

  bool ? success;
  String ? message;

  factory FcmTokenResponse.fromJson(Map<String, dynamic> json) =>
      FcmTokenResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}