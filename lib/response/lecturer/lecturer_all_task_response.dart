// To parse this JSON data, do
//
//     final lecturerAllTaskResponse = lecturerAllTaskResponseFromJson(jsonString);

import 'dart:convert';

LecturerAllTaskResponse lecturerAllTaskResponseFromJson(String str) => LecturerAllTaskResponse.fromJson(json.decode(str));

String lecturerAllTaskResponseToJson(LecturerAllTaskResponse data) => json.encode(data.toJson());

class LecturerAllTaskResponse {
  LecturerAllTaskResponse({
    this.success,
    this.assessments,
  });

  bool? success;
  List<Assessment>? assessments;

  factory LecturerAllTaskResponse.fromJson(Map<String, dynamic> json) => LecturerAllTaskResponse(
    success: json["success"],
    assessments: List<Assessment>.from(json["assessments"].map((x) => Assessment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "assessments": List<dynamic>.from(assessments!.map((x) => x.toJson())),
  };
}

class Assessment {
  Assessment({
    this.submission,
    this.batches,
    this.resit,
    this.forResitOnly,
    this.submissions,
    this.id,
    this.dueDate,
    this.contents,
    this.institution,
    this.deadlineExtendedStudents,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.moduleSlug,
    this.moduleTitle,
    this.lessonTitle,
    this.moduleAlias,
  });

  List<String>? submission;
  List<String>? batches;
  List<dynamic>? resit;
  bool? forResitOnly;
  List<dynamic>? submissions;
  String? id;
  DateTime? dueDate;
  String? contents;
  String? institution;
  List<dynamic>? deadlineExtendedStudents;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? moduleSlug;
  String? moduleTitle;
  String? lessonTitle;
  String? moduleAlias;

  factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
    submission: List<String>.from(json["submission"].map((x) => x)),
    batches: List<String>.from(json["batches"].map((x) => x)),
    resit: List<dynamic>.from(json["resit"].map((x) => x)),
    forResitOnly: json["forResitOnly"],
    submissions: List<dynamic>.from(json["submissions"].map((x) => x)),
    id: json["_id"],
    dueDate: DateTime.parse(json["dueDate"]),
    contents: json["contents"],
    institution: json["institution"],
    deadlineExtendedStudents: List<dynamic>.from(json["deadlineExtendedStudents"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    moduleSlug: json["moduleSlug"],
    moduleTitle: json["moduleTitle"],
    lessonTitle: json["lessonTitle"],
    moduleAlias: json["moduleAlias"],
  );

  Map<String, dynamic> toJson() => {
    "submission": List<dynamic>.from(submission!.map((x) => x)),
    "batches": List<dynamic>.from(batches!.map((x) => x)),
    "resit": List<dynamic>.from(resit!.map((x) => x)),
    "forResitOnly": forResitOnly,
    "submissions": List<dynamic>.from(submissions!.map((x) => x)),
    "_id": id,
    "dueDate": dueDate?.toIso8601String(),
    "contents": contents,
    "institution": institution,
    "deadlineExtendedStudents": List<dynamic>.from(deadlineExtendedStudents!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "moduleSlug": moduleSlug,
    "moduleTitle": moduleTitle,
    "lessonTitle": lessonTitle,
    "moduleAlias": moduleAlias,
  };
}
