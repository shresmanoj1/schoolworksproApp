// To parse this JSON data, do
//
//     final adminEventResponse = adminEventResponseFromJson(jsonString);

import 'dart:convert';

AdminEventResponse adminEventResponseFromJson(String str) =>
    AdminEventResponse.fromJson(json.decode(str));

String adminEventResponseToJson(AdminEventResponse data) =>
    json.encode(data.toJson());

class AdminEventResponse {
  AdminEventResponse({
    this.success,
    this.events,
  });

  bool? success;
  List<dynamic>? events;

  factory AdminEventResponse.fromJson(Map<String, dynamic> json) =>
      AdminEventResponse(
        success: json["success"],
        events: List<dynamic>.from(json["events"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "events": List<dynamic>.from(events!.map((x) => x)),
      };
}
//
// class Event {
//   Event({
//     this.isPublic,
//     this.id,
//     this.startDate,
//     this.endDate,
//     this.eventTitle,
//     this.eventType,
//     this.detail,
//     this.institution,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   bool isPublic;
//   String id;
//   DateTime startDate;
//   DateTime endDate;
//   String eventTitle;
//   String eventType;
//   String detail;
//   String institution;
//   DateTime createdAt;
//   DateTime updatedAt;
//
//   factory Event.fromJson(Map<String, dynamic> json) => Event(
//     isPublic: json["isPublic"],
//     id: json["_id"],
//     startDate: DateTime.parse(json["startDate"]),
//     endDate: DateTime.parse(json["endDate"]),
//     eventTitle: json["eventTitle"],
//     eventType: json["eventType"],
//     detail: json["detail"],
//     institution: json["institution"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "isPublic": isPublic,
//     "_id": id,
//     "startDate": startDate.toIso8601String(),
//     "endDate": endDate.toIso8601String(),
//     "eventTitle": eventTitle,
//     "eventType": eventType,
//     "detail": detail,
//     "institution": institution,
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//   };
// }
