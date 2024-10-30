// To parse this JSON data, do
//
//     final learningFilterResponse = learningFilterResponseFromJson(jsonString);

import 'dart:convert';

LearningFilterResponse learningFilterResponseFromJson(String str) => LearningFilterResponse.fromJson(json.decode(str));

String learningFilterResponseToJson(LearningFilterResponse data) => json.encode(data.toJson());

class LearningFilterResponse {
  LearningFilterResponse({
    this.years,
    this.success,
  });

  List<String> ? years;
  bool ? success;

  factory LearningFilterResponse.fromJson(Map<String, dynamic> json) => LearningFilterResponse(
    years: List<String>.from(json["years"].map((x) => x)),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "years": List<dynamic>.from(years!.map((x) => x)),
    "success": success,
  };
}
