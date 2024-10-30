// To parse this JSON data, do
//
//     final adminRequestResponse = adminRequestResponseFromJson(jsonString);

import 'dart:convert';

AdminRequestResponse adminRequestResponseFromJson(String str) =>
    AdminRequestResponse.fromJson(json.decode(str));

String adminRequestResponseToJson(AdminRequestResponse data) =>
    json.encode(data.toJson());

class AdminRequestResponse {
  AdminRequestResponse({
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

  factory AdminRequestResponse.fromJson(Map<String, dynamic> json) =>
      AdminRequestResponse(
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
