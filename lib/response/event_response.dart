import 'dart:convert';

Eventresponse eventresponseFromJson(String str) =>
    Eventresponse.fromJson(json.decode(str));

String eventresponseToJson(Eventresponse data) => json.encode(data.toJson());

class Eventresponse {
  Eventresponse({
    required this.success,
    required this.events,
  });

  bool success;
  List<Event> events;

  factory Eventresponse.fromJson(Map<String, dynamic> json) => Eventresponse(
        success: json["success"],
        events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "events": List<dynamic>.from(events.map((x) => x.toJson())),
      };
}

class Event {
  Event({
    required this.id,
    required this.eventTitle,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.eventType,
    required this.detail,
    this.isRegistrable
  });

  String id;
  String eventTitle;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  DateTime updatedAt;
  String? eventType;
  String? detail;
  bool? isRegistrable;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["_id"],
        eventTitle: json["eventTitle"],
        detail: json["detail"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        eventType: json["eventType"],
        isRegistrable: json["isRegistrable"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "eventTitle": eventTitle,
        "detail": detail,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "eventType": eventType,
        "isRegistrable": isRegistrable,
      };
}

