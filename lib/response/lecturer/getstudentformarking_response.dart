// To parse this JSON data, do
//
//     final getStudentForMarkingResponse = getStudentForMarkingResponseFromJson(jsonString);

import 'dart:convert';

GetStudentForMarkingResponse getStudentForMarkingResponseFromJson(String str) => GetStudentForMarkingResponse.fromJson(json.decode(str));

String getStudentForMarkingResponseToJson(GetStudentForMarkingResponse data) => json.encode(data.toJson());

class GetStudentForMarkingResponse {
  GetStudentForMarkingResponse({
    this.success,
    this.students,
  });

  bool ? success;
  List<dynamic> ? students;

  factory GetStudentForMarkingResponse.fromJson(Map<String, dynamic> json) => GetStudentForMarkingResponse(
    success: json["success"],
    students: List<dynamic>.from(json["students"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "students": List<dynamic>.from(students!.map((x) => x.toJson())),
  };
}
