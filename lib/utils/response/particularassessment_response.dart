import 'dart:convert';

Particularassessmentresponse particularassessmentresponseFromJson(String str) =>
    Particularassessmentresponse.fromJson(json.decode(str));

String particularassessmentresponseToJson(Particularassessmentresponse data) =>
    json.encode(data.toJson());

class Particularassessmentresponse {
  Particularassessmentresponse({
    this.success,
    this.assessment,
    this.isPoll,
  });

  bool? success;
  List<Assessment>? assessment;
  bool? isPoll;

  factory Particularassessmentresponse.fromJson(Map<String, dynamic> json) =>
      Particularassessmentresponse(
        success: json["success"],
        assessment: List<Assessment>.from(
            json["assessment"].map((x) => Assessment.fromJson(x))),
        isPoll: json["isPoll"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "assessment": List<dynamic>.from(assessment!.map((x) => x.toJson())),
    "isPoll": isPoll,
  };
}

class Assessment {
  Assessment({
    this.submission,
    this.batches,
    this.id,
    this.dueDate,
    this.contents,
    this.createdAt,
    this.lessonSlug,
    this.institution,
  });

  List<String>? submission;
  List<String>? batches;
  String? id;
  DateTime? dueDate;
  String? contents;
  DateTime? createdAt;
  String? lessonSlug;
  String? institution;

  factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
    submission: List<String>.from(json["submission"].map((x) => x)),
    batches: List<String>.from(json["batches"].map((x) => x)),
    id: json["_id"],
    dueDate: DateTime.parse(json["dueDate"]),
    contents: json["contents"],
    createdAt: DateTime.parse(json["createdAt"]),
    lessonSlug: json["lessonSlug"],
    institution: json["institution"],
  );

  Map<String, dynamic> toJson() => {
    "submission": List<dynamic>.from(submission!.map((x) => x)),
    "batches": List<dynamic>.from(batches!.map((x) => x)),
    "_id": id,
    "dueDate": dueDate!.toIso8601String(),
    "contents": contents,
    "createdAt": createdAt!.toIso8601String(),
    "lessonSlug": lessonSlug,
    "institution": institution,
  };
}