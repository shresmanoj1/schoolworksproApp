// To parse this JSON data, do
//
//     final availableCollaborationResponse = availableCollaborationResponseFromJson(jsonString);

import 'dart:convert';

AvailableCollaborationResponse availableCollaborationResponseFromJson(String str) => AvailableCollaborationResponse.fromJson(json.decode(str));

String availableCollaborationResponseToJson(AvailableCollaborationResponse data) => json.encode(data.toJson());

class AvailableCollaborationResponse {
  AvailableCollaborationResponse({
    this.success,
    this.assignments,
  });

  bool? success;
  List<Assignment>? assignments;

  factory AvailableCollaborationResponse.fromJson(Map<String, dynamic> json) => AvailableCollaborationResponse(
    success: json["success"],
    assignments: List<Assignment>.from(json["assignments"].map((x) => Assignment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "assignments": List<dynamic>.from(assignments!.map((x) => x.toJson())),
  };
}

class Assignment {
  Assignment({
    this.id,
    this.batch,
    this.plagarismEnabled,
    this.referenceCheckEnabled,
    this.canMark,
    this.schedule,
    this.resit,
    this.isGroup,
    this.startDate,
    this.dueDate,
    this.assignmentTitle,
    this.moduleSlug,
    this.plagarismLevel,
    this.filename,
    this.uploadedBy,
    this.institution,
    this.folderToUpload,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.assignmentGroups,
  });

  String? id;
  List<String>? batch;
  bool? plagarismEnabled;
  bool? referenceCheckEnabled;
  bool? canMark;
  bool? schedule;
  List<dynamic>? resit;
  bool? isGroup;
  DateTime? startDate;
  DateTime? dueDate;
  String? assignmentTitle;
  String? moduleSlug;
  String? plagarismLevel;
  String? filename;
  String? uploadedBy;
  String? institution;
  String? folderToUpload;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<AssignmentGroup>? assignmentGroups;

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
    id: json["_id"],
    batch: List<String>.from(json["batch"].map((x) => x)),
    plagarismEnabled: json["plagarismEnabled"],
    referenceCheckEnabled: json["referenceCheckEnabled"],
    canMark: json["canMark"],
    schedule: json["schedule"],
    resit: List<dynamic>.from(json["resit"].map((x) => x)),
    isGroup: json["isGroup"],
    startDate: DateTime.parse(json["startDate"]),
    dueDate: DateTime.parse(json["dueDate"]),
    assignmentTitle: json["assignmentTitle"],
    moduleSlug: json["moduleSlug"],
    plagarismLevel: json["plagarismLevel"],
    filename: json["filename"],
    uploadedBy: json["uploadedBy"],
    institution: json["institution"],
    folderToUpload: json["folderToUpload"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    assignmentGroups: List<AssignmentGroup>.from(json["assignment_groups"].map((x) => AssignmentGroup.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "batch": List<dynamic>.from(batch!.map((x) => x)),
    "plagarismEnabled": plagarismEnabled,
    "referenceCheckEnabled": referenceCheckEnabled,
    "canMark": canMark,
    "schedule": schedule,
    "resit": List<dynamic>.from(resit!.map((x) => x)),
    "isGroup": isGroup,
    "startDate": startDate?.toIso8601String(),
    "dueDate": dueDate?.toIso8601String(),
    "assignmentTitle": assignmentTitle,
    "moduleSlug": moduleSlug,
    "plagarismLevel": plagarismLevel,
    "filename": filename,
    "uploadedBy": uploadedBy,
    "institution": institution,
    "folderToUpload": folderToUpload,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "assignment_groups": List<dynamic>.from(assignmentGroups!.map((x) => x.toJson())),
  };
}

class AssignmentGroup {
  AssignmentGroup({
    this.id,
    this.users,
    this.hasEdit,
    this.assignmentSubGroup,
    this.assignment,
    this.groupName,
    this.createdBy,
    this.institution,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  List<String>? users;
  List<String>? hasEdit;
  List<String>? assignmentSubGroup;
  String? assignment;
  String? groupName;
  String? createdBy;
  String? institution;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory AssignmentGroup.fromJson(Map<String, dynamic> json) => AssignmentGroup(
    id: json["_id"],
    users: List<String>.from(json["users"].map((x) => x)),
    hasEdit: List<String>.from(json["hasEdit"].map((x) => x)),
    assignmentSubGroup: List<String>.from(json["assignmentSubGroup"].map((x) => x)),
    assignment: json["assignment"],
    groupName: json["groupName"],
    createdBy: json["createdBy"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "users": List<dynamic>.from(users!.map((x) => x)),
    "hasEdit": List<dynamic>.from(hasEdit!.map((x) => x)),
    "assignmentSubGroup": List<dynamic>.from(assignmentSubGroup!.map((x) => x)),
    "assignment": assignment,
    "groupName": groupName,
    "createdBy": createdBy,
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
