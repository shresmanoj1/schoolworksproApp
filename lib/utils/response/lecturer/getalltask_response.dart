// To parse this JSON data, do
//
//     final getAllTaskResponse = getAllTaskResponseFromJson(jsonString);

import 'dart:convert';

GetAllTaskResponse getAllTaskResponseFromJson(String str) =>
    GetAllTaskResponse.fromJson(json.decode(str));

String getAllTaskResponseToJson(GetAllTaskResponse data) =>
    json.encode(data.toJson());

class GetAllTaskResponse {
  GetAllTaskResponse({
    this.success,
    this.message,
    this.task,
  });

  bool? success;
  String? message;
  List<Task>? task;

  factory GetAllTaskResponse.fromJson(Map<String, dynamic> json) =>
      GetAllTaskResponse(
        success: json["success"],
        message: json["message"],
        task: List<Task>.from(json["task"].map((x) => Task.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "task": List<dynamic>.from(task!.map((x) => x.toJson())),
      };
}

class Task {
  Task({
    this.batch,
    this.id,
    this.dueDate,
    this.taskname,
    this.content,
    this.moduleSlug,
    this.institution,
    this.students,
    this.assignedDate,
    this.taskSlug,
  });

  List<String>? batch;
  String? id;
  DateTime? dueDate;
  String? taskname;
  String? content;
  String? moduleSlug;
  String? institution;
  List<dynamic>? students;
  DateTime? assignedDate;
  String? taskSlug;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        batch: List<String>.from(json["batch"].map((x) => x)),
        id: json["_id"],
        dueDate: DateTime.parse(json["dueDate"]),
        taskname: json["taskname"],
        content: json["content"],
        moduleSlug: json["moduleSlug"],
        institution: json["institution"],
        students: List<dynamic>.from(json["students"].map((x) => x)),
        assignedDate: DateTime.parse(json["assignedDate"]),
        taskSlug: json["taskSlug"],
      );

  Map<String, dynamic> toJson() => {
        "batch": List<dynamic>.from(batch!.map((x) => x)),
        "_id": id,
        "dueDate": dueDate?.toIso8601String(),
        "taskname": taskname,
        "content": content,
        "moduleSlug": moduleSlug,
        "institution": institution,
        "students": List<dynamic>.from(students!.map((x) => x)),
        "assignedDate": assignedDate?.toIso8601String(),
        "taskSlug": taskSlug,
      };
}
