// To parse this JSON data, do
//
//     final ClassTecherGetClassResponse = ClassTecherGetClassResponseFromJson(jsonString);

import 'dart:convert';

ClassTecherGetClassResponse ClassTecherGetClassResponseFromJson(String str) => ClassTecherGetClassResponse.fromJson(json.decode(str));

String ClassTecherGetClassResponseToJson(ClassTecherGetClassResponse data) => json.encode(data.toJson());

class ClassTecherGetClassResponse {
  ClassTecherGetClassResponse({
    this.success,
    this.classes,
  });

  bool ? success;
  List<String> ? classes;

  factory ClassTecherGetClassResponse.fromJson(Map<String, dynamic> json) => ClassTecherGetClassResponse(
    success: json["success"],
    classes: List<String>.from(json["classes"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "classes": List<dynamic>.from(classes!.map((x) => x)),
  };
}
