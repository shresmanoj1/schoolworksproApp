// To parse this JSON data, do
//
//     final lessonProgressResponse = lessonProgressResponseFromJson(jsonString);

import 'dart:convert';

LessonProgressResponse lessonProgressResponseFromJson(String str) => LessonProgressResponse.fromJson(json.decode(str));

String lessonProgressResponseToJson(LessonProgressResponse data) => json.encode(data.toJson());

class LessonProgressResponse {
  bool? success;
  List<Progressr>? progress;

  LessonProgressResponse({
    this.success,
    this.progress,
  });

  factory LessonProgressResponse.fromJson(Map<String, dynamic> json) => LessonProgressResponse(
    success: json["success"],
    progress: List<Progressr>.from(json["progress"].map((x) => Progressr.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "progress": List<dynamic>.from(progress!.map((x) => x.toJson())),
  };
}

class Progressr {
  num? week;
  num? totalLessons;
  num? completedLessonCount;

  Progressr({
    this.week,
    this.totalLessons,
    this.completedLessonCount,
  });

  factory Progressr.fromJson(Map<String, dynamic> json) => Progressr(
    week: json["week"],
    totalLessons: json["total_lessons"],
    completedLessonCount: json["completed_lesson_count"],
  );

  Map<String, dynamic> toJson() => {
    "week": week,
    "total_lessons": totalLessons,
    "completed_lesson_count": completedLessonCount,
  };
}
