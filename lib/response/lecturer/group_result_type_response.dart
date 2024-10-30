// To parse this JSON data, do
//
//     final groupResultTypeResponse = groupResultTypeResponseFromJson(jsonString);

import 'dart:convert';

GroupResultTypeResponse groupResultTypeResponseFromJson(String str) => GroupResultTypeResponse.fromJson(json.decode(str));

String groupResultTypeResponseToJson(GroupResultTypeResponse data) => json.encode(data.toJson());

class GroupResultTypeResponse {
  GroupResultTypeResponse({
    this.success,
    this.allResultType,
  });

  bool? success;
  List<AllResultType>? allResultType;

  factory GroupResultTypeResponse.fromJson(Map<String, dynamic> json) => GroupResultTypeResponse(
    success: json["success"],
    allResultType: List<AllResultType>.from(json["allResultType"].map((x) => AllResultType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "allResultType": List<dynamic>.from(allResultType!.map((x) => x.toJson())),
  };
}

class AllResultType {
  AllResultType({
    this.batch,
    this.resitStudents,
    this.id,
    this.title,
    this.resultSlug,
    this.courseSlug,
    this.moduleSlug,
    this.institution,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  List<String>? batch;
  List<dynamic>? resitStudents;
  String? id;
  String? title;
  String? resultSlug;
  String? courseSlug;
  String? moduleSlug;
  String? institution;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? v;

  factory AllResultType.fromJson(Map<String, dynamic> json) => AllResultType(
    batch: List<String>.from(json["batch"].map((x) => x)),
    resitStudents: List<dynamic>.from(json["resitStudents"].map((x) => x)),
    id: json["_id"],
    title: json["title"],
    resultSlug: json["resultSlug"],
    courseSlug: json["courseSlug"],
    moduleSlug: json["moduleSlug"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "batch": List<dynamic>.from(batch!.map((x) => x)),
    "resitStudents": List<dynamic>.from(resitStudents!.map((x) => x)),
    "_id": id,
    "title": title,
    "resultSlug": resultSlug,
    "courseSlug": courseSlug,
    "moduleSlug": moduleSlug,
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
