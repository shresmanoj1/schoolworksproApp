// To parse this JSON data, do
//
//     final completedlessonresponse = completedlessonresponseFromJson(jsonString);

import 'dart:convert';

Completedlessonresponse completedlessonresponseFromJson(String str) =>
    Completedlessonresponse.fromJson(json.decode(str));

String completedlessonresponseToJson(Completedlessonresponse data) =>
    json.encode(data.toJson());

class Completedlessonresponse {
  Completedlessonresponse({
    this.success,
    this.completedLessons,
  });

  bool? success;
  List<CompletedLesson>? completedLessons;

  factory Completedlessonresponse.fromJson(Map<String, dynamic> json) =>
      Completedlessonresponse(
        success: json["success"],
        completedLessons: List<CompletedLesson>.from(
            json["completedLessons"].map((x) => CompletedLesson.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "completedLessons":
            List<dynamic>.from(completedLessons!.map((x) => x.toJson())),
      };
}

class CompletedLesson {
  CompletedLesson({
    this.lesson,
  });

  String? lesson;

  factory CompletedLesson.fromJson(Map<String, dynamic> json) =>
      CompletedLesson(
        lesson: json["lesson"],
      );

  Map<String, dynamic> toJson() => {
        "lesson": lesson,
      };
}
