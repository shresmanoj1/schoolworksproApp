// To parse this JSON data, do
//
//     final collaborationTaskGroup = collaborationTaskGroupFromJson(jsonString);

import 'dart:convert';

CollaborationTaskGroup collaborationTaskGroupFromJson(String str) => CollaborationTaskGroup.fromJson(json.decode(str));

String collaborationTaskGroupToJson(CollaborationTaskGroup data) => json.encode(data.toJson());

class CollaborationTaskGroup {
  CollaborationTaskGroup({
    this.success,
    this.moduleGroup,
    this.tasks,
    this.percentage,
  });

  bool? success;
  dynamic moduleGroup;
  dynamic tasks;
  dynamic percentage;

  factory CollaborationTaskGroup.fromJson(Map<String, dynamic> json) => CollaborationTaskGroup(
    success: json["success"],
    moduleGroup: json["moduleGroup"],
    tasks: json["tasks"],
    percentage: json["percentage"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "moduleGroup": moduleGroup,
    "tasks": tasks,
    "percentage": percentage,
  };
}

class AssignmentSubGroupTask {
  AssignmentSubGroupTask({
    this.id,
    this.title,
    this.color,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? title;
  String? color;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory AssignmentSubGroupTask.fromJson(Map<String, dynamic> json) => AssignmentSubGroupTask(
    id: json["_id"],
    title: json["title"],
    color: json["color"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "color": color,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}


class TaskAssignment {
  TaskAssignment({
    this.status,
    this.taskFile,
    this.taskResponse,
    this.assignedTo,
    this.id,
    this.title,
    this.date,
    this.detail,
    this.assignmentSubGroup,
    this.createdBy,
    this.institution,
    this.createdAt,
    this.updatedAt,
  });

  String? status;
  List<dynamic>? taskFile;
  List<dynamic>? taskResponse;
  List<dynamic>? assignedTo;
  String? id;
  String? title;
  DateTime? date;
  String? detail;
  String? assignmentSubGroup;
  String? createdBy;
  dynamic? institution;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory TaskAssignment.fromJson(Map<String, dynamic> json) => TaskAssignment(
    status: json["status"],
    taskFile: List<dynamic>.from(json["taskFile"].map((x) => x)),
    taskResponse: List<dynamic>.from(json["taskResponse"].map((x) => x)),
    assignedTo: List<dynamic>.from(json["assignedTo"].map((x) => x)),
    id: json["_id"],
    title: json["title"],
    date: DateTime.parse(json["date"]),
    detail: json["detail"],
    assignmentSubGroup: json["assignmentSubGroup"],
    createdBy: json["createdBy"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "taskFile": List<dynamic>.from(taskFile!.map((x) => x)),
    "taskResponse": List<dynamic>.from(taskResponse!.map((x) => x)),
    "assignedTo": List<dynamic>.from(assignedTo!.map((x) => x.toJson())),
    "_id": id,
    "title": title,
    "date": date?.toIso8601String(),
    "detail": detail,
    "assignmentSubGroup": assignmentSubGroup,
    "createdBy": createdBy,
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
