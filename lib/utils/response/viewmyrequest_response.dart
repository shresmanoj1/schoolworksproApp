// To parse this JSON data, do
//
//     final viewmyrequestresponse = viewmyrequestresponseFromJson(jsonString);

import 'dart:convert';

Viewmyrequestresponse viewmyrequestresponseFromJson(String str) =>
    Viewmyrequestresponse.fromJson(json.decode(str));

String viewmyrequestresponseToJson(Viewmyrequestresponse data) =>
    json.encode(data.toJson());

class Viewmyrequestresponse {
  Viewmyrequestresponse({
    this.success,
    this.requests,
  });

  bool? success;
  List<dynamic>? requests;

  factory Viewmyrequestresponse.fromJson(Map<String, dynamic> json) =>
      Viewmyrequestresponse(
        success: json["success"],
        requests: List<dynamic>.from(json["requests"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "requests": List<dynamic>.from(requests!.map((x) => x)),
      };
}

// class Request {
//   Request({
//     this.status,
//     this.requestResponse,
//     this.id,
//     this.request,
//     this.severity,
//     this.topic,
//     this.subject,
//     this.requestFile,
//     this.ticketId,
//     this.institution,
//     this.createdAt,
//     this.updatedAt,
//     this.assignedDate,
//   });
//
//   String? status;
//   List<String>? requestResponse;
//   String? id;
//   String? request;
//   String? severity;
//   String? topic;
//   String? subject;
//   String? requestFile;
//   String? ticketId;
//   String? institution;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   DateTime? assignedDate;
//
//   factory Request.fromJson(Map<String, dynamic> json) => Request(
//         status: json["status"],
//         requestResponse:
//             List<String>.from(json["requestResponse"].map((x) => x)),
//         id: json["_id"],
//         request: json["request"],
//         severity: json["severity"],
//         topic: json["topic"],
//         subject: json["subject"],
//         requestFile: json["requestFile"] == null ? null : json["requestFile"],
//         ticketId: json["ticketId"],
//         institution: json["institution"],
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         assignedDate: json["assignedDate"] == null
//             ? null
//             : DateTime.parse(json["assignedDate"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "requestResponse": List<dynamic>.from(requestResponse!.map((x) => x)),
//         "_id": id,
//         "request": request,
//         "severity": severity,
//         "topic": topic,
//         "subject": subject,
//         "requestFile": requestFile == null ? null : requestFile,
//         "ticketId": ticketId,
//         "institution": institution,
//         "createdAt": createdAt!.toIso8601String(),
//         "updatedAt": updatedAt!.toIso8601String(),
//         "assignedDate":
//             assignedDate == null ? null : assignedDate!.toIso8601String(),
//       };
// }
