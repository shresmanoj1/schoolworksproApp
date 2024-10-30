// To parse this JSON data, do
//
//     final StudentBusListResponse = StudentBusListResponseFromJson(jsonString);

import 'dart:convert';

StudentBusListResponse StudentBusListResponseFromJson(String str) =>
    StudentBusListResponse.fromJson(json.decode(str));

String StudentBusListResponseToJson(StudentBusListResponse data) => json.encode(data.toJson());

class StudentBusListResponse {
  StudentBusListResponse({
    this.success,
    this.students,
  });

  bool? success;
  List<dynamic>? students;

  factory StudentBusListResponse.fromJson(Map<String, dynamic> json) => StudentBusListResponse(
        success: json["success"],
        students: List<dynamic>.from(json["students"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "students": List<dynamic>.from(students!.map((x) => x.toJson())),
      };
}
