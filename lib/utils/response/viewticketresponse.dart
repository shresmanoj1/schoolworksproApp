// To parse this JSON data, do
//
//     final viewticketresponse = viewticketresponseFromJson(jsonString);

import 'dart:convert';

Viewticketresponse viewticketresponseFromJson(String str) =>
    Viewticketresponse.fromJson(json.decode(str));

String viewticketresponseToJson(Viewticketresponse data) =>
    json.encode(data.toJson());

class Viewticketresponse {
  Viewticketresponse({
    this.success,
    this.tickets,
  });

  bool? success;
  List<Ticket>? tickets;

  factory Viewticketresponse.fromJson(Map<String, dynamic> json) =>
      Viewticketresponse(
        success: json["success"],
        tickets:
            List<Ticket>.from(json["tickets"].map((x) => Ticket.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "tickets": List<dynamic>.from(tickets!.map((x) => x.toJson())),
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
    this.postedBy,
    this.createdAt,
    this.responseFile,
  });

  String? response;
  PostedBy? postedBy;
  DateTime? createdAt;
  String? responseFile;

  factory TicketResponse.fromJson(Map<String, dynamic> json) => TicketResponse(
        response: json["response"],
        postedBy: PostedBy.fromJson(json["postedBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
        responseFile:
            json["responseFile"] == null ? null : json["responseFile"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "postedBy": postedBy!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
        "responseFile": responseFile == null ? null : responseFile,
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
