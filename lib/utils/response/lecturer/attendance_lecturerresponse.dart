// To parse this JSON data, do
//
//     final attendancelecturerResponse = attendancelecturerResponseFromJson(jsonString);

import 'dart:convert';

AttendancelecturerResponse attendancelecturerResponseFromJson(String str) =>
    AttendancelecturerResponse.fromJson(json.decode(str));

String attendancelecturerResponseToJson(AttendancelecturerResponse data) =>
    json.encode(data.toJson());

class AttendancelecturerResponse {
  AttendancelecturerResponse({
    this.success,
    this.attendance,
  });

  bool? success;
  List<dynamic>? attendance;

  factory AttendancelecturerResponse.fromJson(Map<String, dynamic> json) =>
      AttendancelecturerResponse(
        success: json["success"],
        attendance: List<dynamic>.from(json["attendance"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "attendance": List<dynamic>.from(attendance!.map((x) => x.toJson())),
      };
}
