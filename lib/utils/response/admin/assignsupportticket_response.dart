// To parse this JSON data, do
//
//     final assignSupportTicketResponse = assignSupportTicketResponseFromJson(jsonString);

import 'dart:convert';

AssignSupportTicketResponse assignSupportTicketResponseFromJson(String str) =>
    AssignSupportTicketResponse.fromJson(json.decode(str));

String assignSupportTicketResponseToJson(AssignSupportTicketResponse data) =>
    json.encode(data.toJson());

class AssignSupportTicketResponse {
  AssignSupportTicketResponse({
    this.success,
    this.message,
    this.request,
  });

  bool? success;
  String? message;
  dynamic request;

  factory AssignSupportTicketResponse.fromJson(Map<String, dynamic> json) =>
      AssignSupportTicketResponse(
        success: json["success"],
        message: json["message"],
        request: json["request"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "request": request,
      };
}
