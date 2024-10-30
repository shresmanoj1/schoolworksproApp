// To parse this JSON data, do
//
//     final disciplinaryResponse = disciplinaryResponseFromJson(jsonString);

import 'dart:convert';

DisciplinaryResponse disciplinaryResponseFromJson(String str) =>
    DisciplinaryResponse.fromJson(json.decode(str));

String disciplinaryResponseToJson(DisciplinaryResponse data) =>
    json.encode(data.toJson());

class DisciplinaryResponse {
  DisciplinaryResponse({
    this.success,
    this.result,
  });

  bool? success;
  List<Result>? result;

  factory DisciplinaryResponse.fromJson(Map<String, dynamic> json) =>
      DisciplinaryResponse(
        success: json["success"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.id,
    this.level,
    this.misconduct,
    this.count,
    this.action,
    this.institution,
  });

  String? id;
  String? level;
  String? misconduct;
  int? count;
  String? action;
  String? institution;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["_id"],
        level: json["level"],
        misconduct: json["misconduct"],
        count: json["count"],
        action: json["action"],
        institution: json["institution"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "level": level,
        "misconduct": misconduct,
        "count": count,
        "action": action,
        "institution": institution,
      };
}
