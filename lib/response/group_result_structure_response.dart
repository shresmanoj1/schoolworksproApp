// To parse this JSON data, do
//
//     final groupResultStructureResponse = groupResultStructureResponseFromJson(jsonString);

import 'dart:convert';

GroupResultStructureResponse groupResultStructureResponseFromJson(String str) => GroupResultStructureResponse.fromJson(json.decode(str));

String groupResultStructureResponseToJson(GroupResultStructureResponse data) => json.encode(data.toJson());

class GroupResultStructureResponse {
  bool? success;
  List<AllResultStructure>? allResultStructure;
  List<String>? batchList;

  GroupResultStructureResponse({
    this.success,
    this.allResultStructure,
    this.batchList,
  });

  factory GroupResultStructureResponse.fromJson(Map<String, dynamic> json) => GroupResultStructureResponse(
    success: json["success"],
    allResultStructure: List<AllResultStructure>.from(json["allResultStructure"].map((x) => AllResultStructure.fromJson(x))),
    batchList: List<String>.from(json["batchList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "allResultStructure": List<dynamic>.from(allResultStructure!.map((x) => x.toJson())),
    "batchList": List<dynamic>.from(batchList!.map((x) => x)),
  };
}

class AllResultStructure {
  bool? isActive;
  List<String>? moduleSlug;
  String? id;
  String? identifier;
  List<Group>? groups;
  String? institution;
  String? addedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  AllResultStructure({
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

  factory AllResultStructure.fromJson(Map<String, dynamic> json) => AllResultStructure(
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
  TotalCalcCondition? totalCalcCondition;
  String? id;
  String? title;
  num? totalWeightage;
  String? calculationType;
  String? groupType;
  List<Heading>? headings;

  Group({
    this.totalCalcCondition,
    this.id,
    this.title,
    this.totalWeightage,
    this.calculationType,
    this.groupType,
    this.headings,
  });

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
  String? id;
  String? title;
  num? weightage;
  num? outOf;

  Heading({
    this.id,
    this.title,
    this.weightage,
    this.outOf,
  });

  factory Heading.fromJson(Map<String, dynamic> json) => Heading(
    id: json["_id"],
    title: json["title"],
    weightage: json["weightage"],
    outOf: json["outOf"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "weightage": weightage,
    "outOf": outOf,
  };
}

class TotalCalcCondition {
  String? key;
  String? condition;

  TotalCalcCondition({
    this.key,
    this.condition,
  });

  factory TotalCalcCondition.fromJson(Map<String, dynamic> json) => TotalCalcCondition(
    key: json["key"],
    condition: json["condition"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "condition": condition,
  };
}
