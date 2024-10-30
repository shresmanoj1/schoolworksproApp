// To parse this JSON data, do
//
//     final getSubmissionsForStatsResponse = getSubmissionsForStatsResponseFromJson(jsonString);

import 'dart:convert';

GetSubmissionsForStatsResponse getSubmissionsForStatsResponseFromJson(
        String str) =>
    GetSubmissionsForStatsResponse.fromJson(json.decode(str));

String getSubmissionsForStatsResponseToJson(
        GetSubmissionsForStatsResponse data) =>
    json.encode(data.toJson());

class GetSubmissionsForStatsResponse {
  GetSubmissionsForStatsResponse({
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

  factory GetSubmissionsForStatsResponse.fromJson(Map<String, dynamic> json) =>
      GetSubmissionsForStatsResponse(
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
        "module": module?.toJson(),
        "lesson": lesson?.toJson(),
        "assessment": assessment?.toJson(),
      };
}

class Assessment {
  Assessment({
    this.batches,
    this.id,
    this.dueDate,
    this.contents,
    this.createdAt,
    this.lessonSlug,
    this.institution,
  });

  List<String>? batches;
  String? id;
  DateTime? dueDate;
  String? contents;
  DateTime? createdAt;
  String? lessonSlug;
  String? institution;

  factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
        batches: List<String>.from(json["batches"].map((x) => x)),
        id: json["_id"],
        dueDate: DateTime.parse(json["dueDate"]),
        contents: json["contents"],
        createdAt: DateTime.parse(json["createdAt"]),
        lessonSlug: json["lessonSlug"],
        institution: json["institution"],
      );

  Map<String, dynamic> toJson() => {
        "batches": List<dynamic>.from(batches!.map((x) => x)),
        "_id": id,
        "dueDate": dueDate?.toIso8601String(),
        "contents": contents,
        "createdAt": createdAt?.toIso8601String(),
        "lessonSlug": lessonSlug,
        "institution": institution,
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
