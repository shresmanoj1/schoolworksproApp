// To parse this JSON data, do
//
//     final examRulesRegulationsResponse = examRulesRegulationsResponseFromJson(jsonString);

import 'dart:convert';

ExamRulesRegulationsResponse examRulesRegulationsResponseFromJson(String str) => ExamRulesRegulationsResponse.fromJson(json.decode(str));

String examRulesRegulationsResponseToJson(ExamRulesRegulationsResponse data) => json.encode(data.toJson());

class ExamRulesRegulationsResponse {
  bool? success;
  String? message;
  RulesAndRegulations? rulesAndRegulations;

  ExamRulesRegulationsResponse({
    this.success,
    this.message,
    this.rulesAndRegulations,
  });

  factory ExamRulesRegulationsResponse.fromJson(Map<String, dynamic> json) => ExamRulesRegulationsResponse(
    success: json["success"],
    message: json["message"],
    rulesAndRegulations: RulesAndRegulations.fromJson(json["rulesAndRegulations"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "rulesAndRegulations": rulesAndRegulations?.toJson(),
  };
}

class RulesAndRegulations {
  ExamRulesAndRegulations? examRulesAndRegulations;
  String? id;

  RulesAndRegulations({
    this.examRulesAndRegulations,
    this.id,
  });

  factory RulesAndRegulations.fromJson(Map<String, dynamic> json) => RulesAndRegulations(
    examRulesAndRegulations: ExamRulesAndRegulations.fromJson(json["examRulesAndRegulations"]),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "examRulesAndRegulations": examRulesAndRegulations?.toJson(),
    "_id": id,
  };
}

class ExamRulesAndRegulations {
  String? content;
  String? postedBy;

  ExamRulesAndRegulations({
    this.content,
    this.postedBy,
  });

  factory ExamRulesAndRegulations.fromJson(Map<String, dynamic> json) => ExamRulesAndRegulations(
    content: json["content"],
    postedBy: json["postedBy"],
  );

  Map<String, dynamic> toJson() => {
    "content": content,
    "postedBy": postedBy,
  };
}
