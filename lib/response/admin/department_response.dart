// To parse this JSON data, do
//
//     final departmentResponse = departmentResponseFromJson(jsonString);

import 'dart:convert';

DepartmentResponse departmentResponseFromJson(String str) => DepartmentResponse.fromJson(json.decode(str));

String departmentResponseToJson(DepartmentResponse data) => json.encode(data.toJson());

class DepartmentResponse {
  bool? success;
  List<String>? departments;

  DepartmentResponse({
    this.success,
    this.departments,
  });

  factory DepartmentResponse.fromJson(Map<String, dynamic> json) => DepartmentResponse(
    success: json["success"],
    departments: List<String>.from(json["departments"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "departments": List<dynamic>.from(departments!.map((x) => x)),
  };
}
