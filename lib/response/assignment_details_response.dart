// To parse this JSON data, do
//
//     final assignmentDetailsResponse = assignmentDetailsResponseFromJson(jsonString);

import 'dart:convert';

AssignmentDetailsResponse assignmentDetailsResponseFromJson(String str) => AssignmentDetailsResponse.fromJson(json.decode(str));

String assignmentDetailsResponseToJson(AssignmentDetailsResponse data) => json.encode(data.toJson());

class AssignmentDetailsResponse {
  bool? success;
  Assignment? assignment;

  AssignmentDetailsResponse({
    this.success,
    this.assignment,
  });

  factory AssignmentDetailsResponse.fromJson(Map<String, dynamic> json) => AssignmentDetailsResponse(
    success: json["success"],
    assignment: Assignment.fromJson(json["assignment"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "assignment": assignment?.toJson(),
  };
}

class Assignment {
  String? id;
  bool? plagarismEnabled;
  String? plagarismLevel;
  DateTime? dueDate;
  String? assignmentTitle;
  String? filename;
  String? folderToUpload;
  DateTime? createdAt;
  bool? isDisabled;
  dynamic submission;

  Assignment({
    this.id,
    this.plagarismEnabled,
    this.plagarismLevel,
    this.dueDate,
    this.assignmentTitle,
    this.filename,
    this.folderToUpload,
    this.createdAt,
    this.isDisabled,
    this.submission,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
    id: json["_id"],
    plagarismEnabled: json["plagarismEnabled"],
    plagarismLevel: json["plagarismLevel"],
    dueDate: DateTime.parse(json["dueDate"]),
    assignmentTitle: json["assignmentTitle"],
    filename: json["filename"],
    folderToUpload: json["folderToUpload"],
    createdAt: DateTime.parse(json["createdAt"]),
    isDisabled: json["isDisabled"],
    submission: json["submission"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "plagarismEnabled": plagarismEnabled,
    "plagarismLevel": plagarismLevel,
    "dueDate": dueDate?.toIso8601String(),
    "assignmentTitle": assignmentTitle,
    "filename": filename,
    "folderToUpload": folderToUpload,
    "createdAt": createdAt?.toIso8601String(),
    "isDisabled": isDisabled,
    "submission": submission,
  };
}
