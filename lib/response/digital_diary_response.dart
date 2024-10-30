// To parse this JSON data, do
//
//     final digitalDiaryResponse = digitalDiaryResponseFromJson(jsonString);

import 'dart:convert';

DigitalDiaryResponse digitalDiaryResponseFromJson(String str) => DigitalDiaryResponse.fromJson(json.decode(str));

String digitalDiaryResponseToJson(DigitalDiaryResponse data) => json.encode(data.toJson());

class DigitalDiaryResponse {
  bool? success;
  List<Task>? tasks;
  List<AllTitle>? allTitles;

  DigitalDiaryResponse({
    this.success,
    this.tasks,
    this.allTitles,
  });

  factory DigitalDiaryResponse.fromJson(Map<String, dynamic> json) => DigitalDiaryResponse(
    success: json["success"],
    tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
    allTitles: List<AllTitle>.from(json["allTitles"].map((x) => AllTitle.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "tasks": List<dynamic>.from(tasks!.map((x) => x.toJson())),
    "allTitles": List<dynamic>.from(allTitles!.map((x) => x.toJson())),
  };
}

class AllTitle {
  String? id;
  String? moduleTitle;
  String? moduleSlug;
  String? alias;

  AllTitle({
    this.id,
    this.moduleTitle,
    this.moduleSlug,
    this.alias,
  });

  factory AllTitle.fromJson(Map<String, dynamic> json) => AllTitle(
    id: json["_id"],
    moduleTitle: json["moduleTitle"],
    moduleSlug: json["moduleSlug"],
    alias: json["alias"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "moduleTitle": moduleTitle,
    "moduleSlug": moduleSlug,
    "alias": alias,
  };
}

class Task {
  String? id;
  List<String>? batch;
  DateTime? dueDate;
  String? taskname;
  String? content;
  String? moduleSlug;
  String? institution;
  DateTime? assignedDate;
  String? taskSlug;
  int? v;
  bool? submitted;
  String? feedback;

  Task({
    this.id,
    this.batch,
    this.dueDate,
    this.taskname,
    this.content,
    this.moduleSlug,
    this.institution,
    this.assignedDate,
    this.taskSlug,
    this.v,
    this.submitted,
    this.feedback,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["_id"],
    batch: List<String>.from(json["batch"].map((x) => x)),
    dueDate: DateTime.parse(json["dueDate"]),
    taskname: json["taskname"],
    content: json["content"],
    moduleSlug: json["moduleSlug"],
    institution: json["institution"],
    assignedDate: DateTime.parse(json["assignedDate"]),
    taskSlug: json["taskSlug"],
    v: json["__v"],
    submitted: json["submitted"],
    feedback: json["feedback"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "batch": List<dynamic>.from(batch!.map((x) => x)),
    "dueDate": dueDate?.toIso8601String(),
    "taskname": taskname,
    "content": content,
    "moduleSlug": moduleSlug,
    "institution": institution,
    "assignedDate": assignedDate?.toIso8601String(),
    "taskSlug": taskSlug,
    "__v": v,
    "submitted": submitted,
    "feedback": feedback,
  };
}
