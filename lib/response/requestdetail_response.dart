// To parse this JSON data, do
//
//     final requestdetailresponse = requestdetailresponseFromJson(jsonString);

import 'dart:convert';

Requestdetailresponse requestdetailresponseFromJson(String str) =>
    Requestdetailresponse.fromJson(json.decode(str));

String requestdetailresponseToJson(Requestdetailresponse data) =>
    json.encode(data.toJson());

class Requestdetailresponse {
  Requestdetailresponse({
    this.success,
    this.request,
  });

  bool? success;
  Request? request;

  factory Requestdetailresponse.fromJson(Map<String, dynamic> json) =>
      Requestdetailresponse(
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
    this.request,
    this.severity,
    this.topic,
    this.subject,
    this.ticketId,
    this.postedBy,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? status;
  List<dynamic>? requestFile;
  List<RequestResponse>? requestResponse;
  String? request;
  String? severity;
  String? topic;
  String? subject;
  String? ticketId;
  PostedBy? postedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        id: json["_id"] ?? '',
        status: json["status"] ?? '',
        requestFile: json["requestFile"] == null
            ? []
            : List<dynamic>.from(json["requestFile"].map((x) => x)),
        requestResponse: json["requestResponse"] == null
            ? []
            : List<RequestResponse>.from(json["requestResponse"]
                .map((x) => RequestResponse.fromJson(x))),
        request: json["request"] ?? '',
        severity: json["severity"] ?? '',
        topic: json["topic"] ?? '',
        subject: json["subject"] ?? '',
        ticketId: json["ticketId"] ?? '',
        postedBy: json["postedBy"] == null
            ? null
            : PostedBy.fromJson(json["postedBy"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
        "requestFile": List<dynamic>.from(requestFile!.map((x) => x)),
        "requestResponse":
            List<dynamic>.from(requestResponse!.map((x) => x.toJson())),
        "request": request,
        "severity": severity,
        "topic": topic,
        "subject": subject,
        "ticketId": ticketId,
        "postedBy": postedBy?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class PostedBy {
  PostedBy({
    this.username,
    this.firstname,
    this.lastname,
    this.userImage,
  });

  String? username;
  String? firstname;
  String? lastname;
  String? userImage;

  factory PostedBy.fromJson(Map<String, dynamic> json) => PostedBy(
        username: json["username"] ?? '',
        firstname: json["firstname"] ?? '',
        lastname: json["lastname"] ?? '',
        userImage: json["userImage"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "userImage": userImage,
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
  PostedBy? postedBy;
  DateTime? createdAt;

  factory RequestResponse.fromJson(Map<String, dynamic> json) =>
      RequestResponse(
        response: json["response"] ?? '',
        responseFile:
            json["responseFile"] == null ? null : json["responseFile"],
        postedBy: PostedBy.fromJson(json["postedBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "responseFile": responseFile == null ? null : responseFile,
        "postedBy": postedBy?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
      };
}
