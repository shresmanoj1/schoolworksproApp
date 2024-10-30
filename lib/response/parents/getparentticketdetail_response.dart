// To parse this JSON data, do
//
//     final getparentticketdetailresponse = getparentticketdetailresponseFromJson(jsonString);

import 'dart:convert';

Getparentticketdetailresponse getparentticketdetailresponseFromJson(String str) => Getparentticketdetailresponse.fromJson(json.decode(str));

String getparentticketdetailresponseToJson(Getparentticketdetailresponse data) => json.encode(data.toJson());

class Getparentticketdetailresponse {
  Getparentticketdetailresponse({
    this.success,
    this.request,
  });

  bool ? success;
  Request ? request;

  factory Getparentticketdetailresponse.fromJson(Map<String, dynamic> json) => Getparentticketdetailresponse(
    success: json["success"],
    request: Request.fromJson(json["request"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "request": request?.toJson(),
  };
}

class Request {
  Request({
    this.id,
    this.status,
    this.requestFile,
    this.requestResponse,
    this.subject,
    this.severity,
    this.topic,
    this.request,
    this.ticketId,
    this.postedBy,
    this.createdAt,
    this.updatedAt,
    this.leaves
  });

  String ? id;
  String ? status;
  List<String> ? requestFile;
  List<RequestResponse> ? requestResponse;
  String ? subject;
  String ? severity;
  String ? topic;
  String ? request;
  String ? ticketId;
  PostedBy ? postedBy;
  DateTime ? startDate;
  DateTime ? endDate;
  DateTime ? createdAt;
  DateTime ? updatedAt;
  dynamic leaves;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    id: json["_id"],
    status: json["status"],
    requestFile: List<String>.from(json["requestFile"].map((x) => x)),
    requestResponse: List<RequestResponse>.from(json["requestResponse"].map((x) => RequestResponse.fromJson(x))),
    subject: json["subject"],
    severity: json["severity"],
    topic: json["topic"],
    request: json["request"],
    ticketId: json["ticketId"],
    postedBy: PostedBy.fromJson(json["postedBy"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    leaves: json["leaves"]
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "status": status,
    "requestFile": List<dynamic>.from(requestFile!.map((x) => x)),
    "requestResponse": List<dynamic>.from(requestResponse!.map((x) => x.toJson())),
    "subject": subject,
    "severity": severity,
    "topic": topic,
    "request": request,
    "ticketId": ticketId,
    "postedBy": postedBy?.toJson(),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "leaves": leaves
  };
}

class PostedBy {
  PostedBy({
    this.username,
    this.firstname,
    this.lastname,
  });

  String ? username;
  String ? firstname;
  String ? lastname;

  factory PostedBy.fromJson(Map<String, dynamic> json) => PostedBy(
    username: json["username"],
    firstname: json["firstname"],
    lastname: json["lastname"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "firstname": firstname,
    "lastname": lastname,
  };
}

class RequestResponse {
  RequestResponse({
    this.response,
    this.responseFile,
    this.postedBy,
    this.createdAt,
  });

  String ? response;
  String ? responseFile;
  PostedBy ? postedBy;
  DateTime ? createdAt;

  factory RequestResponse.fromJson(Map<String, dynamic> json) => RequestResponse(
    response: json["response"],
    responseFile: json["responseFile"] == null ? null : json["responseFile"],
    postedBy: PostedBy.fromJson(json["postedBy"]),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "response": response,
    "responseFile": responseFile == null ? null : responseFile,
    "postedBy": postedBy?.toJson(),
    "createdAt": createdAt!.toIso8601String(),
  };
}

class Leaves {
  Leaves();

  factory Leaves.fromJson(Map<String, dynamic> json) => Leaves(
  );

  Map<String, dynamic> toJson() => {
  };
}
