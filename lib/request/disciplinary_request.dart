// To parse this JSON data, do
//
//     final disciplinaryRequest = disciplinaryRequestFromJson(jsonString);

import 'dart:convert';

DisciplinaryRequest disciplinaryRequestFromJson(String str) =>
    DisciplinaryRequest.fromJson(json.decode(str));

String disciplinaryRequestToJson(DisciplinaryRequest data) =>
    json.encode(data.toJson());

class DisciplinaryRequest {
  DisciplinaryRequest({
    this.level,
    this.misconduct,
    this.count,
    this.action,
  });

  String? level;
  String? misconduct;
  String? count;
  String? action;

  factory DisciplinaryRequest.fromJson(Map<String, dynamic> json) =>
      DisciplinaryRequest(
        level: json["level"],
        misconduct: json["misconduct"],
        count: json["count"],
        action: json["action"],
      );

  Map<String, dynamic> toJson() => {
        "level": level,
        "misconduct": misconduct,
        "count": count,
        "action": action,
      };
}
