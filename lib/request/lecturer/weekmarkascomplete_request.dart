// To parse this JSON data, do
//
//     final weekMarkCompleteRequest = weekMarkCompleteRequestFromJson(jsonString);

import 'dart:convert';

WeekMarkCompleteRequest weekMarkCompleteRequestFromJson(String str) =>
    WeekMarkCompleteRequest.fromJson(json.decode(str));

String weekMarkCompleteRequestToJson(WeekMarkCompleteRequest data) =>
    json.encode(data.toJson());

class WeekMarkCompleteRequest {
  WeekMarkCompleteRequest({
    this.batches,
    this.moduleSlug,
    this.week,
  });

  List<String>? batches;
  String? moduleSlug;
  int? week;

  factory WeekMarkCompleteRequest.fromJson(Map<String, dynamic> json) =>
      WeekMarkCompleteRequest(
        batches: List<String>.from(json["batches"].map((x) => x)),
        moduleSlug: json["moduleSlug"],
        week: json["week"],
      );

  Map<String, dynamic> toJson() => {
        "batches": List<dynamic>.from(batches!.map((x) => x)),
        "moduleSlug": moduleSlug,
        "week": week,
      };
}
