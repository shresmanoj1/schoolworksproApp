// To parse this JSON data, do
//
//     final studentLogsResponse = studentLogsResponseFromJson(jsonString);

import 'dart:convert';

StudentLogsResponse studentLogsResponseFromJson(String str) => StudentLogsResponse.fromJson(json.decode(str));

String studentLogsResponseToJson(StudentLogsResponse data) => json.encode(data.toJson());

class StudentLogsResponse {
  bool? success;
  String? message;
  List<Record>? record;

  StudentLogsResponse({
    this.success,
    this.message,
    this.record,
  });

  factory StudentLogsResponse.fromJson(Map<String, dynamic> json) => StudentLogsResponse(
    success: json["success"],
    message: json["message"],
    record: List<Record>.from(json["record"].map((x) => Record.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "record": List<dynamic>.from(record!.map((x) => x.toJson())),
  };
}

class Record {
  String? recordType;
  String? id;
  String? username;
  String? event;
  String? remarks;
  DateTime? date;
  String? institution;
  List<StatusHistory>? statusHistory;
  DateTime? createdAt;
  String? recordStatus;

  Record({
    this.recordType,
    this.id,
    this.username,
    this.event,
    this.remarks,
    this.date,
    this.institution,
    this.statusHistory,
    this.createdAt,
    this.recordStatus,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    recordType: json["recordType"],
    id: json["_id"],
    username: json["username"],
    event: json["event"],
    remarks: json["remarks"],
    date: DateTime.parse(json["date"]),
    institution: json["institution"],
    statusHistory: List<StatusHistory>.from(json["statusHistory"].map((x) => StatusHistory.fromJson(x))),
    createdAt: DateTime.parse(json["createdAt"]),
    recordStatus: json["recordStatus"],
  );

  Map<String, dynamic> toJson() => {
    "recordType": recordType,
    "_id": id,
    "username": username,
    "event": event,
    "remarks": remarks,
    "date": date?.toIso8601String(),
    "institution": institution,
    "statusHistory": List<dynamic>.from(statusHistory!.map((x) => x.toJson())),
    "createdAt": createdAt?.toIso8601String(),
    "recordStatus": recordStatus,
  };
}

class StatusHistory {
  DateTime? updatedAt;
  String? id;
  String? value;
  String? statusTime;

  StatusHistory({
    this.updatedAt,
    this.id,
    this.value,
    this.statusTime,
  });

  factory StatusHistory.fromJson(Map<String, dynamic> json) => StatusHistory(
    updatedAt: DateTime.parse(json["updatedAt"]),
    id: json["_id"],
    value: json["value"],
    statusTime: json["statusTime"],
  );

  Map<String, dynamic> toJson() => {
    "updatedAt": updatedAt?.toIso8601String(),
    "_id": id,
    "value": value,
    "statusTime": statusTime,
  };
}
