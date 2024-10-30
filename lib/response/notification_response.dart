// To parse this JSON data, do
//
//     final notificationresponse = notificationresponseFromJson(jsonString);

import 'dart:convert';

Notificationresponse notificationresponseFromJson(String str) =>
    Notificationresponse.fromJson(json.decode(str));

String notificationresponseToJson(Notificationresponse data) =>
    json.encode(data.toJson());

class Notificationresponse {
  Notificationresponse({
    this.success,
    this.notifications,
  });

  bool? success;
  List<Notificationss>? notifications;

  factory Notificationresponse.fromJson(Map<String, dynamic> json) =>
      Notificationresponse(
        success: json["success"],
        notifications: List<Notificationss>.from(
            json["notifications"].map((x) => Notificationss.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "notifications":
            List<dynamic>.from(notifications!.map((x) => x.toJson())),
      };
}

class Notificationss {
  Notificationss({
    this.id,
    this.notificationTitle,
    this.notificationContent,
    this.receiver,
    this.sender,
    this.path,
    this.createdAt,
  });

  String? id;
  String? notificationTitle;
  String? notificationContent;
  String? receiver;
  String? sender;
  String? path;
  DateTime? createdAt;

  factory Notificationss.fromJson(Map<String, dynamic> json) => Notificationss(
        id: json["_id"],
        notificationTitle: json["notificationTitle"],
        notificationContent: json["notificationContent"],
        receiver: json["receiver"],
        sender: json["sender"],
        path: json["path"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "notificationTitle": notificationTitle,
        "notificationContent": notificationContent,
        "receiver": receiver,
        "sender": sender,
        "path": path,
        "createdAt": createdAt?.toIso8601String(),
      };
}
