// To parse this JSON data, do
//
//     final assessmentresponse = assessmentresponseFromJson(jsonString);

import 'dart:convert';

Assessmentresponse assessmentresponseFromJson(String str) =>
    Assessmentresponse.fromJson(json.decode(str));

String assessmentresponseToJson(Assessmentresponse data) =>
    json.encode(data.toJson());

class Assessmentresponse {
  Assessmentresponse({
    this.success,
    this.assessments,
  });

  bool? success;
  List<AssessmentresponseAssessment>? assessments;

  factory Assessmentresponse.fromJson(Map<String, dynamic> json) =>
      Assessmentresponse(
        success: json["success"],
        assessments: List<AssessmentresponseAssessment>.from(json["assessments"]
            .map((x) => AssessmentresponseAssessment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "assessments": List<dynamic>.from(assessments!.map((x) => x.toJson())),
      };
}

class AssessmentresponseAssessment {
  AssessmentresponseAssessment({
    this.week,
    this.assessments,
  });

  int? week;
  List<AssessmentAssessment>? assessments;

  factory AssessmentresponseAssessment.fromJson(Map<String, dynamic> json) =>
      AssessmentresponseAssessment(
        week: json["week"],
        assessments: List<AssessmentAssessment>.from(
            json["assessments"].map((x) => AssessmentAssessment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "week": week,
        "assessments": List<dynamic>.from(assessments!.map((x) => x.toJson())),
      };
}

class AssessmentAssessment {
  AssessmentAssessment({
    this.id,
    this.dueDate,
    this.lessonSlug,
    this.institution,
    this.completed,
    this.week,
    this.lessonTitle,
  });

  String? id;
  DateTime? dueDate;
  String? lessonSlug;
  String? institution;
  bool? completed;
  String? week;
  String? lessonTitle;

  factory AssessmentAssessment.fromJson(Map<String, dynamic> json) =>
      AssessmentAssessment(
        id: json["_id"],
        dueDate: DateTime.parse(json["dueDate"]),
        lessonSlug: json["lessonSlug"],
        institution: json["institution"],
        completed: json["completed"],
        week: json["week"],
        lessonTitle: json["lessonTitle"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "dueDate": dueDate!.toIso8601String(),
        "lessonSlug": lessonSlug,
        "institution": institution,
        "completed": completed,
        "week": week,
        "lessonTitle": lessonTitle,
      };
}
