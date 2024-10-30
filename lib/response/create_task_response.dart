// To parse this JSON data, do
//
//     final createTaskResponse = createTaskResponseFromJson(jsonString);

import 'dart:convert';

CreateTaskResponse createTaskResponseFromJson(String str) => CreateTaskResponse.fromJson(json.decode(str));

String createTaskResponseToJson(CreateTaskResponse data) => json.encode(data.toJson());

class CreateTaskResponse {
  bool? success;
  Tasks? tasks;

  CreateTaskResponse({
    this.success,
    this.tasks,
  });

  factory CreateTaskResponse.fromJson(Map<String, dynamic> json) => CreateTaskResponse(
    success: json["success"],
    tasks: Tasks.fromJson(json["tasks"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "tasks": tasks?.toJson(),
  };
}

class Tasks {
  Tasks();

  factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
  );

  Map<String, dynamic> toJson() => {
  };
}
