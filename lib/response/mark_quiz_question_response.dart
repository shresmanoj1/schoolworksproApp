// To parse this JSON data, do
//
//     final markQuizQuestionResponse = markQuizQuestionResponseFromJson(jsonString);

import 'dart:convert';

MarkQuizQuestionResponse markQuizQuestionResponseFromJson(String str) => MarkQuizQuestionResponse.fromJson(json.decode(str));

String markQuizQuestionResponseToJson(MarkQuizQuestionResponse data) => json.encode(data.toJson());

class MarkQuizQuestionResponse {
  bool ?success;
  String ?message;
  QuestionFlag ?questionFlag;

  MarkQuizQuestionResponse({
    this.success,
    this.message,
    this.questionFlag,
  });

  factory MarkQuizQuestionResponse.fromJson(Map<String, dynamic> json) => MarkQuizQuestionResponse(
    success: json["success"],
    message: json["message"],
    questionFlag: QuestionFlag.fromJson(json["questionFlag"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "questionFlag": questionFlag?.toJson(),
  };
}

class QuestionFlag {
  bool ?hasMarked;
  String ?id;
  String ?question;
  String ?username;
  String ?institution;
  String ?quiz;
  DateTime ?createdAt;

  QuestionFlag({
    this.hasMarked,
    this.id,
    this.question,
    this.username,
    this.institution,
    this.quiz,
    this.createdAt,
  });

  factory QuestionFlag.fromJson(Map<String, dynamic> json) => QuestionFlag(
    hasMarked: json["hasMarked"],
    id: json["_id"],
    question: json["question"],
    username: json["username"],
    institution: json["institution"],
    quiz: json["quiz"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "hasMarked": hasMarked,
    "_id": id,
    "question": question,
    "username": username,
    "institution": institution,
    "quiz": quiz,
    "createdAt": createdAt?.toIso8601String(),
  };
}
