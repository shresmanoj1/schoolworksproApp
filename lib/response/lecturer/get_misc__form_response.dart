// To parse this JSON data, do
//
//     final getMiscResponse = getMiscResponseFromJson(jsonString);

import 'dart:convert';

GetMiscResponse getMiscResponseFromJson(String str) => GetMiscResponse.fromJson(json.decode(str));

String getMiscResponseToJson(GetMiscResponse data) => json.encode(data.toJson());

class GetMiscResponse {
  bool ? success;
  String ? message;
  List<Result> ? result;
  List<String> ? extraInfo;

  GetMiscResponse({
    this.success,
    this.message,
    this.result,
    this.extraInfo,
  });

  factory GetMiscResponse.fromJson(Map<String, dynamic> json) => GetMiscResponse(
    success: json["success"],
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    extraInfo: List<String>.from(json["extraInfo"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "extraInfo": List<dynamic>.from(extraInfo!.map((x) => x)),
  };
}

class Result {
  ExtraInfoClass ? resultExtraInfo;
  String ? id;
  String ? username;
  String ? examSlug;
  String ? batch;
  String ? institution;
  dynamic extraInfo;

  Result({
    this.resultExtraInfo,
    this.id,
    this.username,
    this.examSlug,
    this.batch,
    this.institution,
    this.extraInfo,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    resultExtraInfo: json["extraInfo"],
    id: json["_id"],
    username: json["username"],
    examSlug: json["examSlug"],
    batch: json["batch"],
    institution: json["institution"],
    extraInfo: json["_extraInfo"],
  );

  Map<String, dynamic> toJson() => {
    "extraInfo": resultExtraInfo?.toJson(),
    "_id": id,
    "username": username,
    "examSlug": examSlug,
    "batch": batch,
    "institution": institution,
    "_extraInfo": extraInfo,
  };
}



class ExtraInfoClass {
  String ? presentDays;
  String ? absentDays;

  ExtraInfoClass({
    this.presentDays,
    this.absentDays,
  });

  factory ExtraInfoClass.fromJson(Map<String, dynamic> json) => ExtraInfoClass(
    presentDays: json["presentDays"],
    absentDays: json["absentDays"],
  );

  Map<String, dynamic> toJson() => {
    "presentDays": presentDays,
    "absentDays": absentDays,
  };
}
