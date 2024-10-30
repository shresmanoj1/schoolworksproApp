// To parse this JSON data, do
//
//     final getStudentByBatchResponse = getStudentByBatchResponseFromJson(jsonString);

import 'dart:convert';

GetStudentByBatchResponse getStudentByBatchResponseFromJson(String str) =>
    GetStudentByBatchResponse.fromJson(json.decode(str));

String getStudentByBatchResponseToJson(GetStudentByBatchResponse data) =>
    json.encode(data.toJson());

class GetStudentByBatchResponse {
  GetStudentByBatchResponse({
    this.success,
    this.students,
  });

  bool? success;
  List<dynamic>? students;

  factory GetStudentByBatchResponse.fromJson(Map<String, dynamic> json) =>
      GetStudentByBatchResponse(
        success: json["success"],
        students: List<dynamic>.from(json["students"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "students": List<dynamic>.from(students!.map((x) => x.toJson())),
      };
}
