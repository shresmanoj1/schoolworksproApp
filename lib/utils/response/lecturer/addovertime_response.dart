// To parse this JSON data, do
//
//     final addOvertimeResponse = addOvertimeResponseFromJson(jsonString);

import 'dart:convert';

AddOvertimeResponse addOvertimeResponseFromJson(String str) =>
    AddOvertimeResponse.fromJson(json.decode(str));

String addOvertimeResponseToJson(AddOvertimeResponse data) =>
    json.encode(data.toJson());

class AddOvertimeResponse {
  AddOvertimeResponse({
    this.success,
    this.message,
    this.overtime,
  });

  bool? success;
  String? message;
  dynamic overtime;

  factory AddOvertimeResponse.fromJson(Map<String, dynamic> json) =>
      AddOvertimeResponse(
        success: json["success"],
        message: json["message"],
        overtime: json["overtime"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "overtime": overtime,
      };
}
