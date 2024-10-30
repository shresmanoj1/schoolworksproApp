// To parse this JSON data, do
//
//     final addticketresponse = addticketresponseFromJson(jsonString);

import 'dart:convert';

Addticketresponse addticketresponseFromJson(String str) =>
    Addticketresponse.fromJson(json.decode(str));

String addticketresponseToJson(Addticketresponse data) =>
    json.encode(data.toJson());

class Addticketresponse {
  Addticketresponse({
    this.success,
    this.ticket,
  });

  bool? success;
  Ticket? ticket;

  factory Addticketresponse.fromJson(Map<String, dynamic> json) =>
      Addticketresponse(
        success: json["success"],
        ticket: Ticket.fromJson(json["ticket"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "ticket": ticket!.toJson(),
      };
}

class Ticket {
  Ticket({
    this.id,
    this.status,
    this.ticketResponse,
    this.assignedTo,
    this.subject,
    this.batch,
    this.firstname,
    this.lastname,
    this.request,
    this.topic,
    this.ticketId,
    this.createdAt,
  });

  String? id;
  String? status;
  List<TicketResponse>? ticketResponse;
  String? assignedTo;
  String? subject;
  String? batch;
  String? firstname;
  String? lastname;
  String? request;
  String? topic;
  String? ticketId;
  DateTime? createdAt;

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json["_id"],
        status: json["status"],
        ticketResponse: List<TicketResponse>.from(
            json["ticketResponse"].map((x) => TicketResponse.fromJson(x))),
        assignedTo: json["assignedTo"],
        subject: json["subject"],
        batch: json["batch"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        request: json["request"],
        topic: json["topic"],
        ticketId: json["ticketId"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
        "ticketResponse":
            List<dynamic>.from(ticketResponse!.map((x) => x.toJson())),
        "assignedTo": assignedTo,
        "subject": subject,
        "batch": batch,
        "firstname": firstname,
        "lastname": lastname,
        "request": request,
        "topic": topic,
        "ticketId": ticketId,
        "createdAt": createdAt!.toIso8601String(),
      };
}

class TicketResponse {
  TicketResponse({
    this.response,
    this.responseFile,
    this.postedBy,
    this.createdAt,
  });

  String? response;
  String? responseFile;
  PostedBy? postedBy;
  DateTime? createdAt;

  factory TicketResponse.fromJson(Map<String, dynamic> json) => TicketResponse(
        response: json["response"],
        responseFile:
            json["responseFile"] == null ? null : json["responseFile"],
        postedBy: PostedBy.fromJson(json["postedBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "responseFile": responseFile == null ? null : responseFile,
        "postedBy": postedBy!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
      };
}

class PostedBy {
  PostedBy({
    this.type,
    this.username,
    this.firstname,
    this.lastname,
  });

  String? type;
  String? username;
  String? firstname;
  String? lastname;

  factory PostedBy.fromJson(Map<String, dynamic> json) => PostedBy(
        type: json["type"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
      };
}
