// To parse this JSON data, do
//
//     final getGradesHeadingResponse = getGradesHeadingResponseFromJson(jsonString);

import 'dart:convert';

GetGradesHeadingResponse getGradesHeadingResponseFromJson(String str) => GetGradesHeadingResponse.fromJson(json.decode(str));

String getGradesHeadingResponseToJson(GetGradesHeadingResponse data) => json.encode(data.toJson());

class GetGradesHeadingResponse {
  GetGradesHeadingResponse({
    this.success,
    this.marksHeading,
  });

  bool ? success;
  MarksHeading ? marksHeading;

  factory GetGradesHeadingResponse.fromJson(Map<String, dynamic> json) => GetGradesHeadingResponse(
    success: json["success"],
    marksHeading: json["marksHeading"] != null ? MarksHeading.fromJson(json["marksHeading"]) : json["marksHeading"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "marksHeading": marksHeading?.toJson(),
  };
}

class MarksHeading {
  MarksHeading({
    this.batch,
    this.weightageType,
    this.isActive,
    this.allowMarksEntry,
    this.secondaryMarker,
    this.id,
    this.moduleSlug,
    this.marksTitle,
    this.institution,
    this.v,
    this.fullMark,
    this.passMark,
  });

  List<String> ? batch;
  String ? weightageType;
  bool ? isActive;
  bool ? allowMarksEntry;
  List<String> ? secondaryMarker;
  String ? id;
  String ? moduleSlug;
  List<MarksTitle> ? marksTitle;
  String ? institution;
  int  ? v;
  int ? fullMark;
  int ? passMark;

  factory MarksHeading.fromJson(Map<String, dynamic> json) => MarksHeading(
    batch: List<String>.from(json["batch"].map((x) => x)),
    weightageType: json["weightageType"],
    isActive: json["isActive"],
    allowMarksEntry: json["allowMarksEntry"],
    secondaryMarker: List<String>.from(json["secondaryMarker"].map((x) => x)),
    id: json["_id"],
    moduleSlug: json["moduleSlug"],
    marksTitle: List<MarksTitle>.from(json["marksTitle"].map((x) => MarksTitle.fromJson(x))),
    institution: json["institution"],
    v: json["__v"],
    fullMark: json["fullMark"],
    passMark: json["passMark"],
  );

  Map<String, dynamic> toJson() => {
    "batch": List<dynamic>.from(batch!.map((x) => x)),
    "weightageType": weightageType,
    "isActive": isActive,
    "allowMarksEntry": allowMarksEntry,
    "secondaryMarker": List<dynamic>.from(secondaryMarker!.map((x) => x)),
    "_id": id,
    "moduleSlug": moduleSlug,
    "marksTitle": List<dynamic>.from(marksTitle!.map((x) => x.toJson())),
    "institution": institution,
    "__v": v,
    "fullMark": fullMark,
    "passMark": passMark,
  };
}

class MarksTitle {
  MarksTitle({
    this.id,
    this.heading,
    this.weightage,
    this.optional,
  });

  String ? id;
  String ? heading;
  int ? weightage;
  bool ? optional;

  factory MarksTitle.fromJson(Map<String, dynamic> json) => MarksTitle(
    id: json["_id"],
    heading: json["heading"],
    weightage: json["weightage"],
    optional: json["optional"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "heading": heading,
    "weightage": weightage,
    "optional": optional,
  };
}
