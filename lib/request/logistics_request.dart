// To parse this JSON data, do
//
//     final logisticsRequest = logisticsRequestFromJson(jsonString);

import 'dart:convert';

LogisticsRequest logisticsRequestFromJson(String str) =>
    LogisticsRequest.fromJson(json.decode(str));

String logisticsRequestToJson(LogisticsRequest data) =>
    json.encode(data.toJson());

class LogisticsRequest {
  LogisticsRequest({
    this.studentList,
    this.status,
    this.projectType,
    this.moduleSlug,
    this.inventoryRequested,
  });

  List<String?>? studentList;
  String? status;
  String? projectType;
  String? moduleSlug;
  List? inventoryRequested;

  factory LogisticsRequest.fromJson(Map<String, dynamic> json) =>
      LogisticsRequest(
        studentList: List<String>.from(json["student_list"].map((x) => x)),
        status: json["status"],
        projectType: json["project_type"],
        moduleSlug: json["moduleSlug"],
        inventoryRequested: List<InventoryRequested>.from(
            json["inventoryRequested"]
                .map((x) => InventoryRequested.fromJson(x))).toList(),
      );

  Map<String, dynamic> toJson() => {
        "student_list": List<String>.from(studentList!.map((x) => x)),
        "status": status,
        "project_type": projectType,
        "moduleSlug": moduleSlug,
        "inventoryRequested": List<dynamic>.from(
            inventoryRequested!.map((x) => x.toJson()).toList()),
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
  });

  String? id;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
      };
}
