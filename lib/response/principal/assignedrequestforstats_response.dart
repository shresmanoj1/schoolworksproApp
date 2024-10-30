// To parse this JSON data, do
//
//     final assignedRequestForStatsResponse = assignedRequestForStatsResponseFromJson(jsonString);

import 'dart:convert';

AssignedRequestForStatsResponse assignedRequestForStatsResponseFromJson(
        String str) =>
    AssignedRequestForStatsResponse.fromJson(json.decode(str));

String assignedRequestForStatsResponseToJson(
        AssignedRequestForStatsResponse data) =>
    json.encode(data.toJson());

class AssignedRequestForStatsResponse {
  AssignedRequestForStatsResponse({
    this.success,
    this.requests,
    this.approved,
    this.pending,
    this.resolved,
    this.backlog,
  });

  bool? success;
  List<dynamic>? requests;
  int? approved;
  int? pending;
  int? resolved;
  int? backlog;

  factory AssignedRequestForStatsResponse.fromJson(Map<String, dynamic> json) =>
      AssignedRequestForStatsResponse(
        success: json["success"],
        requests: List<dynamic>.from(json["requests"].map((x) => x)),
        approved: json["approved"],
        pending: json["pending"],
        resolved: json["resolved"],
        backlog: json["backlog"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "requests": List<dynamic>.from(requests!.map((x) => x)),
        "approved": approved,
        "pending": pending,
        "resolved": resolved,
        "backlog": backlog,
      };
}
