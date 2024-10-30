import 'dart:convert';

OverallNewResultResponse overallNewResultResponseFromJson(String str) =>
    OverallNewResultResponse.fromJson(json.decode(str));

String overallNewResultResponseToJson(OverallNewResultResponse data) =>
    json.encode(data.toJson());

class OverallNewResultResponse {
  OverallNewResultResponse({
    this.success,
    this.overallResult,
  });

  bool? success;
  List<OverallResult>? overallResult;

  factory OverallNewResultResponse.fromJson(Map<String, dynamic> json) =>
      OverallNewResultResponse(
        success: json["success"],
        overallResult: json["overallResult"] == null
            ? null
            : List<OverallResult>.from(
                json["overallResult"].map((x) => OverallResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "overallResult": overallResult == null
            ? null
            : List<dynamic>.from(overallResult!.map((x) => x.toJson())),
      };
}

class OverallResult {
  OverallResult({
    this.totalMarks,
    this.grade,
    this.mark,
  });

  dynamic totalMarks;
  String? grade;
  List<OverallResultMark>? mark;

  factory OverallResult.fromJson(Map<String, dynamic> json) => OverallResult(
        totalMarks: json["totalMarks"].toDouble(),
        grade: json["grade"],
        mark: List<OverallResultMark>.from(
            json["mark"].map((x) => OverallResultMark.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalMarks": totalMarks,
        "grade": grade,
        "mark": List<dynamic>.from(mark!.map((x) => x.toJson())),
      };
}

class OverallResultMark {
  OverallResultMark({
    this.marks,
    this.module,
    this.mm,
    this.grade,
  });

  List<MarkMark>? marks;
  Module? module;
  String? mm;
  String? grade;

  factory OverallResultMark.fromJson(Map<String, dynamic> json) =>
      OverallResultMark(
        marks:
            List<MarkMark>.from(json["marks"].map((x) => MarkMark.fromJson(x))),
        module: Module.fromJson(json["module"]),
        mm: json["mm"] == null ? null : json["mm"],
        grade: json["grade"] == null ? null : json["grade"],
      );

  Map<String, dynamic> toJson() => {
        "marks": List<dynamic>.from(marks!.map((x) => x.toJson())),
        "module": module?.toJson(),
        "mm": mm == null ? null : mm,
        "grade": grade == null ? null : grade,
      };
}

class MarkMark {
  MarkMark({
    this.id,
    this.heading,
    this.marks,
  });

  String? id;
  String? heading;
  dynamic marks;

  factory MarkMark.fromJson(Map<String, dynamic> json) => MarkMark(
        id: json["_id"] == null ? null : json["_id"],
        heading: json["heading"] == null ? null : json["heading"],
        marks: json["marks"] == null ? null : json["marks"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "heading": heading == null ? null : heading,
        "marks": marks == null ? null : marks,
      };
}

class Module {
  Module({
    this.moduleTitle,
  });

  String? moduleTitle;

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        moduleTitle: json["moduleTitle"] == null ? null : json["moduleTitle"],
      );

  Map<String, dynamic> toJson() => {
        "moduleTitle": moduleTitle == null ? null : moduleTitle,
      };
}
