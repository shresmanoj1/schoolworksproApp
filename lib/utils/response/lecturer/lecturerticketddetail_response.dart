// To parse this JSON data, do
//
//     final lecturerRequestdetailResponse = lecturerRequestdetailResponseFromJson(jsonString);

import 'dart:convert';

LecturerRequestdetailResponse lecturerRequestdetailResponseFromJson(
        String str) =>
    LecturerRequestdetailResponse.fromJson(json.decode(str));

String lecturerRequestdetailResponseToJson(
        LecturerRequestdetailResponse data) =>
    json.encode(data.toJson());

class LecturerRequestdetailResponse {
  LecturerRequestdetailResponse({
    this.success,
    this.request,
  });

  bool? success;
  dynamic request;

  factory LecturerRequestdetailResponse.fromJson(Map<String, dynamic> json) =>
      LecturerRequestdetailResponse(
        success: json["success"],
        request: json["request"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "request": request,
      };
}

class Request {
  Request({
    this.id,
    this.status,
    this.requestFile,
    this.requestResponse,
    this.subject,
    this.topic,
    this.request,
    this.severity,
    this.assignedTo,
    this.assignedDate,
    this.ticketId,
    this.postedBy,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? status;
  List<dynamic>? requestFile;
  List<RequestResponse>? requestResponse;
  String? subject;
  String? topic;
  String? request;
  String? severity;
  AssignedTo? assignedTo;
  DateTime? assignedDate;
  String? ticketId;
  AssignedTo? postedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        id: json["_id"],
        status: json["status"],
        requestFile: List<dynamic>.from(json["requestFile"].map((x) => x)),
        requestResponse: List<RequestResponse>.from(
            json["requestResponse"].map((x) => RequestResponse.fromJson(x))),
        subject: json["subject"],
        topic: json["topic"],
        request: json["request"],
        severity: json["severity"],
        assignedTo: AssignedTo.fromJson(json["assignedTo"]),
        assignedDate: DateTime.parse(json["assignedDate"]),
        ticketId: json["ticketId"],
        postedBy: AssignedTo.fromJson(json["postedBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
        "requestFile": List<dynamic>.from(requestFile!.map((x) => x)),
        "requestResponse":
            List<dynamic>.from(requestResponse!.map((x) => x.toJson())),
        "subject": subject,
        "topic": topic,
        "request": request,
        "severity": severity,
        "assignedTo": assignedTo?.toJson(),
        "assignedDate": assignedDate?.toIso8601String(),
        "ticketId": ticketId,
        "postedBy": postedBy?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class AssignedTo {
  AssignedTo({
    this.firstname,
    this.lastname,
    this.username,
  });

  String? firstname;
  String? lastname;
  String? username;

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

class RequestResponse {
  RequestResponse({
    this.response,
    this.responseFile,
    this.postedBy,
    this.createdAt,
  });

  String? response;
  String? responseFile;
  AssignedTo? postedBy;
  DateTime? createdAt;

  factory RequestResponse.fromJson(Map<String, dynamic> json) =>
      RequestResponse(
        response: json["response"],
        responseFile: json["responseFile"],
        postedBy: AssignedTo.fromJson(json["postedBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "responseFile": responseFile,
        "postedBy": postedBy?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
      };
}
