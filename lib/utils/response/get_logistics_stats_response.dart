// To parse this JSON data, do
//
//     final getLogisticsforStatsResponse = getLogisticsforStatsResponseFromJson(jsonString);

import 'dart:convert';

GetLogisticsforStatsResponse getLogisticsforStatsResponseFromJson(String str) => GetLogisticsforStatsResponse.fromJson(json.decode(str));

String getLogisticsforStatsResponseToJson(GetLogisticsforStatsResponse data) => json.encode(data.toJson());

class GetLogisticsforStatsResponse {
  GetLogisticsforStatsResponse({
    this.success,
    this.logistics,
    this.totalCount,
  });

  bool ? success;
  List<Logistic> ? logistics;
  int ? totalCount;

  factory GetLogisticsforStatsResponse.fromJson(Map<String, dynamic> json) => GetLogisticsforStatsResponse(
    success: json["success"],
    logistics: List<Logistic>.from(json["logistics"].map((x) => Logistic.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "logistics": List<dynamic>.from(logistics!.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class Logistic {
  Logistic({
    this.id,
    this.studentList,
    this.status,
    this.projectType,
    this.createdAt,
    this.collectionDate,
    this.returnedDate,
    this.module,
    this.user,
    this.inventoryRequested,
    this.feedback,
  });

  String ? id;
  List<dynamic> ? studentList;
  String ? status;
  String ? projectType;
  DateTime ? createdAt;
  DateTime ? collectionDate;
  DateTime ? returnedDate;
  Module ? module;
  User ? user;
  List<InventoryRequested> ? inventoryRequested;
  List<dynamic> ? feedback;

  factory Logistic.fromJson(Map<String, dynamic> json) => Logistic(
    id: json["_id"] == null ? null : json["_id"],
    studentList: json["student_list"] == null ? null : List<dynamic>.from(json["student_list"].map((x) => x)),
    status: json["status"] == null ? null : json["status"],
    projectType: json["project_type"] == null ? null : json["project_type"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    collectionDate: json["collectionDate"] == null ? null : DateTime.parse(json["collectionDate"]),
    returnedDate: json["returnedDate"] == null ? null : DateTime.parse(json["returnedDate"]),
    module: json["module"] == null ? null : Module.fromJson(json["module"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    inventoryRequested: json["inventoryRequested"] == null ? null : List<InventoryRequested>.from(json["inventoryRequested"].map((x) => InventoryRequested.fromJson(x))),
    feedback: json["feedback"] == null ? null : List<dynamic>.from(json["feedback"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "student_list": studentList == null ? null : List<dynamic>.from(studentList!.map((x) => x)),
    "status": status == null ? null : status,
    "project_type": projectType == null ? null : projectType,
    "createdAt": createdAt == null ? null : createdAt?.toIso8601String(),
    "collectionDate": collectionDate == null ? null : collectionDate?.toIso8601String(),
    "returnedDate": returnedDate == null ? null : returnedDate?.toIso8601String(),
    "module": module == null ? null : module?.toJson(),
    "user": user == null ? null : user?.toJson(),
    "inventoryRequested": inventoryRequested == null ? null : List<dynamic>.from(inventoryRequested!.map((x) => x.toJson())),
    "feedback": feedback == null ? null : List<dynamic>.from(feedback!.map((x) => x)),
  };
}

class InventoryRequested {
  InventoryRequested({
    this.item,
    this.status,
    this.returned,
    this.quantity,
  });

  Item ? item;
  String ?  status;
  bool ? returned;
  String ? quantity;

  factory InventoryRequested.fromJson(Map<String, dynamic> json) => InventoryRequested(
    item: Item.fromJson(json["item"]),
    status: json["status"],
    returned: json["returned"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "item": item?.toJson(),
    "status": status,
    "returned": returned,
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
    this.price,
    this.reminder,
  });

  String ? id;
  String ? itemName;
  int ? availableQuantity;
  int ? totalQuantity;
  String ? itemSlug;
  DateTime ? createdAt;
  DateTime ? updatedAt;
  int ? v;
  String ? institution;
  int ? price;
  int ? reminder;

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
    price: json["price"] == null ? null : json["price"],
    reminder: json["reminder"] == null ? null : json["reminder"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "item_name": itemName,
    "available_quantity": availableQuantity,
    "total_quantity": totalQuantity,
    "item_slug": itemSlug,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "institution": institution,
    "price": price == null ? null : price,
    "reminder": reminder == null ? null : reminder,
  };
}


class Module {
  Module({
    this.moduleTitle,
    this.moduleSlug,
  });

  String ? moduleTitle;
  String ? moduleSlug;

  factory Module.fromJson(Map<String, dynamic> json) => Module(
    moduleTitle: json["moduleTitle"] == null ? null : json["moduleTitle"],
    moduleSlug: json["moduleSlug"] == null ? null : json["moduleSlug"],
  );

  Map<String, dynamic> toJson() => {
    "moduleTitle": moduleTitle == null ? null : moduleTitle,
    "moduleSlug": moduleSlug == null ? null : moduleSlug,
  };
}

class User {
  User({
    this.username,
    this.firstname,
    this.lastname,
    this.batch,
  });

  String ? username;
  String ? firstname;
  String ? lastname;
  String ? batch;

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json["username"] == null ? null : json["username"],
    firstname: json["firstname"] == null ? null : json["firstname"],
    lastname: json["lastname"] == null ? null : json["lastname"],
    batch: json["batch"] == null ? null : json["batch"],
  );

  Map<String, dynamic> toJson() => {
    "username": username == null ? null : username,
    "firstname": firstname == null ? null : firstname,
    "lastname": lastname == null ? null : lastname,
    "batch": batch == null ? null : batch,
  };
}

