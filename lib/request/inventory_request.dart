import 'dart:convert';

InventoryRequest inventoryRequestFromJson(String str) =>
    InventoryRequest.fromJson(json.decode(str));

String inventoryRequestToJson(InventoryRequest data) =>
    json.encode(data.toJson());

class InventoryRequest {
  InventoryRequest({
    this.inventoryRequested,
    this.studentList,
    this.status,
    this.projectType,
    this.moduleSlug,
  });

  List<String>? inventoryRequested;
  List<String?>? studentList;
  String? status;
  String? projectType;
  String? moduleSlug;

  factory InventoryRequest.fromJson(Map<String, dynamic> json) =>
      InventoryRequest(
        inventoryRequested:
            List<String>.from(json["inventoryRequested"].map((x) => x)),
        studentList: List<String>.from(json["student_list"].map((x) => x)),
        status: json["status"],
        projectType: json["project_type"],
        moduleSlug: json["moduleSlug"],
      );

  Map<String, dynamic> toJson() => {
        "inventoryRequested":
            List<dynamic>.from(inventoryRequested!.map((x) => x)),
        "student_list": List<dynamic>.from(studentList!.map((x) => x)),
        "status": status,
        "project_type": projectType,
        "moduleSlug": moduleSlug,
      };
}
