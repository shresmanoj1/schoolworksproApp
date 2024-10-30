// To parse this JSON data, do
//
//     final viewlogisticsresponse = viewlogisticsresponseFromJson(jsonString);

import 'dart:convert';

Viewlogisticsresponse viewlogisticsresponseFromJson(String str) =>
    Viewlogisticsresponse.fromJson(json.decode(str));

String viewlogisticsresponseToJson(Viewlogisticsresponse data) =>
    json.encode(data.toJson());

class Viewlogisticsresponse {
  Viewlogisticsresponse({
    this.success,
    this.logistics,
  });

  bool? success;
  List<Logistic>? logistics;

  factory Viewlogisticsresponse.fromJson(Map<String, dynamic> json) =>
      Viewlogisticsresponse(
        success: json["success"],
        logistics: List<Logistic>.from(
            json["logistics"].map((x) => Logistic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "logistics": List<dynamic>.from(logistics!.map((x) => x.toJson())),
      };
}

class Logistic {
  Logistic({
    this.id,
    this.studentList,
    this.status,
    this.projectType,
    this.module,
    this.inventoryRequested,
    this.feedback,
  });

  String? id;
  List<String>? studentList;
  String? status;
  String? projectType;
  Module? module;
  List<InventoryRequested>? inventoryRequested;
  List<Feedback>? feedback;

  factory Logistic.fromJson(Map<String, dynamic> json) => Logistic(
        id: json["_id"],
        studentList: List<String>.from(json["student_list"].map((x) => x)),
        status: json["status"],
        projectType: json["project_type"],
        module: Module.fromJson(json["module"]),
        inventoryRequested: List<InventoryRequested>.from(
            json["inventoryRequested"]
                .map((x) => InventoryRequested.fromJson(x))),
        feedback: json["feedback"] == null
            ? null
            : List<Feedback>.from(
                json["feedback"].map((x) => Feedback.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "student_list": List<dynamic>.from(studentList!.map((x) => x)),
        "status": status,
        "project_type": projectType,
        "module": module!.toJson(),
        "inventoryRequested":
            List<dynamic>.from(inventoryRequested!.map((x) => x.toJson())),
        "feedback": feedback == null
            ? null
            : List<dynamic>.from(feedback!.map((x) => x.toJson())),
      };
}

class Feedback {
  Feedback({
    this.firstname,
    this.lastname,
    this.email,
    this.feedback,
  });

  String? firstname;
  String? lastname;
  String? email;
  String? feedback;

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        feedback: json["feedback"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "feedback": feedback,
      };
}

class InventoryRequested {
  InventoryRequested({
    this.item,
    this.quantity,
  });

  Item? item;
  String? quantity;

  factory InventoryRequested.fromJson(Map<String, dynamic> json) =>
      InventoryRequested(
        item: Item.fromJson(json["item"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "item": item!.toJson(),
        "quantity": quantity,
      };
}

class Item {
  Item({
    this.id,
    this.itemName,
    this.availableQuantity,
    this.totalQuantity,
    this.itemSlug,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.institution,
  });

  String? id;
  String? itemName;
  int? availableQuantity;
  int? totalQuantity;
  String? itemSlug;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? institution;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"],
        itemName: json["item_name"],
        availableQuantity: json["available_quantity"],
        totalQuantity: json["total_quantity"],
        itemSlug: json["item_slug"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        institution: json["institution"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "item_name": itemName,
        "available_quantity": availableQuantity,
        "total_quantity": totalQuantity,
        "item_slug": itemSlug,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
        "institution": institution,
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
