// To parse this JSON data, do
//
//     final inventoryresponse = inventoryresponseFromJson(jsonString);

import 'dart:convert';

Inventoryresponse inventoryresponseFromJson(String str) =>
    Inventoryresponse.fromJson(json.decode(str));

String inventoryresponseToJson(Inventoryresponse data) =>
    json.encode(data.toJson());

class Inventoryresponse {
  Inventoryresponse({
    this.success,
    this.inventory,
  });

  bool? success;
  List<Inventory>? inventory;

  factory Inventoryresponse.fromJson(Map<String, dynamic> json) =>
      Inventoryresponse(
        success: json["success"],
        inventory: List<Inventory>.from(
            json["inventory"].map((x) => Inventory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "inventory": List<dynamic>.from(inventory!.map((x) => x.toJson())),
      };
}

class Inventory {
  Inventory({
    this.id,
    this.itemName,
    this.availableQuantity,
    this.totalQuantity,
    this.itemSlug,
    this.createdAt,
    this.institution,
    this.counter,
  });

  String? id;
  String? itemName;
  int? availableQuantity;
  int? totalQuantity;
  String? itemSlug;
  DateTime? createdAt;
  String? institution;
  int? counter;

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        id: json["_id"],
        itemName: json["item_name"],
        availableQuantity: json["available_quantity"],
        totalQuantity: json["total_quantity"],
        itemSlug: json["item_slug"],
        createdAt: DateTime.parse(json["createdAt"]),
        institution: json["institution"],
        counter: 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "item_name": itemName,
        "available_quantity": availableQuantity,
        "total_quantity": totalQuantity,
        "item_slug": itemSlug,
        "createdAt": createdAt!.toIso8601String(),
        "institution": institution,
        "counter": 0,
      };
}
