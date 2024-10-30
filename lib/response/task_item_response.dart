// To parse this JSON data, do
//
//     final taskItemResponse = taskItemResponseFromJson(jsonString);

import 'dart:convert';

TaskItemResponse taskItemResponseFromJson(String str) => TaskItemResponse.fromJson(json.decode(str));

String taskItemResponseToJson(TaskItemResponse data) => json.encode(data.toJson());

class TaskItemResponse {
  bool? success;
  Task? task;

  TaskItemResponse({
    this.success,
    this.task,
  });

  factory TaskItemResponse.fromJson(Map<String, dynamic> json) => TaskItemResponse(
    success: json["success"],
    task: Task.fromJson(json["task"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "task": task?.toJson(),
  };
}

class Task {
  String? id;
  String? status;
  List<dynamic>? taskFile;
  String? completionPercentage;
  List<dynamic>? taskResponse;
  List<String>? assignedTo;
  String? title;
  String? detail;
  String? moduleSubGroup;
  String? createdBy;
  String? institution;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  DateTime? endDate;
  DateTime? startDate;

  Task({
    this.id,
    this.status,
    this.taskFile,
    this.completionPercentage,
    this.taskResponse,
    this.assignedTo,
    this.title,
    this.detail,
    this.moduleSubGroup,
    this.createdBy,
    this.institution,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.endDate,
    this.startDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["_id"],
    status: json["status"],
    taskFile: List<dynamic>.from(json["taskFile"].map((x) => x)),
    completionPercentage: json["completionPercentage"],
    taskResponse: List<dynamic>.from(json["taskResponse"].map((x) => x)),
    assignedTo: List<String>.from(json["assignedTo"].map((x) => x)),
    title: json["title"],
    detail: json["detail"],
    moduleSubGroup: json["moduleSubGroup"],
    createdBy: json["createdBy"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    endDate: json["endDate"] == null ? DateTime.now() : DateTime.parse(json["endDate"]),
    startDate:  json["startDate"] == null ? DateTime.now() : DateTime.parse(json["startDate"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "status": status,
    "taskFile": List<dynamic>.from(taskFile!.map((x) => x)),
    "completionPercentage": completionPercentage,
    "taskResponse": List<dynamic>.from(taskResponse!.map((x) => x)),
    "assignedTo": List<dynamic>.from(assignedTo!.map((x) => x)),
    "title": title,
    "detail": detail,
    "moduleSubGroup": moduleSubGroup,
    "createdBy": createdBy,
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "endDate": endDate?.toIso8601String(),
    "startDate": startDate?.toIso8601String(),
  };
}
