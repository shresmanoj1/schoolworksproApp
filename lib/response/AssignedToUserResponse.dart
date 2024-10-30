// To parse this JSON data, do
//
//     final assignedToUserResponse = assignedToUserResponseFromJson(jsonString);

import 'dart:convert';

AssignedToUserResponse assignedToUserResponseFromJson(String str) => AssignedToUserResponse.fromJson(json.decode(str));

String assignedToUserResponseToJson(AssignedToUserResponse data) => json.encode(data.toJson());

class AssignedToUserResponse {
  bool? success;
  num? approved;
  num? pending;
  num? resolved;
  num? backlog;
  List<Request>? requests;

  AssignedToUserResponse({
    this.success,
    this.approved,
    this.pending,
    this.resolved,
    this.backlog,
    this.requests,
  });

  factory AssignedToUserResponse.fromJson(Map<String, dynamic> json) => AssignedToUserResponse(
    success: json["success"],
    approved: json["approved"],
    pending: json["pending"],
    resolved: json["resolved"],
    backlog: json["backlog"],
    requests: List<Request>.from(json["requests"].map((x) => Request.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "approved": approved,
    "pending": pending,
    "resolved": resolved,
    "backlog": backlog,
    "requests": List<dynamic>.from(requests!.map((x) => x.toJson())),
  };
}

class Request {
  String? id;
  String? status;
  List<dynamic>? requestFile;
  String? request;
  String? severity;
  String? topic;
  String? subject;
  AssignedTo? assignedTo;
  String? ticketId;
  AssignedTo? postedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Request({
    this.id,
    this.status,
    this.requestFile,
    this.request,
    this.severity,
    this.topic,
    this.subject,
    this.assignedTo,
    this.ticketId,
    this.postedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    id: json["_id"],
    status: json["status"],
    requestFile: List<dynamic>.from(json["requestFile"].map((x) => x)),
    request: json["request"],
    severity: json["severity"],
    topic: json["topic"],
    subject: json["subject"],
    assignedTo: AssignedTo.fromJson(json["assignedTo"]),
    ticketId: json["ticketId"],
    postedBy: AssignedTo.fromJson(json["postedBy"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "status": status,
    "requestFile": List<dynamic>.from(requestFile!.map((x) => x)),
    "request": request,
    "severity": severity,
    "topic": topic,
    "subject": subject,
    "assignedTo": assignedTo?.toJson(),
    "ticketId": ticketId,
    "postedBy": postedBy?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class AssignedTo {
  String? firstname;
  String? lastname;
  String? username;

  AssignedTo({
    this.firstname,
    this.lastname,
    this.username,
  });

  factory AssignedTo.fromJson(Map<String, dynamic> json) => AssignedTo(
    firstname: json["firstname"],
    lastname: json["lastname"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
  };
}
