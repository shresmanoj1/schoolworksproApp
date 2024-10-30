// To parse this JSON data, do
//
//     final studentStudyMaterialResponse = studentStudyMaterialResponseFromJson(jsonString);

import 'dart:convert';

StudentStudyMaterialResponse studentStudyMaterialResponseFromJson(String str) => StudentStudyMaterialResponse.fromJson(json.decode(str));

String studentStudyMaterialResponseToJson(StudentStudyMaterialResponse data) => json.encode(data.toJson());

class StudentStudyMaterialResponse {
  StudentStudyMaterialResponse({
    this.success,
    this.count,
    this.weeks,
  });

  bool? success;
  int? count;
  List<Week>? weeks;

  factory StudentStudyMaterialResponse.fromJson(Map<String, dynamic> json) => StudentStudyMaterialResponse(
    success: json["success"],
    count: json["count"],
    weeks: List<Week>.from(json["weeks"].map((x) => Week.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "weeks": List<dynamic>.from(weeks!.map((x) => x.toJson())),
  };
}

class Week {
  Week({
    this.week,
    this.files,
  });

  String? week;
  List<FileElement>? files;

  factory Week.fromJson(Map<String, dynamic> json) => Week(
    week: json["week"],
    files: List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "week": week,
    "files": List<dynamic>.from(files!.map((x) => x.toJson())),
  };
}

class FileElement {
  FileElement({
    this.originalname,
    this.filename,
  });

  String? originalname;
  String? filename;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    originalname: json["originalname"],
    filename: json["filename"],
  );

  Map<String, dynamic> toJson() => {
    "originalname": originalname,
    "filename": filename,
  };
}
