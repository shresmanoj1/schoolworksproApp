// To parse this JSON data, do
//
//     final quizOverviewResponse = quizOverviewResponseFromJson(jsonString);

import 'dart:convert';

QuizOverviewResponse quizOverviewResponseFromJson(String str) => QuizOverviewResponse.fromJson(json.decode(str));

String quizOverviewResponseToJson(QuizOverviewResponse data) => json.encode(data.toJson());

class QuizOverviewResponse {
  bool ?success;
  Result ?result;

  QuizOverviewResponse({
    this.success,
    this.result,
  });

  factory QuizOverviewResponse.fromJson(Map<String, dynamic> json) => QuizOverviewResponse(
    success: json["success"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result?.toJson(),
  };
}

class Result {
  int ?totalQuestions;
  int ?attemptedQuestions;
  QuizScore ?quizScore;
  String ?attemptedPercent;
  List<Answer> ?answers;

  Result({
    this.totalQuestions,
    this.attemptedQuestions,
    this.quizScore,
    this.attemptedPercent,
    this.answers,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    totalQuestions: json["totalQuestions"],
    attemptedQuestions: json["attemptedQuestions"],
    quizScore: QuizScore.fromJson(json["quizScore"]),
    attemptedPercent: json["attemptedPercent"],
    answers: List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalQuestions": totalQuestions,
    "attemptedQuestions": attemptedQuestions,
    "quizScore": quizScore?.toJson(),
    "attemptedPercent": attemptedPercent,
    "answers": List<dynamic>.from(answers!.map((x) => x.toJson())),
  };
}

class Answer {
  List<dynamic> ?objectiveAnswers;
  bool ?isSubjective;
  bool ?isCorrect;
  String ?id;
  String ?username;
  String ?institution;
  String ?answer;
  String ?codeAnswer;
  Question ?question;
  int ?score;
  DateTime ?createdAt;
  String ?feedback;

  Answer({
    this.objectiveAnswers,
    this.isSubjective,
    this.isCorrect,
    this.id,
    this.username,
    this.institution,
    this.answer,
    this.codeAnswer,
    this.question,
    this.score,
    this.createdAt,
    this.feedback,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    objectiveAnswers: List<dynamic>.from(json["objectiveAnswers"].map((x) => x)),
    isSubjective: json["isSubjective"],
    isCorrect: json["isCorrect"],
    id: json["_id"],
    username: json["username"],
    institution: json["institution"],
    answer: json["answer"],
    codeAnswer: json["codeAnswer"],
    question: Question.fromJson(json["question"]),
    score: json["score"],
    createdAt: DateTime.parse(json["createdAt"]),
    feedback: json["feedback"],
  );

  Map<String, dynamic> toJson() => {
    "objectiveAnswers": List<dynamic>.from(objectiveAnswers!.map((x) => x)),
    "isSubjective": isSubjective,
    "isCorrect": isCorrect,
    "_id": id,
    "username": username,
    "institution": institution,
    "answer": answer,
    "codeAnswer": codeAnswer,
    "question": question?.toJson(),
    "score": score,
    "createdAt": createdAt?.toIso8601String(),
    "feedback": feedback,
  };
}

class Question {
  List<dynamic> ?incorrectAnswers;
  bool ?hasCodeAnswer;
  List<dynamic> ?codeOptions;
  List<dynamic> ?correctAnswers;
  String ?id;
  String ?question;
  String ?feedback;
  String ?questionType;
  String ?institution;
  int ?questionWeightage;
  List<dynamic> ?scores;
  DateTime ?createdAt;
  DateTime ?updatedAt;
  int ?v;

  Question({
    this.incorrectAnswers,
    this.hasCodeAnswer,
    this.codeOptions,
    this.correctAnswers,
    this.id,
    this.question,
    this.feedback,
    this.questionType,
    this.institution,
    this.questionWeightage,
    this.scores,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    incorrectAnswers: List<dynamic>.from(json["incorrect_answers"].map((x) => x)),
    hasCodeAnswer: json["hasCodeAnswer"],
    codeOptions: List<dynamic>.from(json["codeOptions"].map((x) => x)),
    correctAnswers: List<dynamic>.from(json["correct_answers"].map((x) => x)),
    id: json["_id"],
    question: json["question"],
    feedback: json["feedback"],
    questionType: json["question_type"],
    institution: json["institution"],
    questionWeightage: json["questionWeightage"],
    scores: List<dynamic>.from(json["scores"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "incorrect_answers": List<dynamic>.from(incorrectAnswers!.map((x) => x)),
    "hasCodeAnswer": hasCodeAnswer,
    "codeOptions": List<dynamic>.from(codeOptions!.map((x) => x)),
    "correct_answers": List<dynamic>.from(correctAnswers!.map((x) => x)),
    "_id": id,
    "question": question,
    "feedback": feedback,
    "question_type": questionType,
    "institution": institution,
    "questionWeightage": questionWeightage,
    "scores": List<dynamic>.from(scores!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class QuizScore {
  bool ?isReleased;
  bool ?isPast;
  String ?id;
  String ?username;
  double ?score;
  int ?objectiveScore;
  String ?quizId;
  String ?institution;
  DateTime ?createdAt;
  int ?subjectiveScore;

  QuizScore({
    this.isReleased,
    this.isPast,
    this.id,
    this.username,
    this.score,
    this.objectiveScore,
    this.quizId,
    this.institution,
    this.createdAt,
    this.subjectiveScore,
  });

  factory QuizScore.fromJson(Map<String, dynamic> json) => QuizScore(
    isReleased: json["isReleased"],
    isPast: json["isPast"],
    id: json["_id"],
    username: json["username"],
    score: json["score"].toDouble(),
    objectiveScore: json["objectiveScore"],
    quizId: json["quizId"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    subjectiveScore: json["subjectiveScore"],
  );

  Map<String, dynamic> toJson() => {
    "isReleased": isReleased,
    "isPast": isPast,
    "_id": id,
    "username": username,
    "score": score,
    "objectiveScore": objectiveScore,
    "quizId": quizId,
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "subjectiveScore": subjectiveScore,
  };
}
