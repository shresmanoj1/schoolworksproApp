// To parse this JSON data, do
//
//     final getBatchForAttendanceResponse = getBatchForAttendanceResponseFromJson(jsonString);

import 'dart:convert';

GetBatchForAttendanceResponse getBatchForAttendanceResponseFromJson(
        String str) =>
    GetBatchForAttendanceResponse.fromJson(json.decode(str));

String getBatchForAttendanceResponseToJson(
        GetBatchForAttendanceResponse data) =>
    json.encode(data.toJson());

class GetBatchForAttendanceResponse {
  GetBatchForAttendanceResponse({
    this.success,
    this.batcharr,
  });

  bool? success;
  List<String>? batcharr;

  factory GetBatchForAttendanceResponse.fromJson(Map<String, dynamic> json) =>
      GetBatchForAttendanceResponse(
        success: json["success"],
        batcharr: List<String>.from(json["batcharr"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "batcharr": List<dynamic>.from(batcharr!.map((x) => x)),
      };
}
