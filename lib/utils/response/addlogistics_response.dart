// To parse this JSON data, do
//
//     final addlogisticsresponse = addlogisticsresponseFromJson(jsonString);

import 'dart:convert';

Addlogisticsresponse addlogisticsresponseFromJson(String str) =>
    Addlogisticsresponse.fromJson(json.decode(str));

String addlogisticsresponseToJson(Addlogisticsresponse data) =>
    json.encode(data.toJson());

class Addlogisticsresponse {
  Addlogisticsresponse({
    this.success,
    this.message,
    this.logistics,
  });

  bool? success;
  String? message;
  Logistics? logistics;

  factory Addlogisticsresponse.fromJson(Map<String, dynamic> json) =>
      Addlogisticsresponse(
        success: json["success"],
        message: json["message"],
        logistics: Logistics.fromJson(json["logistics"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "logistics": logistics!.toJson(),
      };
}

class Logistics {
  Logistics({
    this.studentList,
    this.id,
    this.status,
    this.projectType,
    this.moduleSlug,
    this.inventoryRequested,
    this.requestedBy,
    this.institution,
    this.feedback,
    this.createdAt,
  });

  List<String?>? studentList;
  String? id;
  String? status;
  String? projectType;
  String? moduleSlug;
  List<InventoryRequested>? inventoryRequested;
  String? requestedBy;
  String? institution;
  List<dynamic>? feedback;
  DateTime? createdAt;

  factory Logistics.fromJson(Map<String, dynamic> json) => Logistics(
        studentList: List<String>.from(json["student_list"].map((x) => x)),
        id: json["_id"],
        status: json["status"],
        projectType: json["project_type"],
        moduleSlug: json["moduleSlug"],
        inventoryRequested: List<InventoryRequested>.from(
            json["inventoryRequested"]
                .map((x) => InventoryRequested.fromJson(x))),
        requestedBy: json["requestedBy"],
        institution: json["institution"],
        feedback: List<dynamic>.from(json["feedback"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "student_list": List<dynamic>.from(studentList!.map((x) => x)),
        "_id": id,
        "status": status,
        "project_type": projectType,
        "moduleSlug": moduleSlug,
        "inventoryRequested":
            List<dynamic>.from(inventoryRequested!.map((x) => x.toJson())),
        "requestedBy": requestedBy,
        "institution": institution,
        "feedback": List<dynamic>.from(feedback!.map((x) => x)),
        "createdAt": createdAt!.toIso8601String(),
      };
}

class InventoryRequested {
  InventoryRequested({
    this.returned,
    this.status,
    this.id,
    this.item,
    this.quantity,
  });

  bool? returned;
  String? status;
  String? id;
  String? item;
  String? quantity;

  factory InventoryRequested.fromJson(Map<String, dynamic> json) =>
      InventoryRequested(
        returned: json["returned"],
        status: json["status"],
        id: json["_id"],
        item: json["item"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "returned": returned,
        "status": status,
        "_id": id,
        "item": item,
        "quantity": quantity,
      };
}
