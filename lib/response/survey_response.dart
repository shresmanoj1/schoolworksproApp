// To parse this JSON data, do
//
//     final surveyresponse = surveyresponseFromJson(jsonString);

import 'dart:convert';

Surveyresponse surveyresponseFromJson(String str) =>
    Surveyresponse.fromJson(json.decode(str));

String surveyresponseToJson(Surveyresponse data) => json.encode(data.toJson());

class Surveyresponse {
  Surveyresponse({
    this.success,
    this.message,
    this.survey,
  });

  bool? success;
  String? message;
  List<Survey>? survey;

  factory Surveyresponse.fromJson(Map<String, dynamic> json) => Surveyresponse(
        success: json["success"],
        message: json["message"],
        survey:
            List<Survey>.from(json["survey"].map((x) => Survey.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "survey": List<dynamic>.from(survey!.map((x) => x.toJson())),
      };
}

class Survey {
  Survey({
    this.completedBy,
    this.type,
    this.batch,
    this.id,
    this.surveyName,
    this.content,
    this.institution,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  List<String>? completedBy;
  String? type;
  List<String>? batch;
  String? id;
  String? surveyName;
  List<Content>? content;
  String? institution;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory Survey.fromJson(Map<String, dynamic> json) => Survey(
        completedBy: List<String>.from(json["completedBy"].map((x) => x)),
        type: json["type"],
        batch: List<String>.from(json["batch"].map((x) => x)),
        id: json["_id"],
        surveyName: json["surveyName"],
        content:
            List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
        institution: json["institution"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "completedBy": List<dynamic>.from(completedBy!.map((x) => x)),
        "type": type,
        "batch": List<dynamic>.from(batch!.map((x) => x)),
        "_id": id,
        "surveyName": surveyName,
        "content": List<dynamic>.from(content!.map((x) => x.toJson())),
        "institution": institution,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
      };
}

class Content {
  Content({
    this.id,
    this.question,
    this.options,
  });

  String? id;
  String? question;
  List<Option>? options;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["_id"],
        question: json["question"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "question": question,
        "options": List<dynamic>.from(options!.map((x) => x.toJson())),
      };
}

class Option {
  Option({
    this.chosenBy,
    this.id,
    this.option,
  });

  List<String>? chosenBy;
  String? id;
  String? option;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        chosenBy: List<String>.from(json["chosenBy"].map((x) => x)),
        id: json["_id"],
        option: json["option"],
      );

  Map<String, dynamic> toJson() => {
        "chosenBy": List<dynamic>.from(chosenBy!.map((x) => x)),
        "_id": id,
        "option": option,
      };
}
