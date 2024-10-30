// To parse this JSON data, do
//
//     final codeQuizCheckResponse = codeQuizCheckResponseFromJson(jsonString);

import 'dart:convert';

CodeQuizCheckResponse codeQuizCheckResponseFromJson(String str) => CodeQuizCheckResponse.fromJson(json.decode(str));

String codeQuizCheckResponseToJson(CodeQuizCheckResponse data) => json.encode(data.toJson());

class CodeQuizCheckResponse {
  bool ?success;
  bool ?hasCodeAnswer;

  CodeQuizCheckResponse({
    this.success,
    this.hasCodeAnswer,
  });

  factory CodeQuizCheckResponse.fromJson(Map<String, dynamic> json) => CodeQuizCheckResponse(
    success: json["success"],
    hasCodeAnswer: json["hasCodeAnswer"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "hasCodeAnswer": hasCodeAnswer,
  };
}
