// To parse this JSON data, do
//
//     final miscVariableResponse = miscVariableResponseFromJson(jsonString);

import 'dart:convert';

MiscVariableResponse miscVariableResponseFromJson(String str) => MiscVariableResponse.fromJson(json.decode(str));

String miscVariableResponseToJson(MiscVariableResponse data) => json.encode(data.toJson());

class MiscVariableResponse {
  bool ?success;
  List<Variable>? variables;

  MiscVariableResponse({
    this.success,
    this.variables,
  });

  factory MiscVariableResponse.fromJson(Map<String, dynamic> json) => MiscVariableResponse(
    success: json["success"],
    variables:  json["variables"] == null ? null :List<Variable>.from(json["variables"].map((x) => Variable.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "variables": variables  == null ? null : List<dynamic>.from(variables!.map((x) => x.toJson())),
  };
}

class Variable {
  List<dynamic> ? blockedInstitution;
  String ? id;
  String ? institution;
  String ? key;
  String ? displayName;

  Variable({
    this.blockedInstitution,
    this.id,
    this.institution,
    this.key,
    this.displayName,
  });

  factory Variable.fromJson(Map<String, dynamic> json) => Variable(
    blockedInstitution: List<dynamic>.from(json["blockedInstitution"].map((x) => x)),
    id: json["_id"],
    institution: json["institution"],
    key: json["key"],
    displayName: json["displayName"],
  );

  Map<String, dynamic> toJson() => {
    "blockedInstitution": List<dynamic>.from(blockedInstitution!.map((x) => x)),
    "_id": id,
    "institution": institution,
    "key": key,
    "displayName": displayName,
  };
}
