// To parse this JSON data, do
//
//     final getresultparentresponse = getresultparentresponseFromJson(jsonString);

import 'dart:convert';

Getresultparentresponse getresultparentresponseFromJson(String str) => Getresultparentresponse.fromJson(json.decode(str));

String getresultparentresponseToJson(Getresultparentresponse data) => json.encode(data.toJson());

class Getresultparentresponse {
  Getresultparentresponse({
    this.success,
    this.results,
  });

  bool ? success;
  List<dynamic> ? results;

  factory Getresultparentresponse.fromJson(Map<String, dynamic> json) => Getresultparentresponse(
    success: json["success"],
    results: List<dynamic>.from(json["results"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "results": List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}
