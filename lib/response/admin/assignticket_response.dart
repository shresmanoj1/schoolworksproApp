// To parse this JSON data, do
//
//     final assignTicketResponse = assignTicketResponseFromJson(jsonString);

import 'dart:convert';

AssignTicketResponse assignTicketResponseFromJson(String str) => AssignTicketResponse.fromJson(json.decode(str));

String assignTicketResponseToJson(AssignTicketResponse data) => json.encode(data.toJson());

class AssignTicketResponse {
  AssignTicketResponse({
    this.success,
    this.request,
    this.assignedTo,
    this.assignedBy,
  });

  bool ? success;
  dynamic request;
  dynamic assignedTo;
  dynamic assignedBy;

  factory AssignTicketResponse.fromJson(Map<String, dynamic> json) => AssignTicketResponse(
    success: json["success"],
    request: json["request"],
    assignedTo: json["assignedTo"],
    assignedBy: json["assignedBy"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "request": request,
    "assignedTo": assignedTo,
    "assignedBy": assignedBy,
  };
}
