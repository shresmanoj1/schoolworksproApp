// To parse this JSON data, do
//
//     final viewinventoryrequestresponse = viewinventoryrequestresponseFromJson(jsonString);

import 'dart:convert';

Viewinventoryrequestresponse viewinventoryrequestresponseFromJson(String str) =>
    Viewinventoryrequestresponse.fromJson(json.decode(str));

String viewinventoryrequestresponseToJson(Viewinventoryrequestresponse data) =>
    json.encode(data.toJson());

class Viewinventoryrequestresponse {
  Viewinventoryrequestresponse({
    this.success,
    this.inventoryReq,
  });

  bool? success;
  List<InventoryReq>? inventoryReq;

  factory Viewinventoryrequestresponse.fromJson(Map<String, dynamic> json) =>
      Viewinventoryrequestresponse(
        success: json["success"],
        inventoryReq: List<InventoryReq>.from(
            json["inventoryReq"].map((x) => InventoryReq.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "inventoryReq":
            List<dynamic>.from(inventoryReq!.map((x) => x.toJson())),
      };
}

class InventoryReq {
  InventoryReq({
    this.id,
    this.inventoryRequested,
    this.studentList,
    this.status,
    this.projectType,
    this.module,
    this.feedback,
  });

  String? id;
  List<String>? inventoryRequested;
  List<String>? studentList;
  String? status;
  String? projectType;
  Module? module;
  List<Feedback>? feedback;

  factory InventoryReq.fromJson(Map<String, dynamic> json) => InventoryReq(
        id: json["_id"],
        inventoryRequested:
            List<String>.from(json["inventoryRequested"].map((x) => x)),
        studentList: List<String>.from(json["student_list"].map((x) => x)),
        status: json["status"],
        projectType: json["project_type"],
        module: Module.fromJson(json["module"]),
        feedback: List<Feedback>.from(
            json["feedback"].map((x) => Feedback.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "inventoryRequested":
            List<dynamic>.from(inventoryRequested!.map((x) => x)),
        "student_list": List<dynamic>.from(studentList!.map((x) => x)),
        "status": status,
        "project_type": projectType,
        "module": module!.toJson(),
        "feedback": List<dynamic>.from(feedback!.map((x) => x.toJson())),
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
