// To parse this JSON data, do
//
//     final adminNoticeResponse = adminNoticeResponseFromJson(jsonString);

import 'dart:convert';

import '../principal/newsannouncement_response.dart';


AdminNoticeResponse adminNoticeResponseFromJson(String str) => AdminNoticeResponse.fromJson(json.decode(str));

String adminNoticeResponseToJson(AdminNoticeResponse data) => json.encode(data.toJson());

class AdminNoticeResponse {
  final bool ? success;
  final int ? count;
  final List<dynamic> ? notices;

  AdminNoticeResponse({
    this.success,
    this.count,
    this.notices,
  });

  factory AdminNoticeResponse.fromJson(Map<String, dynamic> json) => AdminNoticeResponse(
    success: json["success"],
    count: json["count"],
    notices: json["notices"] == null ? [] : List<dynamic>.from(json["notices"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "notices": List<dynamic>.from(notices!.map((x) => x)),
  };
}
