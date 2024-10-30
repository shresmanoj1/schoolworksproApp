// To parse this JSON data, do
//
//     final flaggedQuizResponse = flaggedQuizResponseFromJson(jsonString);

import 'dart:convert';

FlaggedQuizResponse flaggedQuizResponseFromJson(String str) => FlaggedQuizResponse.fromJson(json.decode(str));

String flaggedQuizResponseToJson(FlaggedQuizResponse data) => json.encode(data.toJson());

class FlaggedQuizResponse {
  bool ?success;
  List<FlaggedQuestion> ?flaggedQuestions;

  FlaggedQuizResponse({
    this.success,
    this.flaggedQuestions,
  });

  factory FlaggedQuizResponse.fromJson(Map<String, dynamic> json) => FlaggedQuizResponse(
    success: json["success"],
    flaggedQuestions: List<FlaggedQuestion>.from(json["flaggedQuestions"].map((x) => FlaggedQuestion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "flaggedQuestions": List<dynamic>.from(flaggedQuestions!.map((x) => x.toJson())),
  };
}

class FlaggedQuestion {
  bool ?hasMarked;
  String ?id;
  Question ?question;
  String ?username;
  String ?institution;
  String ?quiz;
  DateTime ?createdAt;

  FlaggedQuestion({
    this.hasMarked,
    this.id,
    this.question,
    this.username,
    this.institution,
    this.quiz,
    this.createdAt,
  });

  factory FlaggedQuestion.fromJson(Map<String, dynamic> json) => FlaggedQuestion(
    hasMarked: json["hasMarked"],
    id: json["_id"],
    question: Question.fromJson(json["question"]),
    username: json["username"],
    institution: json["institution"],
    quiz: json["quiz"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "hasMarked": hasMarked,
    "_id": id,
    "question": question?.toJson(),
    "username": username,
    "institution": institution,
    "quiz": quiz,
    "createdAt": createdAt?.toIso8601String(),
  };
}

class Question {
  String ?id;

  Question({
    this.id,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
  };
}
