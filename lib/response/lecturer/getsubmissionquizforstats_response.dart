// To parse this JSON data, do
//
//     final getSubmissionsQuizForStatsResponse = getSubmissionsQuizForStatsResponseFromJson(jsonString);

import 'dart:convert';

GetSubmissionsQuizForStatsResponse getSubmissionsQuizForStatsResponseFromJson(
        String str) =>
    GetSubmissionsQuizForStatsResponse.fromJson(json.decode(str));

String getSubmissionsQuizForStatsResponseToJson(
        GetSubmissionsQuizForStatsResponse data) =>
    json.encode(data.toJson());

class GetSubmissionsQuizForStatsResponse {
  GetSubmissionsQuizForStatsResponse({
    this.success,
    this.allQuiz,
  });

  bool? success;
  List<dynamic>? allQuiz;

  factory GetSubmissionsQuizForStatsResponse.fromJson(
          Map<String, dynamic> json) =>
      GetSubmissionsQuizForStatsResponse(
        success: json["success"],
        allQuiz: List<dynamic>.from(json["allQuiz"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "allQuiz": List<dynamic>.from(allQuiz!.map((x) => x)),
      };
}
