// To parse this JSON data, do
//
//     final addinventoryresponse = addinventoryresponseFromJson(jsonString);

import 'dart:convert';

Addinventoryresponse addinventoryresponseFromJson(String str) =>
    Addinventoryresponse.fromJson(json.decode(str));

String addinventoryresponseToJson(Addinventoryresponse data) =>
    json.encode(data.toJson());

class Addinventoryresponse {
  Addinventoryresponse({
    this.success,
    this.message,
    this.inventory,
  });

  bool? success;
  String? message;
  Inventory? inventory;

  factory Addinventoryresponse.fromJson(Map<String, dynamic> json) =>
      Addinventoryresponse(
        success: json["success"],
        message: json["message"],
        inventory: Inventory.fromJson(json["inventory"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "inventory": inventory!.toJson(),
      };
}

class Inventory {
  Inventory({
    this.inventoryRequested,
    this.studentList,
    this.id,
    this.moduleSlug,
    this.status,
    this.projectType,
    this.requestedBy,
    this.institution,
    this.feedback,
    this.createdAt,
  });

  List<String>? inventoryRequested;
  List<dynamic>? studentList;
  String? id;
  String? moduleSlug;
  String? status;
  String? projectType;
  String? requestedBy;
  String? institution;
  List<dynamic>? feedback;
  DateTime? createdAt;

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        inventoryRequested:
            List<String>.from(json["inventoryRequested"].map((x) => x)),
        studentList: List<dynamic>.from(json["student_list"].map((x) => x)),
        id: json["_id"],
        moduleSlug: json["moduleSlug"],
        status: json["status"],
        projectType: json["project_type"],
        requestedBy: json["requestedBy"],
        institution: json["institution"],
        feedback: List<dynamic>.from(json["feedback"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "inventoryRequested":
            List<dynamic>.from(inventoryRequested!.map((x) => x)),
        "student_list": List<dynamic>.from(studentList!.map((x) => x)),
        "_id": id,
        "moduleSlug": moduleSlug,
        "status": status,
        "project_type": projectType,
        "requestedBy": requestedBy,
        "institution": institution,
        "feedback": List<dynamic>.from(feedback!.map((x) => x)),
        "createdAt": createdAt!.toIso8601String(),
      };
}
