// To parse this JSON data, do
//
//     final currentStudentResponse = currentStudentResponseFromJson(jsonString);

import 'dart:convert';

CurrentStudentResponse currentStudentResponseFromJson(String str) => CurrentStudentResponse.fromJson(json.decode(str));

String currentStudentResponseToJson(CurrentStudentResponse data) => json.encode(data.toJson());

class CurrentStudentResponse {
  bool? success;
  List<StudentList>? students;

  CurrentStudentResponse({
    this.success,
    this.students,
  });

  factory CurrentStudentResponse.fromJson(Map<String, dynamic> json) => CurrentStudentResponse(
    success: json["success"],
    students: List<StudentList>.from(json["students"].map((x) => StudentList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "students": List<dynamic>.from(students!.map((x) => x.toJson())),
  };
}

class StudentList {
  String? type;
  String? id;
  String? firstname;
  String? lastname;
  String? batch;
  String? username;

  StudentList({
    this.type,
    this.id,
    this.firstname,
    this.lastname,
    this.batch,
    this.username,
  });

  factory StudentList.fromJson(Map<String, dynamic> json) => StudentList(
    type: json["type"],
    id: json["_id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    batch: json["batch"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "_id": id,
    "firstname": firstname,
    "lastname": lastname,
    "batch": batch,
    "username": username,
  };
}
