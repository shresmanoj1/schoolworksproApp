// To parse this JSON data, do
//
//     final routineLecturerResponse = routineLecturerResponseFromJson(jsonString);

import 'dart:convert';

RoutineLecturerResponse routineLecturerResponseFromJson(String str) =>
    RoutineLecturerResponse.fromJson(json.decode(str));

String routineLecturerResponseToJson(RoutineLecturerResponse data) =>
    json.encode(data.toJson());

class RoutineLecturerResponse {
  RoutineLecturerResponse({
    this.success,
    this.routines,
  });

  bool? success;
  List<dynamic>? routines;

  factory RoutineLecturerResponse.fromJson(Map<String, dynamic> json) =>
      RoutineLecturerResponse(
        success: json["success"],
        routines: List<dynamic>.from(json["routines"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "routines": List<dynamic>.from(routines!.map((x) => x)),
      };
}
