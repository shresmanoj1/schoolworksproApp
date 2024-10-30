import 'dart:convert';

LecturerRequestResponse lecturerRequestResponseFromJson(String str) =>
    LecturerRequestResponse.fromJson(json.decode(str));

String lecturerRequestResponseToJson(LecturerRequestResponse data) =>
    json.encode(data.toJson());

class LecturerRequestResponse {
  LecturerRequestResponse({
    this.success,
    this.requests,
  });

  bool? success;
  List<Request>? requests;

  factory LecturerRequestResponse.fromJson(Map<String, dynamic> json) =>
      LecturerRequestResponse(
        success: json["success"],
        requests: List<Request>.from(
            json["requests"].map((x) => Request.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "requests": List<dynamic>.from(requests!.map((x) => x.toJson())),
  };
}

class Request {
  Request({
    this.status,
    this.requestFile,
    this.requestResponse,
    this.id,
    this.subject,
    this.topic,
    this.request,
    this.severity,
    this.assignedDate,
    this.ticketId,
    this.institution,
    this.createdAt,
    this.updatedAt,
  });

  String? status;
  List<dynamic>? requestFile;
  List<String>? requestResponse;
  String? id;
  String? subject;
  String? topic;
  String? request;
  String? severity;
  DateTime? assignedDate;
  String? ticketId;
  String? institution;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    status: json["status"] == null ? null : json["status"],
    requestFile: json["requestFile"] == null ? null : List<dynamic>.from(json["requestFile"].map((x) => x)),
    requestResponse:
    json["requestResponse"] == null ? null :
    List<String>.from(json["requestResponse"].map((x) => x)),
    id: json["_id"] == null ? null : json["_id"],
    subject: json["subject"] == null ? null : json["subject"],
    topic: json["topic"] == null ? null : json["topic"],
    request: json["request"] == null ? null : json["request"],
    severity: json["severity"] == null ? null : json["severity"],
    assignedDate: json["assignedDate"] == null ? null : DateTime.parse(json["assignedDate"]),
    ticketId: json["ticketId"] == null ? null : json["ticketId"],
    institution: json["institution"] == null ? null : json["institution"],
    createdAt: json["createdAt"] == null ? null :  DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "requestFile": requestFile == null ? null : List<dynamic>.from(requestFile!.map((x) => x)),
    "requestResponse": requestResponse == null ? null : List<dynamic>.from(requestResponse!.map((x) => x)),
    "_id": id == null ? null : id,
    "subject": subject == null ? null : subject,
    "topic": topic == null ? null : topic,
    "request": request == null ? null : request,
    "severity": severity == null ? null : severity,
    "assignedDate": assignedDate == null ? null : assignedDate?.toIso8601String(),
    "ticketId": ticketId == null ? null : ticketId,
    "institution": institution == null ? null : institution,
    "createdAt": createdAt == null ? null : createdAt?.toIso8601String(),
    "updatedAt": updatedAt == null ? null : updatedAt?.toIso8601String(),
  };
}
