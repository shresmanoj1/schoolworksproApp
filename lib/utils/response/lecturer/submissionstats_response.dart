// To parse this JSON data, do
//
//     final submissionStatsResponse = submissionStatsResponseFromJson(jsonString);

import 'dart:convert';

SubmissionStatsResponse submissionStatsResponseFromJson(String str) =>
    SubmissionStatsResponse.fromJson(json.decode(str));

String submissionStatsResponseToJson(SubmissionStatsResponse data) =>
    json.encode(data.toJson());

class SubmissionStatsResponse {
  SubmissionStatsResponse({
    this.success,
    this.submission,
  });

  bool? success;
  List<SubmissionElement>? submission;

  factory SubmissionStatsResponse.fromJson(Map<String, dynamic> json) =>
      SubmissionStatsResponse(
        success: json["success"],
        submission: List<SubmissionElement>.from(
            json["submission"].map((x) => SubmissionElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "submission": List<dynamic>.from(submission!.map((x) => x.toJson())),
      };
}

class SubmissionElement {
  SubmissionElement({
    this.username,
    this.firstname,
    this.lastname,
    this.batch,
    this.submission,
  });

  String? username;
  String? firstname;
  String? lastname;
  String? batch;
  SubmissionSubmission? submission;

  factory SubmissionElement.fromJson(Map<String, dynamic> json) =>
      SubmissionElement(
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        batch: json["batch"],
        submission: json["submission"] == null
            ? null
            : SubmissionSubmission.fromJson(json["submission"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "batch": batch,
        "submission": submission == null ? null : submission?.toJson(),
      };
}

class SubmissionSubmission {
  SubmissionSubmission({
    this.id,
    this.submittedBy,
    this.contents,
    this.createdAt,
    this.updatedAt,
    this.institution,
    this.feedback,
  });

  String? id;
  String? submittedBy;
  String? contents;
  String? feedback;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? institution;

  factory SubmissionSubmission.fromJson(Map<String, dynamic> json) =>
      SubmissionSubmission(
        id: json["_id"],
        submittedBy: json["submittedBy"],
        contents: json["contents"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        institution: json["institution"],
        feedback: json["feedback"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "submittedBy": submittedBy,
        "contents": contents,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "institution": institution,
        "feedback": feedback,
      };
}
