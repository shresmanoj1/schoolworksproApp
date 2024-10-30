// To parse this JSON data, do
//
//     final lecturerAssignmentDetailsResponse = lecturerAssignmentDetailsResponseFromJson(jsonString);

import 'dart:convert';

LecturerAssignmentDetailsResponse lecturerAssignmentDetailsResponseFromJson(String str) => LecturerAssignmentDetailsResponse.fromJson(json.decode(str));

String lecturerAssignmentDetailsResponseToJson(LecturerAssignmentDetailsResponse data) => json.encode(data.toJson());

class LecturerAssignmentDetailsResponse {
  LecturerAssignmentDetailsResponse({
    this.success,
    this.submission,
  });

  bool? success;
  List<SubmissionElement>? submission;

  factory LecturerAssignmentDetailsResponse.fromJson(Map<String, dynamic> json) => LecturerAssignmentDetailsResponse(
    success: json["success"],
    submission: List<SubmissionElement>.from(json["submission"].map((x) => SubmissionElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "submission": List<dynamic>.from(submission!.map((x) => x.toJson())),
  };
}

class SubmissionElement {
  SubmissionElement({
    this.firstname,
    this.lastname,
    this.username,
    this.batch,
    this.submission,
    this.assignment,
  });

  String? firstname;
  String? lastname;
  String? username;
  String? batch;
  SubmissionSubmission? submission;
  Assignment? assignment;

  factory SubmissionElement.fromJson(Map<String, dynamic> json) => SubmissionElement(
    firstname: json["firstname"],
    lastname: json["lastname"],
    username: json["username"],
    batch: json["batch"],
    submission: json["submission"] == null ? null : SubmissionSubmission.fromJson(json["submission"]),
    assignment: Assignment.fromJson(json["assignment"]),
  );

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
    "batch": batch,
    "submission": submission == null ? null : submission?.toJson(),
    "assignment": assignment?.toJson(),
  };
}

class Assignment {
  Assignment({
    this.plagarismEnabled,
    this.resit,
    this.id,
    this.dueDate,
    this.moduleSlug,
    this.folderToUpload,
  });

  bool? plagarismEnabled;
  List<dynamic>? resit;
  String? id;
  DateTime? dueDate;
  String? moduleSlug;
  String? folderToUpload;

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
    plagarismEnabled: json["plagarismEnabled"],
    resit: List<dynamic>.from(json["resit"].map((x) => x)),
    id: json["_id"],
    dueDate: DateTime.parse(json["dueDate"]),
    moduleSlug: json["moduleSlug"],
    folderToUpload: json["folderToUpload"],
  );

  Map<String, dynamic> toJson() => {
    "plagarismEnabled": plagarismEnabled,
    "resit": List<dynamic>.from(resit!.map((x) => x)),
    "_id": id,
    "dueDate": dueDate?.toIso8601String(),
    "moduleSlug": moduleSlug,
    "folderToUpload": folderToUpload,
  };
}

class SubmissionSubmission {
  SubmissionSubmission({
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

  factory SubmissionSubmission.fromJson(Map<String, dynamic> json) => SubmissionSubmission(
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
