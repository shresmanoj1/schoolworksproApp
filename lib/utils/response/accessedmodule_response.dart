// To parse this JSON data, do
//
//     final accessedmoduleresponse = accessedmoduleresponseFromJson(jsonString);

import 'dart:convert';

Accessedmoduleresponse accessedmoduleresponseFromJson(String str) =>
    Accessedmoduleresponse.fromJson(json.decode(str));

String accessedmoduleresponseToJson(Accessedmoduleresponse data) =>
    json.encode(data.toJson());

class Accessedmoduleresponse {
  Accessedmoduleresponse({
    this.success,
    this.modules,
  });

  bool? success;
  List<Module>? modules;

  factory Accessedmoduleresponse.fromJson(Map<String, dynamic> json) =>
      Accessedmoduleresponse(
        success: json["success"],
        modules:
            List<Module>.from(json["modules"].map((x) => Module.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "modules": List<dynamic>.from(modules!.map((x) => x.toJson())),
      };
}

class Module {
  Module({
    this.moduleTitle,
    this.moduleSlug,
  });

  String? moduleTitle;
  String? moduleSlug;

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        moduleTitle: json["moduleTitle"],
        moduleSlug: json["moduleSlug"],
      );

  Map<String, dynamic> toJson() => {
        "moduleTitle": moduleTitle,
        "moduleSlug": moduleSlug,
      };
}
