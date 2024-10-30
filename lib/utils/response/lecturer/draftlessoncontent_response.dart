
// To parse this JSON data, do
//
//     final draftContentResponse = draftContentResponseFromJson(jsonString);

import 'dart:convert';

DraftContentResponse draftContentResponseFromJson(String str) => DraftContentResponse.fromJson(json.decode(str));

String draftContentResponseToJson(DraftContentResponse data) => json.encode(data.toJson());

class DraftContentResponse {
  DraftContentResponse({
    this.success,
    this.lessons,
  });

  bool ? success;
  List<DraftContentResponseLesson> ? lessons;

  factory DraftContentResponse.fromJson(Map<String, dynamic> json) => DraftContentResponse(
    success: json["success"],
    lessons: List<DraftContentResponseLesson>.from(json["lessons"].map((x) => DraftContentResponseLesson.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "lessons": List<dynamic>.from(lessons!.map((x) => x.toJson())),
  };
}

class DraftContentResponseLesson {
  DraftContentResponseLesson({
    this.week,
    this.lessons,
    this.quizCompleted,
  });

  dynamic week;
  List<LessonLesson> ? lessons;
  bool ? quizCompleted;

  factory DraftContentResponseLesson.fromJson(Map<String, dynamic> json) => DraftContentResponseLesson(
    week: json["week"],
    lessons: List<LessonLesson>.from(json["lessons"].map((x) => LessonLesson.fromJson(x))),
    quizCompleted: json["quizCompleted"] == null ? null : json["quizCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "week": week,
    "lessons": List<dynamic>.from(lessons!.map((x) => x.toJson())),
    "quizCompleted": quizCompleted == null ? null : quizCompleted,
  };
}

class LessonLesson {
  LessonLesson({
    this.type,
    this.duration,
    this.passMarks,
    this.lessonType,
    this.batches,
    this.id,
    this.lessonTitle,
    this.week,
    this.moduleSlug,
    this.institution,
    this.lessonSlug,
  });

  String ? type;
  int? duration;
  int ? passMarks;
  String? lessonType;
  List<dynamic>? batches;
  String? id;
  String ?lessonTitle;
  String? week;
  String ?moduleSlug;
  String? institution;
  String ?lessonSlug;

  factory LessonLesson.fromJson(Map<String, dynamic> json) => LessonLesson(
    type: json["type"] == null ? null : json["type"],
    duration: json["duration"] == null ? null : json["duration"],
    passMarks: json["passMarks"] == null ? null : json["passMarks"],
    lessonType: json["lessonType"] == null ? null : json["lessonType"],
    batches: json["batches"] == null ? null : List<dynamic>.from(json["batches"].map((x) => x)),
    id: json["_id"],
    lessonTitle: json["lessonTitle"],
    week: json["week"] == null ? null : json["week"],
    moduleSlug: json["moduleSlug"] == null ? null : json["moduleSlug"],
    institution: json["institution"] == null ? null : json["institution"],
    lessonSlug: json["lessonSlug"] == null ? null : json["lessonSlug"],
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? null : type,
    "duration": duration == null ? null : duration,
    "passMarks": passMarks == null ? null : passMarks,
    "lessonType": lessonType == null ? null : lessonType,
    "batches": batches == null ? null : List<dynamic>.from(batches!.map((x) => x)),
    "_id": id,
    "lessonTitle": lessonTitle,
    "week": week == null ? null : week,
    "moduleSlug": moduleSlug == null ? null : moduleSlug,
    "institution": institution == null ? null : institution,
    "lessonSlug": lessonSlug == null ? null : lessonSlug,
  };
}
