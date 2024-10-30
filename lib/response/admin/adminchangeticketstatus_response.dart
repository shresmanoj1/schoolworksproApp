// To parse this JSON data, do
//
//     final adminChangeTicketStatusResponse = adminChangeTicketStatusResponseFromJson(jsonString);

import 'dart:convert';

AdminChangeTicketStatusResponse adminChangeTicketStatusResponseFromJson(
        String str) =>
    AdminChangeTicketStatusResponse.fromJson(json.decode(str));

String adminChangeTicketStatusResponseToJson(
        AdminChangeTicketStatusResponse data) =>
    json.encode(data.toJson());

class AdminChangeTicketStatusResponse {
  AdminChangeTicketStatusResponse({
    this.success,
    this.request,
  });

  bool? success;
  dynamic request;

  factory AdminChangeTicketStatusResponse.fromJson(Map<String, dynamic> json) =>
      AdminChangeTicketStatusResponse(
        success: json["success"],
        request: json["request"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "request": request,
      };
}
