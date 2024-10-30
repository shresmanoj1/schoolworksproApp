// To parse this JSON data, do
//
//     final assignmentPlagReportResponse = assignmentPlagReportResponseFromJson(jsonString);

import 'dart:convert';

AssignmentPlagResultResponse assignmentPlagReportResponseFromJson(String str) => AssignmentPlagResultResponse.fromJson(json.decode(str));

String assignmentPlagReportResponseToJson(AssignmentPlagResultResponse data) => json.encode(data.toJson());

class AssignmentPlagResultResponse {
  AssignmentPlagResultResponse({
    this.success,
    this.plagDict,
    this.data,
    this.df,
    this.details,
    this.hasOutput,
    this.url,
  });

  bool? success;
  PlagDict? plagDict;
  List<dynamic>? data;
  List<dynamic>? df;
  Details? details;
  bool? hasOutput;
  String? url;

  factory AssignmentPlagResultResponse.fromJson(Map<String, dynamic> json) => AssignmentPlagResultResponse(
    success: json["success"],
    plagDict: PlagDict.fromJson(json["plag_dict"]),
    data: List<dynamic>.from(json["data"].map((x) => x)),
    df: json["df"],
    details: Details.fromJson(json["details"]),
    hasOutput: json["hasOutput"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "plag_dict": plagDict?.toJson(),
    "data": List<dynamic>.from(data!.map((x) => x)),
    "df": df,
    "details": details?.toJson(),
    "hasOutput": hasOutput,
    "url": url,
  };
}

class Details {
  Details({
    this.date,
    this.totalWords,
    this.totalSources,
    this.totalPercentage,
    this.ttl,
  });

  String? date;
  int? totalWords;
  int? totalSources;
  double? totalPercentage;
  double? ttl;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    date: json["date"],
    totalWords: json["total_words"],
    totalSources: json["total_sources"],
    totalPercentage: json["total_percentage"].toDouble(),
    ttl: json["ttl"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "total_words": totalWords,
    "total_sources": totalSources,
    "total_percentage": totalPercentage,
    "ttl": ttl,
  };
}

class Dimensions {
  Dimensions({
    this.width,
    this.height,
  });

  double? width;
  double? height;

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
    width: json["width"].toDouble(),
    height: json["height"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "width": width,
    "height": height,
  };
}

class PlagDict {
  PlagDict();

  factory PlagDict.fromJson(Map<String, dynamic> json) => PlagDict(
  );

  Map<String, dynamic> toJson() => {
  };
}
