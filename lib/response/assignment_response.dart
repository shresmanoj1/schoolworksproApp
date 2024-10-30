
// To parse this JSON data, do
//
//     final assignmentResponse = assignmentResponseFromJson(jsonString);

import 'dart:convert';

AssignmentResponse assignmentResponseFromJson(String str) => AssignmentResponse.fromJson(json.decode(str));

String assignmentResponseToJson(AssignmentResponse data) => json.encode(data.toJson());

class AssignmentResponse {
  AssignmentResponse({
    this.success,
    this.assignments,
  });

  bool? success;
  List<Assignment>? assignments;

  factory AssignmentResponse.fromJson(Map<String, dynamic> json) => AssignmentResponse(
    success: json["success"],
    assignments: json["assignments"] == null ? [] : List<Assignment>.from(json["assignments"].map((x) => Assignment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "assignments": List<dynamic>.from(assignments!.map((x) => x.toJson())),
  };
}

class Assignment {
  Assignment({
    this.isDisabled,
    this.id,
    this.dueDate,
    this.assignmentTitle,
    this.filename,
    this.folderToUpload,
    this.createdAt,
    this.submission,
  });

  bool? isDisabled;
  String? id;
  DateTime? dueDate;
  String? assignmentTitle;
  String? filename;
  String? folderToUpload;
  DateTime? createdAt;
  dynamic submission;

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
    isDisabled: json["isDisabled"],
    id: json["_id"],
    dueDate: DateTime.parse(json["dueDate"]),
    assignmentTitle: json["assignmentTitle"],
    filename: json["filename"],
    folderToUpload: json["folderToUpload"],
    createdAt: DateTime.parse(json["createdAt"]),
    submission: json["submission"],
  );

  Map<String, dynamic> toJson() => {
    "isDisabled": isDisabled,
    "_id": id,
    "dueDate": dueDate?.toIso8601String(),
    "assignmentTitle": assignmentTitle,
    "filename": filename,
    "folderToUpload": folderToUpload,
    "createdAt": createdAt?.toIso8601String(),
    "submission": submission,
  };
}

