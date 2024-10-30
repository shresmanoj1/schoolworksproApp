// To parse this JSON data, do
//
//     final syllabusBatchModuleStatusResponse = syllabusBatchModuleStatusResponseFromJson(jsonString);

import 'dart:convert';

SyllabusBatchModuleStatusResponse syllabusBatchModuleStatusResponseFromJson(String str) => SyllabusBatchModuleStatusResponse.fromJson(json.decode(str));

String syllabusBatchModuleStatusResponseToJson(SyllabusBatchModuleStatusResponse data) => json.encode(data.toJson());

class SyllabusBatchModuleStatusResponse {
  bool? success;
  dynamic syllabus;

  SyllabusBatchModuleStatusResponse({
    this.success,
    this.syllabus,
  });

  factory SyllabusBatchModuleStatusResponse.fromJson(Map<String, dynamic> json) => SyllabusBatchModuleStatusResponse(
    success: json["success"],
    syllabus: json["syllabus"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "syllabus": syllabus,
  };
}

class Syllabus {
  dynamic id;
  List<Doc>? docs;

  Syllabus({
    this.id,
    this.docs,
  });

  factory Syllabus.fromJson(Map<String, dynamic> json) => Syllabus(
    id: json["_id"],
    docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id?.toJson(),
    "docs": List<dynamic>.from(docs!.map((x) => x.toJson())),
  };
}

class Doc {
  String? id;
  String? batch;
  String? lecturer;
  String? lesson;
  String? moduleSlug;
  String? remarks;
  String? status;
  String? institution;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic lessonData;
  int? v;

  Doc({
    this.id,
    this.batch,
    this.lecturer,
    this.lesson,
    this.moduleSlug,
    this.remarks,
    this.status,
    this.institution,
    this.createdAt,
    this.updatedAt,
    this.lessonData,
    this.v,
  });

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
    id: json["_id"],
    batch: json["batch"],
    lecturer: json["lecturer"],
    lesson: json["lesson"],
    moduleSlug: json["moduleSlug"],
    remarks: json["remarks"],
    status: json["status"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    lessonData: json["lessonData"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "batch": batch,
    "lecturer": lecturer,
    "lesson": lesson,
    "moduleSlug": moduleSlug,
    "remarks": remarks,
    "status": status,
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "lessonData": lessonData.toJson(),
    "__v": v,
  };
}

