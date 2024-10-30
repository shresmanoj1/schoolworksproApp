// To parse this JSON data, do
//
//     final batchLessonProgress = batchLessonProgressFromJson(jsonString);

import 'dart:convert';

BatchLessonProgress batchLessonProgressFromJson(String str) => BatchLessonProgress.fromJson(json.decode(str));

String batchLessonProgressToJson(BatchLessonProgress data) => json.encode(data.toJson());

class BatchLessonProgress {
  bool? success;
  List<Syllabus>? syllabus;
  String? message;

  BatchLessonProgress({
    this.success,
    this.syllabus,
    this.message
  });

  factory BatchLessonProgress.fromJson(Map<String, dynamic> json) => BatchLessonProgress(
    success: json["success"],
    message: json["message"],
    syllabus: json["syllabus"] == null ? null : List<Syllabus>.from(json["syllabus"].map((x) => Syllabus.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "syllabus": List<dynamic>.from(syllabus!.map((x) => x.toJson())),
  };
}

class Syllabus {
  String? id;
  String? batch;
  String? lesson;
  String? remarks;
  String? moduleSlug;
  String? lecturer;
  String? status;
  String? institution;
  DateTime? createdAt;
  DateTime? updatedAt;

  Syllabus({
    this.id,
    this.batch,
    this.lesson,
    this.remarks,
    this.moduleSlug,
    this.lecturer,
    this.status,
    this.institution,
    this.createdAt,
    this.updatedAt,
  });

  factory Syllabus.fromJson(Map<String, dynamic> json) => Syllabus(
    id: json["_id"],
    batch: json["batch"],
    lesson: json["lesson"],
    remarks: json["remarks"],
    moduleSlug: json["moduleSlug"],
    lecturer: json["lecturer"],
    status: json["status"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "batch": batch,
    "lesson": lesson,
    "remarks": remarks,
    "moduleSlug": moduleSlug,
    "lecturer": lecturer,
    "status": status,
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
