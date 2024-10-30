// To parse this JSON data, do
//
//     final createSubGroupResponse = createSubGroupResponseFromJson(jsonString);

import 'dart:convert';

CreateSubGroupResponse createSubGroupResponseFromJson(String str) => CreateSubGroupResponse.fromJson(json.decode(str));

String createSubGroupResponseToJson(CreateSubGroupResponse data) => json.encode(data.toJson());

class CreateSubGroupResponse {
  bool? success;
  dynamic moduleGroup;

  CreateSubGroupResponse({
    this.success,
    this.moduleGroup,
  });

  factory CreateSubGroupResponse.fromJson(Map<String, dynamic> json) => CreateSubGroupResponse(
    success: json["success"],
    moduleGroup: json["moduleGroup"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "moduleGroup": moduleGroup,
  };
}

// class ModuleGroup {
//   List<String>? users;
//   bool? isApproved;
//   List<String>? hasEdit;
//   List<String>? moduleSubGroup;
//   String? id;
//   String? module;
//   String? groupName;
//   String? batch;
//   String? createdBy;
//   String? institution;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   ModuleGroup({
//     this.users,
//     this.isApproved,
//     this.hasEdit,
//     this.moduleSubGroup,
//     this.id,
//     this.module,
//     this.groupName,
//     this.batch,
//     this.createdBy,
//     this.institution,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory ModuleGroup.fromJson(Map<String, dynamic> json) => ModuleGroup(
//     users: List<String>.from(json["users"].map((x) => x)),
//     isApproved: json["isApproved"],
//     hasEdit: List<String>.from(json["hasEdit"].map((x) => x)),
//     moduleSubGroup: List<String>.from(json["moduleSubGroup"].map((x) => x)),
//     id: json["_id"],
//     module: json["module"],
//     groupName: json["groupName"],
//     batch: json["batch"],
//     createdBy: json["createdBy"],
//     institution: json["institution"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "users": List<dynamic>.from(users!.map((x) => x)),
//     "isApproved": isApproved,
//     "hasEdit": List<dynamic>.from(hasEdit!.map((x) => x)),
//     "moduleSubGroup": List<dynamic>.from(moduleSubGroup!.map((x) => x)),
//     "_id": id,
//     "module": module,
//     "groupName": groupName,
//     "batch": batch,
//     "createdBy": createdBy,
//     "institution": institution,
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//   };
// }
