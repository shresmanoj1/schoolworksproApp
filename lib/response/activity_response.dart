// To parse this JSON data, do
//
//     final activityresponse = activityresponseFromJson(jsonString);

import 'dart:convert';

Activityresponse activityresponseFromJson(String str) =>
    Activityresponse.fromJson(json.decode(str));

String activityresponseToJson(Activityresponse data) =>
    json.encode(data.toJson());

class Activityresponse {
  Activityresponse({
    this.success,
    this.complete,
    this.incomplete,
    this.totalComplete,
    this.totalIncomplete,
  });

  bool? success;
  List<Complete>? complete;
  List<Complete>? incomplete;
  int? totalComplete;
  int? totalIncomplete;

  factory Activityresponse.fromJson(Map<String, dynamic> json) =>
      Activityresponse(
        success: json["success"],
        complete: List<Complete>.from(
            json["complete"].map((x) => Complete.fromJson(x))),
        incomplete: List<Complete>.from(
            json["incomplete"].map((x) => Complete.fromJson(x))),
        totalComplete: json["total_complete"],
        totalIncomplete: json["total_incomplete"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "complete": List<dynamic>.from(complete!.map((x) => x.toJson())),
        "incomplete": List<dynamic>.from(incomplete!.map((x) => x.toJson())),
        "total_complete": totalComplete,
        "total_incomplete": totalIncomplete,
      };
}

class Complete {
  Complete({
    this.module,
    this.lesson,
    this.assessment,
  });

  Module? module;
  Lesson? lesson;
  Assessment? assessment;

  factory Complete.fromJson(Map<String, dynamic> json) => Complete(
        module: Module.fromJson(json["module"]),
        lesson: Lesson.fromJson(json["lesson"]),
        assessment: Assessment.fromJson(json["assessment"]),
      );

  Map<String, dynamic> toJson() => {
        "module": module!.toJson(),
        "lesson": lesson!.toJson(),
        "assessment": assessment!.toJson(),
      };
}

class Assessment {
  Assessment({
    this.batches,
    this.resit,
    this.forResitOnly,
    this.submissions,
    this.id,
    this.dueDate,
    this.contents,
    this.lessonSlug,
    this.institution,
    this.deadlineExtendedStudents,
    this.createdAt,
  });

  List<dynamic>? batches;
  List<dynamic>? resit;
  bool? forResitOnly;
  List<dynamic>? submissions;
  String? id;
  DateTime? dueDate;
  String? contents;
  String? lessonSlug;
  String? institution;
  List<dynamic>? deadlineExtendedStudents;
  DateTime? createdAt;

  factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
        batches: List<dynamic>.from(json["batches"].map((x) => x)),
        resit: List<dynamic>.from(json["resit"].map((x) => x)),
        forResitOnly: json["forResitOnly"],
        submissions: List<dynamic>.from(json["submissions"].map((x) => x)),
        id: json["_id"],
        dueDate: DateTime.parse(json["dueDate"]),
        contents: json["contents"],
        lessonSlug: json["lessonSlug"],
        institution: json["institution"],
        deadlineExtendedStudents:
            List<dynamic>.from(json["deadlineExtendedStudents"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "batches": List<dynamic>.from(batches!.map((x) => x)),
        "resit": List<dynamic>.from(resit!.map((x) => x)),
        "forResitOnly": forResitOnly,
        "submissions": List<dynamic>.from(submissions!.map((x) => x)),
        "_id": id,
        "dueDate": dueDate?.toIso8601String(),
        "contents": contents,
        "lessonSlug": lessonSlug,
        "institution": institution,
        "deadlineExtendedStudents":
            List<dynamic>.from(deadlineExtendedStudents!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
      };
}

class Lesson {
  Lesson({
    this.id,
    this.lessonTitle,
    this.lessonSlug,
  });

  String? id;
  String? lessonTitle;
  String? lessonSlug;

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json["_id"],
        lessonTitle: json["lessonTitle"],
        lessonSlug: json["lessonSlug"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "lessonTitle": lessonTitle,
        "lessonSlug": lessonSlug,
      };
}

class Module {
  Module({
    this.blockedUsers,
    this.id,
    this.moduleTitle,
    this.moduleSlug,
  });

  List<String>? blockedUsers;
  String? id;
  String? moduleTitle;
  String? moduleSlug;

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        blockedUsers: List<String>.from(json["blockedUsers"].map((x) => x)),
        id: json["_id"],
        moduleTitle: json["moduleTitle"],
        moduleSlug: json["moduleSlug"],
      );

  Map<String, dynamic> toJson() => {
        "blockedUsers": List<dynamic>.from(blockedUsers!.map((x) => x)),
        "_id": id,
        "moduleTitle": moduleTitle,
        "moduleSlug": moduleSlug,
      };
}
