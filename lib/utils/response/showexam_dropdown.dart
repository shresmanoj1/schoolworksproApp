// To parse this JSON data, do
//
//     final ShowExamsDropDownResponse = ShowExamsDropDownResponseFromJson(jsonString);

import 'dart:convert';

ShowExamsDropDownResponse ShowExamsDropDownResponseFromJson(String str) =>
    ShowExamsDropDownResponse.fromJson(json.decode(str));

String ShowExamsDropDownResponseToJson(ShowExamsDropDownResponse data) =>
    json.encode(data.toJson());

class ShowExamsDropDownResponse {
  ShowExamsDropDownResponse({
    this.success,
    this.message,
    this.exams,
  });

  bool? success;
  String? message;
  List<Exam>? exams;

  factory ShowExamsDropDownResponse.fromJson(Map<String, dynamic> json) =>
      ShowExamsDropDownResponse(
        success: json["success"],
        message: json["message"],
        exams: json["exams"] == null
            ? null
            : List<Exam>.from(json["exams"].map((x) => Exam.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "exams": exams == null
            ? null
            : List<dynamic>.from(exams!.map((x) => x.toJson())),
      };
}

class Exam {
  Exam({
    this.id,
    this.examTitle,
    this.examSlug,
  });

  String? id;
  String? examTitle;
  String? examSlug;

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
        id: json["_id"] == null ? null : json["_id"],
        examTitle: json["examTitle"] == null ? null : json["examTitle"],
        examSlug: json["examSlug"] == null ? null : json["examSlug"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "examTitle": examTitle == null ? null : examTitle,
        "examSlug": examSlug == null ? null : examSlug,
      };
}
