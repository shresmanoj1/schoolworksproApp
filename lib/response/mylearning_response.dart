// To parse this JSON data, do
//
//     final mylearningresponse = mylearningresponseFromJson(jsonString);

import 'dart:convert';

Mylearningresponse mylearningresponseFromJson(String str) =>
    Mylearningresponse.fromJson(json.decode(str));

String mylearningresponseToJson(Mylearningresponse data) =>
    json.encode(data.toJson());

class Mylearningresponse {
  Mylearningresponse({
    this.success,
    this.message,
    this.modules,
  });

  bool? success;
  String? message;
  List<ModuleLearning>? modules;

  factory Mylearningresponse.fromJson(Map<String, dynamic> json) =>
      Mylearningresponse(
        success: json["success"],
        message: json["message"],
        modules: List<ModuleLearning>.from(
            json["modules"].map((x) => ModuleLearning.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "modules": List<dynamic>.from(modules!.map((x) => x.toJson())),
  };
}

class ModuleLearning {
  ModuleLearning({
    this.learnType,
    this.tags,
    this.publicLessons,
    this.currentBatch,
    this.accessTo,
    this.blockedUsers,
    this.usersWithAccess,
    this.isExtra,
    this.branches,
    this.isOptional,
    this.notGraded,
    this.optionalStudent,
    this.id,
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
    this.institution,
    this.alias,
    this.credit,
    this.progress,
  });

  String? learnType;
  List<String>? tags;
  List<dynamic>? publicLessons;
  List<String>? currentBatch;
  List<String>? accessTo;
  List<String>? blockedUsers;
  List<String>? usersWithAccess;
  bool? isExtra;
  List<dynamic>? branches;
  bool? isOptional;
  bool? notGraded;
  List<dynamic>? optionalStudent;
  String? id;
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
  String? institution;
  String? alias;
  String? credit;
  num? progress;

  factory ModuleLearning.fromJson(Map<String, dynamic> json) => ModuleLearning(
    learnType: json["learn_type"],
    tags: List<String>.from(json["tags"].map((x) => x)),
    publicLessons: List<dynamic>.from(json["public_lessons"].map((x) => x)),
    currentBatch: List<String>.from(json["currentBatch"].map((x) => x)),
    accessTo: List<String>.from(json["accessTo"].map((x) => x)),
    blockedUsers: List<String>.from(json["blockedUsers"].map((x) => x)),
    usersWithAccess:
    List<String>.from(json["usersWithAccess"].map((x) => x)),
    isExtra: json["isExtra"],
    branches: List<dynamic>.from(json["branches"].map((x) => x)),
    isOptional: json["isOptional"],
    notGraded: json["notGraded"],
    optionalStudent:
    List<dynamic>.from(json["optionalStudent"].map((x) => x)),
    id: json["_id"],
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
    institution: json["institution"],
    alias: json["alias"],
    credit: json["credit"],
    progress: json["progress"],
  );

  Map<String, dynamic> toJson() => {
    "learn_type": learnType,
    "tags": List<dynamic>.from(tags!.map((x) => x)),
    "public_lessons": List<dynamic>.from(publicLessons!.map((x) => x)),
    "currentBatch": List<dynamic>.from(currentBatch!.map((x) => x)),
    "accessTo": List<dynamic>.from(accessTo!.map((x) => x)),
    "blockedUsers": List<dynamic>.from(blockedUsers!.map((x) => x)),
    "usersWithAccess": List<dynamic>.from(usersWithAccess!.map((x) => x)),
    "isExtra": isExtra,
    "branches": List<dynamic>.from(branches!.map((x) => x)),
    "isOptional": isOptional,
    "notGraded": notGraded,
    "optionalStudent": List<dynamic>.from(optionalStudent!.map((x) => x)),
    "_id": id,
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
    "institution": institution,
    "alias": alias,
    "credit": credit,
    "progress": progress,
  };
}
