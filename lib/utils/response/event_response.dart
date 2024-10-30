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
  });

  String id;
  String eventTitle;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  DateTime updatedAt;
  EventType? eventType;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["_id"],
        eventTitle: json["eventTitle"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        eventType: eventTypeValues.map![json["eventType"]],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "eventTitle": eventTitle,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "eventType": eventTypeValues.reverse![eventType],
      };
}

enum EventType { COMMON, STUDENT }

final eventTypeValues =
    EnumValues({"Common": EventType.COMMON, "Student": EventType.STUDENT});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
