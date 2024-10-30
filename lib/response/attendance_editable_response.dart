// To parse this JSON data, do
//
//     final attendanceEditableResponse = attendanceEditableResponseFromJson(jsonString);

import 'dart:convert';

AttendanceEditableResponse attendanceEditableResponseFromJson(String str) => AttendanceEditableResponse.fromJson(json.decode(str));

String attendanceEditableResponseToJson(AttendanceEditableResponse data) => json.encode(data.toJson());

class AttendanceEditableResponse {
  bool? success;
  bool? canEdit;

  AttendanceEditableResponse({
    this.success,
    this.canEdit,
  });

  factory AttendanceEditableResponse.fromJson(Map<String, dynamic> json) => AttendanceEditableResponse(
    success: json["success"],
    canEdit: json["canEdit"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "canEdit": canEdit,
  };
}
