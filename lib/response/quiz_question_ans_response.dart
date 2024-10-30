// To parse this JSON data, do
//
//     final quizMyAnswerResponse = quizMyAnswerResponseFromJson(jsonString);

import 'dart:convert';

QuizMyAnswerResponse quizMyAnswerResponseFromJson(String str) => QuizMyAnswerResponse.fromJson(json.decode(str));

String quizMyAnswerResponseToJson(QuizMyAnswerResponse data) => json.encode(data.toJson());

class QuizMyAnswerResponse {
  bool ?success;
  Answer ?answer;

  QuizMyAnswerResponse({
    this.success,
    this.answer,
  });

  factory QuizMyAnswerResponse.fromJson(Map<String, dynamic> json) => QuizMyAnswerResponse(
    success: json["success"],
    answer: Answer.fromJson(json["answer"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "answer": answer?.toJson(),
  };
}

class Answer {
  List<dynamic> ?objectiveAnswers;
  bool ?isSubjective;
  String ?id;
  String ?username;
  String ?institution;
  String ?answer;
  String ?codeAnswer;
  Question ?question;
  DateTime ?createdAt;

  Answer({
    this.objectiveAnswers,
    this.isSubjective,
    this.id,
    this.username,
    this.institution,
    this.answer,
    this.codeAnswer,
    this.question,
    this.createdAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    objectiveAnswers: List<dynamic>.from(json["objectiveAnswers"].map((x) => x)),
    isSubjective: json["isSubjective"],
    id: json["_id"],
    username: json["username"],
    institution: json["institution"],
    answer: json["answer"],
    codeAnswer: json["codeAnswer"],
    question: Question.fromJson(json["question"]),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "objectiveAnswers": List<dynamic>.from(objectiveAnswers!.map((x) => x)),
    "isSubjective": isSubjective,
    "_id": id,
    "username": username,
    "institution": institution,
    "answer": answer,
    "codeAnswer": codeAnswer,
    "question": question?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
  };
}

class Question {
  bool ?hasCodeAnswer;
  List<dynamic> ?codeOptions;
  String ?id;
  String ?question;
  String ?feedback;
  String ?questionType;
  String ?institution;
  DateTime ?createdAt;
  DateTime ?updatedAt;
  int ?v;

  Question({
    this.hasCodeAnswer,
    this.codeOptions,
    this.id,
    this.question,
    this.feedback,
    this.questionType,
    this.institution,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    hasCodeAnswer: json["hasCodeAnswer"],
    codeOptions: List<dynamic>.from(json["codeOptions"].map((x) => x)),
    id: json["_id"],
    question: json["question"],
    feedback: json["feedback"],
    questionType: json["question_type"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "hasCodeAnswer": hasCodeAnswer,
    "codeOptions": List<dynamic>.from(codeOptions!.map((x) => x)),
    "_id": id,
    "question": question,
    "feedback": feedback,
    "question_type": questionType,
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
