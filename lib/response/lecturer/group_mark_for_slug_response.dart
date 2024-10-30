// To parse this JSON data, do
//
//     final groupMarkForSlugResponse = groupMarkForSlugResponseFromJson(jsonString);

import 'dart:convert';

GroupMarkForSlugResponse groupMarkForSlugResponseFromJson(String str) => GroupMarkForSlugResponse.fromJson(json.decode(str));

String groupMarkForSlugResponseToJson(GroupMarkForSlugResponse data) => json.encode(data.toJson());

class GroupMarkForSlugResponse {
  GroupMarkForSlugResponse({
    this.success,
    this.allMarks,
    this.examFullMarks,
  });

  bool? success;
  List<AllMark>? allMarks;
  List<ExamFullMark>? examFullMarks;

  factory GroupMarkForSlugResponse.fromJson(Map<String, dynamic> json) => GroupMarkForSlugResponse(
    success: json["success"],
    allMarks: List<AllMark>.from(json["allMarks"].map((x) => AllMark.fromJson(x))),
    examFullMarks: List<ExamFullMark>.from(json["examFullMarks"].map((x) => ExamFullMark.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "allMarks": List<dynamic>.from(allMarks!.map((x) => x.toJson())),
    "examFullMarks": List<dynamic>.from(examFullMarks!.map((x) => x.toJson())),
  };
}

class AllMark {
  AllMark({
    this.status,
    this.regular,
    this.id,
    this.examSlug,
    this.moduleSlug,
    this.batch,
    this.username,
    this.checkedBy,
    this.marks,
    this.mm,
    this.totalMm,
    this.grade,
    this.institution,
    this.isAbsent,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? status;
  bool? regular;
  String? id;
  String? examSlug;
  String? moduleSlug;
  String? batch;
  String? username;
  String? checkedBy;
  List<Mark>? marks;
  String? mm;
  String? totalMm;
  String? grade;
  String? institution;
  bool? isAbsent;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? v;

  factory AllMark.fromJson(Map<String, dynamic> json) => AllMark(
    status: json["status"],
    regular: json["regular"],
    id: json["_id"],
    examSlug: json["examSlug"],
    moduleSlug: json["moduleSlug"],
    batch: json["batch"],
    username: json["username"],
    checkedBy: json["checkedBy"],
    marks: List<Mark>.from(json["marks"].map((x) => Mark.fromJson(x))),
    mm: json["mm"],
    totalMm: json["total_mm"],
    grade: json["grade"],
    institution: json["institution"],
    isAbsent: json["isAbsent"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "regular": regular,
    "_id": id,
    "examSlug": examSlug,
    "moduleSlug": moduleSlug,
    "batch": batch,
    "username": username,
    "checkedBy": checkedBy,
    "marks": List<dynamic>.from(marks!.map((x) => x.toJson())),
    "mm": mm,
    "total_mm": totalMm,
    "grade": grade,
    "institution": institution,
    "isAbsent": isAbsent,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Mark {
  Mark({
    this.id,
    this.heading,
    this.marks,
    this.grade,
  });

  String? id;
  Heading? heading;
  num? marks;
  String? grade;

  factory Mark.fromJson(Map<String, dynamic> json) => Mark(
    id: json["_id"],
    heading: headingValues.map[json["heading"]],
    marks: json["marks"],
    grade: json["grade"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "heading": headingValues.reverse[heading],
    "marks": marks,
    "grade": grade,
  };
}

enum Heading { TH, PR }

final headingValues = EnumValues({
  "pr": Heading.PR,
  "th": Heading.TH
});

class ExamFullMark {
  ExamFullMark({
    this.examSlug,
    this.fullMark,
  });

  String? examSlug;
  num? fullMark;

  factory ExamFullMark.fromJson(Map<String, dynamic> json) => ExamFullMark(
    examSlug: json["examSlug"],
    fullMark: json["fullMark"],
  );

  Map<String, dynamic> toJson() => {
    "examSlug": examSlug,
    "fullMark": fullMark,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
