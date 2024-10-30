// To parse this JSON data, do
//
//     final surveyrequest = surveyrequestFromJson(jsonString);

import 'dart:convert';

Surveyrequest surveyrequestFromJson(String str) =>
    Surveyrequest.fromJson(json.decode(str));

String surveyrequestToJson(Surveyrequest data) => json.encode(data.toJson());

class Surveyrequest {
  Surveyrequest({
    this.surveyId,
    this.answerArray,
  });

  String? surveyId;
  List<AnswerArray>? answerArray;

  factory Surveyrequest.fromJson(Map<String, dynamic> json) => Surveyrequest(
        surveyId: json["surveyId"],
        answerArray: List<AnswerArray>.from(
            json["answerArray"].map((x) => AnswerArray.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "surveyId": surveyId,
        "answerArray": List<dynamic>.from(answerArray!.map((x) => x.toJson())),
      };
}

class AnswerArray {
  AnswerArray({
    this.question,
    this.ans,
  });

  String? question;
  String? ans;

  factory AnswerArray.fromJson(Map<String, dynamic> json) => AnswerArray(
        question: json["question"],
        ans: json["ans"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "ans": ans,
      };
}
