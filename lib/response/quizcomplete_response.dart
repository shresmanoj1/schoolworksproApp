// To parse this JSON data, do
//
//     final quizCompleteResponse = quizCompleteResponseFromJson(jsonString);

import 'dart:convert';

QuizCompleteResponse quizCompleteResponseFromJson(String str) => QuizCompleteResponse.fromJson(json.decode(str));

String quizCompleteResponseToJson(QuizCompleteResponse data) => json.encode(data.toJson());

class QuizCompleteResponse {
  bool ?success;
  UpdatedScore ?updatedScore;

  QuizCompleteResponse({
    this.success,
    this.updatedScore,
  });

  factory QuizCompleteResponse.fromJson(Map<String, dynamic> json) => QuizCompleteResponse(
    success: json["success"],
    updatedScore: UpdatedScore.fromJson(json["updatedScore"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "updatedScore": updatedScore?.toJson(),
  };
}

class UpdatedScore {
  bool ?isReleased;
  bool ?isPast;
  String ?id;
  String ?username;
  int ?score;
  int ?objectiveScore;
  String ?quizId;
  String ?institution;
  DateTime ?createdAt;

  UpdatedScore({
    this.isReleased,
    this.isPast,
    this.id,
    this.username,
    this.score,
    this.objectiveScore,
    this.quizId,
    this.institution,
    this.createdAt,
  });

  factory UpdatedScore.fromJson(Map<String, dynamic> json) => UpdatedScore(
    isReleased: json["isReleased"],
    isPast: json["isPast"],
    id: json["_id"],
    username: json["username"],
    score: json["score"],
    objectiveScore: json["objectiveScore"],
    quizId: json["quizId"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
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
  };
}
