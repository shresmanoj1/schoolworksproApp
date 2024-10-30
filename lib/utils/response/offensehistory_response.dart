// To parse this JSON data, do
//
//     final offenceHistoryResponse = offenceHistoryResponseFromJson(jsonString);

import 'dart:convert';

OffenceHistoryResponse offenceHistoryResponseFromJson(String str) =>
    OffenceHistoryResponse.fromJson(json.decode(str));

String offenceHistoryResponseToJson(OffenceHistoryResponse data) =>
    json.encode(data.toJson());

class OffenceHistoryResponse {
  OffenceHistoryResponse({
    this.success,
    this.result,
    this.currentLevel,
  });

  bool? success;
  List<Result>? result;
  String? currentLevel;

  factory OffenceHistoryResponse.fromJson(Map<String, dynamic> json) =>
      OffenceHistoryResponse(
        success: json["success"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        currentLevel: json["currentLevel"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
        "currentLevel": currentLevel,
      };
}

class Result {
  Result({
    this.id,
    this.level,
    this.remarks,
    this.filename,
    this.date,
    this.username,
    this.institution,
    this.createdAt,
  });

  String? id;
  Level? level;
  String? remarks;
  String? filename;
  DateTime? date;
  String? username;
  String? institution;
  DateTime? createdAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["_id"],
        level: Level.fromJson(json["level"]),
        remarks: json["remarks"],
        filename: json["filename"],
        date: DateTime.parse(json["date"]),
        username: json["username"],
        institution: json["institution"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "level": level?.toJson(),
        "remarks": remarks,
        "filename": filename,
        "date": date?.toIso8601String(),
        "username": username,
        "institution": institution,
        "createdAt": createdAt?.toIso8601String(),
      };
}

class Level {
  Level({
    this.level,
  });

  String? level;

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "level": level,
      };
}
