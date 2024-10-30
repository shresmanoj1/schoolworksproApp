// // To parse this JSON data, do
// //
// //     final quizEndResponse = quizEndResponseFromJson(jsonString);
//
// import 'dart:convert';
//
// QuizEndResponse quizEndResponseFromJson(String str) => QuizEndResponse.fromJson(json.decode(str));
//
// String quizEndResponseToJson(QuizEndResponse data) => json.encode(data.toJson());
//
// class QuizEndResponse {
//   bool ?success;
//   Quizz ?quizz;
//   bool ?isPastQuiz;
//   int ?test;
//
//   QuizEndResponse({
//     this.success,
//     this.quizz,
//     this.isPastQuiz,
//     this.test,
//   });
//
//   factory QuizEndResponse.fromJson(Map<String, dynamic> json) => QuizEndResponse(
//     success: json["success"],
//     quizz: Quizz.fromJson(json["quiz"]),
//     isPastQuiz: json["isPastQuiz"],
//     test: json["test"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "quiz": quizz?.toJson(),
//     "isPastQuiz": isPastQuiz,
//     "test": test,
//   };
// }
//
// class Quizz {
//   String ?moduleTitle;
//   int ?score;
//   bool ?isReleased;
//   List<dynamic> ?takenBy;
//   String? id;
//   int ?passMarks;
//
//   Quizz({
//     this.moduleTitle,
//     this.score,
//     this.isReleased,
//     this.takenBy,
//     this.id,
//     this.passMarks,
//   });
//
//   factory Quizz.fromJson(Map<String, dynamic> json) => Quizz(
//     moduleTitle: json["moduleTitle"],
//     score: json["score"],
//     isReleased: json["isReleased"],
//     takenBy: List<dynamic>.from(json["takenBy"].map((x) => x)),
//     id: json["_id"],
//     passMarks: json["passMarks"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "moduleTitle": moduleTitle,
//     "score": score,
//     "isReleased": isReleased,
//     "takenBy": List<dynamic>.from(takenBy!.map((x) => x)),
//     "_id": id,
//     "passMarks": passMarks,
//   };
// }
