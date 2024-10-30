// To parse this JSON data, do
//
//     final quizResponse = quizResponseFromJson(jsonString);

import 'dart:convert';

QuizResponse quizResponseFromJson(String str) => QuizResponse.fromJson(json.decode(str));

String quizResponseToJson(QuizResponse data) => json.encode(data.toJson());

class QuizResponse {
  bool ?success;
  List<AllQuiz> ?allQuiz;

  QuizResponse({
    this.success,
    this.allQuiz,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) => QuizResponse(
    success: json["success"],
    allQuiz: List<AllQuiz>.from(json["allQuiz"].map((x) => AllQuiz.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "allQuiz": List<dynamic>.from(allQuiz!.map((x) => x.toJson())),
  };
}

class AllQuiz {
  String ?type;
  String ?quizType;
  num ?duration;
  num ?passMarks;
  String ?lessonType;
  List<dynamic> ?batches;
  List<dynamic> ?resitStudents;
  String ?id;
  String ?lessonTitle;
  String ?week;
  String ?postedBy;
  String ?moduleSlug;
  String ?institution;
  DateTime ?updatedAt;
  num ?v;
  bool ?completed;
  num ?score;

  AllQuiz({
    this.type,
    this.quizType,
    this.duration,
    this.passMarks,
    this.lessonType,
    this.batches,
    this.resitStudents,
    this.id,
    this.lessonTitle,
    this.week,
    this.postedBy,
    this.moduleSlug,
    this.institution,
    this.updatedAt,
    this.v,
    this.completed,
    this.score,
  });

  factory AllQuiz.fromJson(Map<String, dynamic> json) => AllQuiz(
    type: json["type"],
    quizType: json["quizType"],
    duration: json["duration"],
    passMarks: json["passMarks"],
    lessonType: json["lessonType"],
    batches: List<dynamic>.from(json["batches"].map((x) => x)),
    resitStudents: List<dynamic>.from(json["resitStudents"].map((x) => x)),
    id: json["_id"],
    lessonTitle: json["lessonTitle"],
    week: json["week"],
    postedBy: json["postedBy"],
    moduleSlug: json["moduleSlug"],
    institution: json["institution"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    completed: json["completed"],
    score: json["score"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "quizType": quizType,
    "duration": duration,
    "passMarks": passMarks,
    "lessonType": lessonType,
    "batches": List<dynamic>.from(batches!.map((x) => x)),
    "resitStudents": List<dynamic>.from(resitStudents!.map((x) => x)),
    "_id": id,
    "lessonTitle": lessonTitle,
    "week": week,
    "postedBy": postedBy,
    "moduleSlug": moduleSlug,
    "institution": institution,
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "completed": completed,
    "score": score,
  };
}
