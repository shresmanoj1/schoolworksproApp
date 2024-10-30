// To parse this JSON data, do
//
//     final adminMyRequestResponse = adminMyRequestResponseFromJson(jsonString);

import 'dart:convert';

AdminMyRequestResponse adminMyRequestResponseFromJson(String str) =>
    AdminMyRequestResponse.fromJson(json.decode(str));

String adminMyRequestResponseToJson(AdminMyRequestResponse data) =>
    json.encode(data.toJson());

class AdminMyRequestResponse {
  AdminMyRequestResponse({
    this.success,
    this.requests,
  });

  bool? success;
  List<dynamic>? requests;

  factory AdminMyRequestResponse.fromJson(Map<String, dynamic> json) =>
      AdminMyRequestResponse(
        success: json["success"],
        requests: List<dynamic>.from(json["requests"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "requests": List<dynamic>.from(requests!.map((x) => x.toJson())),
      };
}
//
// class Request {
//   Request({
//     this.status,
//     this.requestFile,
//     this.requestResponse,
//     this.id,
//     this.request,
//     this.severity,
//     this.topic,
//     this.subject,
//     this.assignedDate,
//     this.ticketId,
//     this.institution,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   Status status;
//   List<String> requestFile;
//   List<String> requestResponse;
//   String id;
//   String request;
//   Severity severity;
//   String topic;
//   Subject subject;
//   DateTime assignedDate;
//   String ticketId;
//   Institution institution;
//   DateTime createdAt;
//   DateTime updatedAt;
//
//   factory Request.fromJson(Map<String, dynamic> json) => Request(
//     status: statusValues.map[json["status"]],
//     requestFile: List<String>.from(json["requestFile"].map((x) => x)),
//     requestResponse: List<String>.from(json["requestResponse"].map((x) => x)),
//     id: json["_id"],
//     request: json["request"],
//     severity: severityValues.map[json["severity"]],
//     topic: json["topic"],
//     subject: subjectValues.map[json["subject"]],
//     assignedDate: json["assignedDate"] == null ? null : DateTime.parse(json["assignedDate"]),
//     ticketId: json["ticketId"],
//     institution: institutionValues.map[json["institution"]],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": statusValues.reverse[status],
//     "requestFile": List<dynamic>.from(requestFile.map((x) => x)),
//     "requestResponse": List<dynamic>.from(requestResponse.map((x) => x)),
//     "_id": id,
//     "request": request,
//     "severity": severityValues.reverse[severity],
//     "topic": topic,
//     "subject": subjectValues.reverse[subject],
//     "assignedDate": assignedDate == null ? null : assignedDate.toIso8601String(),
//     "ticketId": ticketId,
//     "institution": institutionValues.reverse[institution],
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//   };
// }
//
// enum Institution { DIGITECH }
//
// final institutionValues = EnumValues({
//   "digitech": Institution.DIGITECH
// });
//
// enum Severity { HIGH, CRITICAL, MEDIUM, LOW }
//
// final severityValues = EnumValues({
//   "Critical": Severity.CRITICAL,
//   "High": Severity.HIGH,
//   "Low": Severity.LOW,
//   "Medium": Severity.MEDIUM
// });
//
// enum Status { PENDING, RESOLVED, BACKLOG }
//
// final statusValues = EnumValues({
//   "Backlog": Status.BACKLOG,
//   "Pending": Status.PENDING,
//   "Resolved": Status.RESOLVED
// });
//
// enum Subject { UPDATE, LEAVE, NEW_FEATURE }
//
// final subjectValues = EnumValues({
//   "Leave": Subject.LEAVE,
//   "New Feature": Subject.NEW_FEATURE,
//   "Update": Subject.UPDATE
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
