// To parse this JSON data, do
//
//     final dateRequest = dateRequestFromJson(jsonString);

import 'dart:convert';

DateRequest dateRequestFromJson(String str) => DateRequest.fromJson(json.decode(str));

String dateRequestToJson(DateRequest data) => json.encode(data.toJson());

class DateRequest {
  DateRequest({
    this.date,
  });

  DateTime ? date;

  factory DateRequest.fromJson(Map<String, dynamic> json) => DateRequest(
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "date": date?.toIso8601String(),
  };
}
