// To parse this JSON data, do
//
//     final groupResultModuleResponse = groupResultModuleResponseFromJson(jsonString);

import 'dart:convert';

GroupResultModuleResponse groupResultModuleResponseFromJson(String str) => GroupResultModuleResponse.fromJson(json.decode(str));

String groupResultModuleResponseToJson(GroupResultModuleResponse data) => json.encode(data.toJson());

class GroupResultModuleResponse {
  GroupResultModuleResponse({
    this.success,
    this.groupResult,
    this.examSlugList,
  });

  bool? success;
  GroupResult? groupResult;
  List<dynamic>? examSlugList;

  factory GroupResultModuleResponse.fromJson(Map<String, dynamic> json) => GroupResultModuleResponse(
    success: json["success"],
    groupResult: json["groupResult"] == null ? GroupResult() :  GroupResult.fromJson(json["groupResult"]),
    examSlugList: List<dynamic>.from(json["examSlugList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "groupResult": groupResult?.toJson(),
    "examSlugList": List<dynamic>.from(examSlugList!.map((x) => x)),
  };
}

class GroupResult {
  GroupResult({
    this.isActive,
    this.moduleSlug,
    this.id,
    this.identifier,
    this.groups,
    this.institution,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  bool? isActive;
  List<String>? moduleSlug;
  String? id;
  String? identifier;
  List<Group>? groups;
  String? institution;
  String? addedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? v;

  factory GroupResult.fromJson(Map<String, dynamic> json) => GroupResult(
    isActive: json["isActive"],
    moduleSlug: List<String>.from(json["moduleSlug"].map((x) => x)),
    id: json["_id"],
    identifier: json["identifier"],
    groups: List<Group>.from(json["groups"].map((x) => Group.fromJson(x))),
    institution: json["institution"],
    addedBy: json["addedBy"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "isActive": isActive,
    "moduleSlug": List<dynamic>.from(moduleSlug!.map((x) => x)),
    "_id": id,
    "identifier": identifier,
    "groups": List<dynamic>.from(groups!.map((x) => x.toJson())),
    "institution": institution,
    "addedBy": addedBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Group {
  Group({
    this.totalCalcCondition,
    this.id,
    this.title,
    this.totalWeightage,
    this.calculationType,
    this.groupType,
    this.headings,
  });

  TotalCalcCondition? totalCalcCondition;
  String? id;
  String? title;
  num? totalWeightage;
  String? calculationType;
  String? groupType;
  List<Heading>? headings;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    totalCalcCondition: TotalCalcCondition.fromJson(json["totalCalcCondition"]),
    id: json["_id"],
    title: json["title"],
    totalWeightage: json["totalWeightage"],
    calculationType: json["calculationType"],
    groupType: json["groupType"],
    headings: List<Heading>.from(json["headings"].map((x) => Heading.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalCalcCondition": totalCalcCondition?.toJson(),
    "_id": id,
    "title": title,
    "totalWeightage": totalWeightage,
    "calculationType": calculationType,
    "groupType": groupType,
    "headings": List<dynamic>.from(headings!.map((x) => x.toJson())),
  };
}

class Heading {
  Heading({
    this.id,
    this.title,
    this.weightage,
    this.outOf,
    this.examSlug
  });

  String? id;
  String? title;
  num? weightage;
  num? outOf;
  String? examSlug;

  factory Heading.fromJson(Map<String, dynamic> json) => Heading(
    id: json["_id"],
    title: json["title"],
    examSlug: json["examSlug"],
    weightage: json["weightage"],
    outOf: json["outOf"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "examSlug": examSlug,
    "weightage": weightage,
    "outOf": outOf,
  };
}

class TotalCalcCondition {
  TotalCalcCondition({
    this.key,
    this.condition,
  });

  String? key;
  String? condition;

  factory TotalCalcCondition.fromJson(Map<String, dynamic> json) => TotalCalcCondition(
    key: json["key"],
    condition: json["condition"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "condition": condition,
  };
}
