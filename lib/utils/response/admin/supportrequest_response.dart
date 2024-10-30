// To parse this JSON data, do
//
//     final supportRequestResponse = supportRequestResponseFromJson(jsonString);

import 'dart:convert';

SupportRequestResponse supportRequestResponseFromJson(String str) =>
    SupportRequestResponse.fromJson(json.decode(str));

String supportRequestResponseToJson(SupportRequestResponse data) =>
    json.encode(data.toJson());

class SupportRequestResponse {
  SupportRequestResponse({
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

  factory SupportRequestResponse.fromJson(Map<String, dynamic> json) =>
      SupportRequestResponse(
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
//
// class Request {
//   Request({
//     this.id,
//     this.status,
//     this.request,
//     this.topic,
//     this.attachments,
//     this.severity,
//     this.ticketId,
//     this.postedBy,
//     this.assignedTo,
//     this.createdAt,
//     this.updatedAt,
//     this.assignedDate,
//   });
//
//   String id;
//   String status;
//   String request;
//   String topic;
//   String attachments;
//   String severity;
//   String ticketId;
//   AssignedTo postedBy;
//   AssignedTo assignedTo;
//   DateTime createdAt;
//   DateTime updatedAt;
//   DateTime assignedDate;
//
//   factory Request.fromJson(Map<String, dynamic> json) => Request(
//     id: json["_id"],
//     status: json["status"],
//     request: json["request"],
//     topic: json["topic"],
//     attachments: json["attachments"],
//     severity: json["severity"],
//     ticketId: json["ticketId"],
//     postedBy: AssignedTo.fromJson(json["postedBy"]),
//     assignedTo: AssignedTo.fromJson(json["assignedTo"]),
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     assignedDate: DateTime.parse(json["assignedDate"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "status": status,
//     "request": request,
//     "topic": topic,
//     "attachments": attachments,
//     "severity": severity,
//     "ticketId": ticketId,
//     "postedBy": postedBy.toJson(),
//     "assignedTo": assignedTo.toJson(),
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "assignedDate": assignedDate.toIso8601String(),
//   };
// }
//
// class AssignedTo {
//   AssignedTo({
//     this.firstname,
//     this.lastname,
//     this.username,
//     this.institution,
//   });
//
//   String firstname;
//   String lastname;
//   String username;
//   String institution;
//
//   factory AssignedTo.fromJson(Map<String, dynamic> json) => AssignedTo(
//     firstname: json["firstname"],
//     lastname: json["lastname"],
//     username: json["username"],
//     institution: json["institution"] == null ? null : json["institution"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "firstname": firstname,
//     "lastname": lastname,
//     "username": username,
//     "institution": institution == null ? null : institution,
//   };
// }
