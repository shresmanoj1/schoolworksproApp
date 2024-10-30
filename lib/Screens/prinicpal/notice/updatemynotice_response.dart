// To parse this JSON data, do
//
//     final updateNoticeResponse = updateNoticeResponseFromJson(jsonString);

import 'dart:convert';

UpdateNoticeResponse updateNoticeResponseFromJson(String str) =>
    UpdateNoticeResponse.fromJson(json.decode(str));

String updateNoticeResponseToJson(UpdateNoticeResponse data) =>
    json.encode(data.toJson());

class UpdateNoticeResponse {
  UpdateNoticeResponse({
    this.success,
    this.message,
    this.notice,
  });

  bool? success;
  String? message;
  dynamic notice;

  factory UpdateNoticeResponse.fromJson(Map<String, dynamic> json) =>
      UpdateNoticeResponse(
        success: json["success"],
        message: json["message"],
        notice: json["notice"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "notice": notice,
      };
}
