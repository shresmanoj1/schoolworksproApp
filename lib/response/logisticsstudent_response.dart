// To parse this JSON data, do
//
//     final logisticsStudent = logisticsStudentFromJson(jsonString);

import 'dart:convert';

LogisticsStudent logisticsStudentFromJson(String str) =>
    LogisticsStudent.fromJson(json.decode(str));

String logisticsStudentToJson(LogisticsStudent data) =>
    json.encode(data.toJson());

class LogisticsStudent {
  LogisticsStudent({
    this.success,
    this.students,
  });

  bool? success;
  List<Student>? students;

  factory LogisticsStudent.fromJson(Map<String, dynamic> json) =>
      LogisticsStudent(
        success: json["success"],
        students: List<Student>.from(
            json["students"].map((x) => Student.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "students": List<dynamic>.from(students!.map((x) => x.toJson())),
      };
}

class Student {
  Student({
    this.username,
    this.firstname,
    this.lastname,
  });

  String? username;
  String? firstname;
  String? lastname;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
      };
}
