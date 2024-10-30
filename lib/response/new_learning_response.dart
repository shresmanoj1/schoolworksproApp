// To parse this JSON data, do
//
//     final newLearningResponse = newLearningResponseFromJson(jsonString);

import 'dart:convert';

NewLearningResponse newLearningResponseFromJson(String str) =>
    NewLearningResponse.fromJson(json.decode(str));

String newLearningResponseToJson(NewLearningResponse data) =>
    json.encode(data.toJson());

class NewLearningResponse {
  NewLearningResponse({
    this.success,
    this.message,
    this.modules,
  });

  bool? success;
  String? message;
  List<ModuleNew>? modules;

  factory NewLearningResponse.fromJson(Map<String, dynamic> json) =>
      NewLearningResponse(
        success: json["success"],
        message: json["message"],
        modules:
            List<ModuleNew>.from(json["modules"].map((x) => ModuleNew.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "modules": List<dynamic>.from(modules!.map((x) => x.toJson())),
      };
}

class ModuleNew {
  ModuleNew({
    this.id,
    this.learnType,
    this.tags,
    this.moduleTitle,
    this.moduleDesc,
    this.duration,
    this.weeklyStudy,
    this.year,
    this.benefits,
    this.moduleLeader,
    this.embeddedUrl,
    this.imageUrl,
    this.moduleSlug,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isExtra,
    this.currentBatch,
    this.institution,
    this.publicLessons,
    this.totalLesson,
    this.progress,
    this.completedLesson,
  });

  String? id;
  String? learnType;
  List<String>? tags;
  String? moduleTitle;
  String? moduleDesc;
  num? duration;
  num? weeklyStudy;
  String? year;
  String? benefits;
  String? moduleLeader;
  String? embeddedUrl;
  String? imageUrl;
  String? moduleSlug;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? v;
  bool? isExtra;
  List<String>? currentBatch;
  String? institution;
  List<PublicLesson>? publicLessons;
  num? totalLesson;
  num? progress;
  num? completedLesson;

  factory ModuleNew.fromJson(Map<String, dynamic> json) => ModuleNew(
        id: json["_id"],
        learnType: json["learn_type"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        moduleTitle: json["moduleTitle"],
        moduleDesc: json["moduleDesc"],
        duration: json["duration"],
        weeklyStudy: json["weekly_study"],
        year: json["year"],
        benefits: json["benefits"],
        moduleLeader: json["moduleLeader"],
        embeddedUrl: json["embeddedUrl"],
        imageUrl: json["imageUrl"],
        moduleSlug: json["moduleSlug"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        isExtra: json["isExtra"],
        currentBatch: List<String>.from(json["currentBatch"].map((x) => x)),
        institution: json["institution"],
        publicLessons: List<PublicLesson>.from(
            json["publicLessons"].map((x) => PublicLesson.fromJson(x))),
        totalLesson: json["totalLesson"],
        progress: json["progress"],
        completedLesson: json["completedLesson"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "learn_type": learnType,
        "tags": List<dynamic>.from(tags!.map((x) => x)),
        "moduleTitle": moduleTitle,
        "moduleDesc": moduleDesc,
        "duration": duration,
        "weekly_study": weeklyStudy,
        "year": year,
        "benefits": benefits,
        "moduleLeader": moduleLeader,
        "embeddedUrl": embeddedUrl,
        "imageUrl": imageUrl,
        "moduleSlug": moduleSlug,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "isExtra": isExtra,
        "currentBatch": List<dynamic>.from(currentBatch!.map((x) => x)),
        "institution": institution,
        "publicLessons":
            List<dynamic>.from(publicLessons!.map((x) => x.toJson())),
        "totalLesson": totalLesson,
        "progress": progress,
        "completedLesson": completedLesson,
      };
}

class PublicLesson {
  PublicLesson({
    this.id,
    this.type,
  });

  String? id;
  String? type;

  factory PublicLesson.fromJson(Map<String, dynamic> json) => PublicLesson(
        id: json["_id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
      };
}
