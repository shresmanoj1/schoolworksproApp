// To parse this JSON data, do
//
//     final overtimeForStatsResponse = overtimeForStatsResponseFromJson(jsonString);

import 'dart:convert';

OvertimeForStatsResponse overtimeForStatsResponseFromJson(String str) => OvertimeForStatsResponse.fromJson(json.decode(str));

String overtimeForStatsResponseToJson(OvertimeForStatsResponse data) => json.encode(data.toJson());

class OvertimeForStatsResponse {
  OvertimeForStatsResponse({
    this.success,
    this.pendingCount,
    this.approvedCount,
    this.deniedCount,
    this.overtime,
  });

  bool ? success;
  int ? pendingCount;
  int ? approvedCount;
  int ? deniedCount;
  List<dynamic> ? overtime;

  factory OvertimeForStatsResponse.fromJson(Map<String, dynamic> json) => OvertimeForStatsResponse(
    success: json["success"],
    pendingCount: json["pendingCount"],
    approvedCount: json["approvedCount"],
    deniedCount: json["deniedCount"],
    overtime: List<dynamic>.from(json["overtime"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "pendingCount": pendingCount,
    "approvedCount": approvedCount,
    "deniedCount": deniedCount,
    "overtime": List<dynamic>.from(overtime!.map((x) => x)),
  };
}
