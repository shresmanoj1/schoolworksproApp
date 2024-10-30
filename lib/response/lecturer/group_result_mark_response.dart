// To parse this JSON data, do
//
//     final groupResultMarkResponse = groupResultMarkResponseFromJson(jsonString);

import 'dart:convert';

GroupResultMarkResponse groupResultMarkResponseFromJson(String str) => GroupResultMarkResponse.fromJson(json.decode(str));

String groupResultMarkResponseToJson(GroupResultMarkResponse data) => json.encode(data.toJson());

class GroupResultMarkResponse {
  GroupResultMarkResponse({
    this.success,
    this.marks,
  });

  bool? success;
  List<GroupResultMarkResponseMark>? marks;

  factory GroupResultMarkResponse.fromJson(Map<String, dynamic> json) => GroupResultMarkResponse(
    success: json["success"],
    marks: List<GroupResultMarkResponseMark>.from(json["marks"].map((x) => GroupResultMarkResponseMark.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "marks": List<dynamic>.from(marks!.map((x) => x.toJson())),
  };
}

class GroupResultMarkResponseMark {
  GroupResultMarkResponseMark({
    this.status,
    this.id,
    this.username,
    this.marks,
    this.resultType,
    this.moduleSlug,
    this.batch,
    this.groupResult,
    this.overall,
    this.calculatedOverall,
    this.addedBy,
    this.institution,
    this.v,
    this.createdAt,
    this.updatedAt,
  });

  String? status;
  String? id;
  String? username;
  List<MarkMark>? marks;
  String? resultType;
  String? moduleSlug;
  String? batch;
  String? groupResult;
  String? overall;
  String? calculatedOverall;
  String? addedBy;
  String? institution;
  num? v;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory GroupResultMarkResponseMark.fromJson(Map<String, dynamic> json) => GroupResultMarkResponseMark(
    status: json["status"],
    id: json["_id"],
    username: json["username"],
    marks: List<MarkMark>.from(json["marks"].map((x) => MarkMark.fromJson(x))),
    resultType: json["resultType"],
    moduleSlug: json["moduleSlug"],
    batch: json["batch"],
    groupResult: json["groupResult"],
    overall: json["overall"],
    calculatedOverall: json["calculatedOverall"],
    addedBy: json["addedBy"],
    institution: json["institution"],
    v: json["__v"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "_id": id,
    "username": username,
    "marks": List<dynamic>.from(marks!.map((x) => x.toJson())),
    "resultType": resultType,
    "moduleSlug": moduleSlug,
    "batch": batch,
    "groupResult": groupResult,
    "overall": overall,
    "calculatedOverall": calculatedOverall,
    "addedBy": addedBy,
    "institution": institution,
    "__v": v,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class MarkMark {
  MarkMark({
    this.id,
    this.title,
    this.groupType,
    this.headings,
    this.total,
    this.calculatedTotal,
  });

  String? id;
  String? title;
  String? groupType;
  List<Heading>? headings;
  num? total;
  num? calculatedTotal;

  factory MarkMark.fromJson(Map<String, dynamic> json) => MarkMark(
    id: json["_id"],
    title: json["title"],
    groupType: json["groupType"],
    headings: List<Heading>.from(json["headings"].map((x) => Heading.fromJson(x))),
    total: json["total"],
    calculatedTotal: json["calculatedTotal"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "groupType": groupType,
    "headings": List<dynamic>.from(headings!.map((x) => x.toJson())),
    "total": total,
    "calculatedTotal": calculatedTotal,
  };
}


class Heading {
  Heading({
    this.id,
    this.title,
    this.marks,
    this.calculatedMarks,
  });

  String? id;
  String? title;
  num? marks;
  num? calculatedMarks;

  factory Heading.fromJson(Map<String, dynamic> json) => Heading(
    id: json["_id"],
    title: json["title"],
    marks: json["marks"],
    calculatedMarks: json["calculatedMarks"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "marks": marks,
    "calculatedMarks": calculatedMarks,
  };
}

