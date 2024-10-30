// To parse this JSON data, do
//
//     final lessonresponse = lessonresponseFromJson(jsonString);

import 'dart:convert';

Lessonresponse lessonresponseFromJson(String str) =>
    Lessonresponse.fromJson(json.decode(str));

String lessonresponseToJson(Lessonresponse data) => json.encode(data.toJson());

class Lessonresponse {
  Lessonresponse({
    this.success,
    this.lessons,
  });

  bool? success;
  List<LessonresponseLesson>? lessons;

  factory Lessonresponse.fromJson(Map<String, dynamic> json) => Lessonresponse(
        success: json["success"],
        lessons: List<LessonresponseLesson>.from(
            json["lessons"].map((x) => LessonresponseLesson.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "lessons": List<dynamic>.from(lessons!.map((x) => x.toJson())),
      };
}

class LessonresponseLesson {
  LessonresponseLesson({
    this.week,
    this.lessons,
  });

  int? week;
  List<LessonLesson>? lessons;

  factory LessonresponseLesson.fromJson(Map<String, dynamic> json) =>
      LessonresponseLesson(
        week: json["week"],
        lessons: List<LessonLesson>.from(
            json["lessons"].map((x) => LessonLesson.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "week": week,
        "lessons": List<dynamic>.from(lessons!.map((x) => x.toJson())),
      };
}

class LessonLesson {
  LessonLesson({
    this.id,
    this.lessonTitle,
    this.lessonSlug,
  });

  String? id;
  String? lessonTitle;
  String? lessonSlug;

  factory LessonLesson.fromJson(Map<String, dynamic> json) => LessonLesson(
        id: json["_id"],
        lessonTitle: json["lessonTitle"],
        lessonSlug: json["lessonSlug"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "lessonTitle": lessonTitle,
        "lessonSlug": lessonSlug,
      };
}
