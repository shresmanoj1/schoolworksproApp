// To parse this JSON data, do
//
//     final quizStartResponse = quizStartResponseFromJson(jsonString);

import 'dart:convert';

QuizStartResponse quizStartResponseFromJson(String str) => QuizStartResponse.fromJson(json.decode(str));

String quizStartResponseToJson(QuizStartResponse data) => json.encode(data.toJson());

class QuizStartResponse {
  bool ?success;
  dynamic quiz;
  bool ?isPastQuiz;
  int ?test;
  String ?week;

  QuizStartResponse({
    this.success,
    this.quiz,
    this.isPastQuiz,
    this.test,
    this.week,
  });

  factory QuizStartResponse.fromJson(Map<String, dynamic> json) => QuizStartResponse(
    success: json["success"],
    quiz: json["quiz"],
    isPastQuiz: json["isPastQuiz"],
    test: json["test"] == null ? null : json["test"],
    week: json["week"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "quiz": quiz,
    "isPastQuiz": isPastQuiz,
    "test": test == null ? null : test,
    "week": week,

  };
}

// class Quiz {
//   int ?duration;
//   int ?passMarks;
//   List<Question> ?questions;
//   String ?id;
//   DateTime ?endDate;
//   DateTime ?startDate;
//   String ?moduleTitle;
//
//   Quiz({
//     this.duration,
//     this.passMarks,
//     this.questions,
//     this.id,
//     this.endDate,
//     this.startDate,
//     this.moduleTitle,
//   });
//
//   factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
//     duration: json["duration"],
//     passMarks: json["passMarks"],
//     questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
//     id: json["_id"],
//     endDate: DateTime.parse(json["endDate"]),
//     startDate: DateTime.parse(json["startDate"]),
//     moduleTitle: json["moduleTitle"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "duration": duration,
//     "passMarks": passMarks,
//     "questions": List<dynamic>.from(questions!.map((x) => x.toJson())),
//     "_id": id,
//     "endDate": endDate?.toIso8601String(),
//     "startDate": startDate?.toIso8601String(),
//     "moduleTitle": moduleTitle,
//   };
// }
//
// class Question {
//   bool ?hasCodeAnswer;
//   List<dynamic> ?codeOptions;
//   String ?id;
//   String ?question;
//   String ?feedback;
//   String ?questionType;
//   String ?institution;
//   int ?questionWeightage;
//   List<String> ?options;
//
//   Question({
//     this.hasCodeAnswer,
//     this.codeOptions,
//     this.id,
//     this.question,
//     this.feedback,
//     this.questionType,
//     this.institution,
//     this.questionWeightage,
//     this.options,
//   });
//
//   factory Question.fromJson(Map<String, dynamic> json) => Question(
//     hasCodeAnswer: json["hasCodeAnswer"],
//     codeOptions: List<dynamic>.from(json["codeOptions"].map((x) => x)),
//     id: json["_id"],
//     question: json["question"],
//     feedback: json["feedback"],
//     questionType: json["question_type"],
//     institution: json["institution"],
//     questionWeightage: json["questionWeightage"],
//     options: List<String>.from(json["options"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "hasCodeAnswer": hasCodeAnswer,
//     "codeOptions": List<dynamic>.from(codeOptions!.map((x) => x)),
//     "_id": id,
//     "question": question,
//     "feedback": feedback,
//     "question_type": questionType,
//     "institution": institution,
//     "questionWeightage": questionWeightage,
//     "options": List<dynamic>.from(options!.map((x) => x)),
//   };
// }
