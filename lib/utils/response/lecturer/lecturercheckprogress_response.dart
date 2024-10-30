// To parse this JSON data, do
//
//     final lecturerCheckProgressResponse = lecturerCheckProgressResponseFromJson(jsonString);

import 'dart:convert';

LecturerCheckProgressResponse lecturerCheckProgressResponseFromJson(String str) => LecturerCheckProgressResponse.fromJson(json.decode(str));

String lecturerCheckProgressResponseToJson(LecturerCheckProgressResponse data) => json.encode(data.toJson());

class LecturerCheckProgressResponse {
  LecturerCheckProgressResponse({
    this.success,
    this.progress,
    this.weeks,
  });

  bool ? success;
  List<Progress> ? progress;
  List<String> ? weeks;

  factory LecturerCheckProgressResponse.fromJson(Map<String, dynamic> json) => LecturerCheckProgressResponse(
    success: json["success"],
    progress: List<Progress>.from(json["progress"].map((x) => Progress.fromJson(x))),
    weeks: List<String>.from(json["weeks"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "progress": List<dynamic>.from(progress!.map((x) => x.toJson())),
    "weeks": List<dynamic>.from(weeks!.map((x) => x)),
  };
}

class Progress {
  Progress({
    this.batches,
    this.id,
    this.moduleSlug,
    this.week,
    this.lecturer,
    this.institution,
    this.createdAt,
    this.updatedAt,
  });

  List<String> ? batches;
  String ? id;
  String ? moduleSlug;
  String ? week;
  String ? lecturer;
  String ? institution;
  DateTime ? createdAt;
  DateTime ? updatedAt;

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
    batches: List<String>.from(json["batches"].map((x) => x)),
    id: json["_id"],
    moduleSlug: json["moduleSlug"],
    week: json["week"],
    lecturer: json["lecturer"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "batches": List<dynamic>.from(batches!.map((x) => x)),
    "_id": id,
    "moduleSlug": moduleSlug,
    "week": week,
    "lecturer": lecturer,
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
