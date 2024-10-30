// To parse this JSON data, do
//
//     final supportstaffResponse = supportstaffResponseFromJson(jsonString);

import 'dart:convert';

SupportstaffResponse supportstaffResponseFromJson(String str) =>
    SupportstaffResponse.fromJson(json.decode(str));

String supportstaffResponseToJson(SupportstaffResponse data) =>
    json.encode(data.toJson());

class SupportstaffResponse {
  SupportstaffResponse({
    this.success,
    this.message,
    this.staffs,
  });

  bool? success;
  String? message;
  List<dynamic> ? staffs;

  factory SupportstaffResponse.fromJson(Map<String, dynamic> json) =>
      SupportstaffResponse(
        success: json["success"],
        message: json["message"],
        staffs: List<dynamic>.from(json["staffs"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {

        "success": success,
        "message": message,
        "staffs": List<dynamic>.from(staffs!.map((x) => x.toJson())),
      };
}
