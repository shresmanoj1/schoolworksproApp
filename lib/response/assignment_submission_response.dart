// To parse this JSON data, do
//
//     final assignmentSubmissionResponse = assignmentSubmissionResponseFromJson(jsonString);

import 'dart:convert';

AssignmentSubmissionResponse assignmentSubmissionResponseFromJson(String str) => AssignmentSubmissionResponse.fromJson(json.decode(str));

String assignmentSubmissionResponseToJson(AssignmentSubmissionResponse data) => json.encode(data.toJson());

class AssignmentSubmissionResponse {
  AssignmentSubmissionResponse({
    this.success,
    this.message,
    this.submission,
  });

  bool? success;
  String? message;
  dynamic? submission;

  factory AssignmentSubmissionResponse.fromJson(Map<String, dynamic> json) => AssignmentSubmissionResponse(
    success: json["success"],
    message: json["message"],
    submission: json["submission"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "submission": submission,
  };
}

class Submission {
  Submission({
    this.reportLoading,
    this.id,
    this.moduleSlug,
    this.assignment,
    this.contents,
    this.submittedBy,
    this.institution,
    this.createdAt,
    this.updatedAt,
  });

  String? reportLoading;
  String? id;
  String? moduleSlug;
  String? assignment;
  String? contents;
  String? submittedBy;
  String? institution;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Submission.fromJson(Map<String, dynamic> json) => Submission(
    reportLoading: json["reportLoading"],
    id: json["_id"],
    moduleSlug: json["moduleSlug"],
    assignment: json["assignment"],
    contents: json["contents"],
    submittedBy: json["submittedBy"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "reportLoading": reportLoading,
    "_id": id,
    "moduleSlug": moduleSlug,
    "assignment": assignment,
    "contents": contents,
    "submittedBy": submittedBy,
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
