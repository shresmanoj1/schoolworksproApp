// To parse this JSON data, do
//
//     final addAssessmentRequest = addAssessmentRequestFromJson(jsonString);

import 'dart:convert';

AddAssessmentRequest addAssessmentRequestFromJson(String str) => AddAssessmentRequest.fromJson(json.decode(str));

String addAssessmentRequestToJson(AddAssessmentRequest data) => json.encode(data.toJson());

class AddAssessmentRequest {
  AddAssessmentRequest({
    this.dueDate,
    this.startDate,
    this.contents,
    this.lessonSlug,
    this.batches,
    this.forResitOnly,
    this.needMultipleSubmissionEditor
  });

  DateTime ? dueDate;
  DateTime ? startDate;
  String ? contents;
  String ? lessonSlug;
  List<String> ? batches;
  bool? forResitOnly;
  bool? needMultipleSubmissionEditor;

  factory AddAssessmentRequest.fromJson(Map<String, dynamic> json) => AddAssessmentRequest(
    dueDate: DateTime.parse(json["dueDate"]),
    startDate: DateTime.parse(json["startDate"]),
    contents: json["contents"],
    lessonSlug: json["lessonSlug"],
    forResitOnly: json["forResitOnly"],
    needMultipleSubmissionEditor: json["needMultipleSubmissionEditor"],
    batches: List<String>.from(json["batches"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "dueDate": dueDate?.toIso8601String(),
    "startDate": startDate?.toIso8601String(),
    "contents": contents,
    "lessonSlug": lessonSlug,
    "forResitOnly": forResitOnly,
    "needMultipleSubmissionEditor": needMultipleSubmissionEditor,
    "batches": List<dynamic>.from(batches!.map((x) => x)),
  };
}
