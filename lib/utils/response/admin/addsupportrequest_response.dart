
// To parse this JSON data, do
//
//     final addSupportRequestResponse = addSupportRequestResponseFromJson(jsonString);

import 'dart:convert';

AddSupportRequestResponse addSupportRequestResponseFromJson(String str) => AddSupportRequestResponse.fromJson(json.decode(str));

String addSupportRequestResponseToJson(AddSupportRequestResponse data) => json.encode(data.toJson());

class AddSupportRequestResponse {
  AddSupportRequestResponse({
    this.success,
    this.message,
    this.request,
  });

  bool ? success;
  String ? message;
  dynamic  request;

  factory AddSupportRequestResponse.fromJson(Map<String, dynamic> json) => AddSupportRequestResponse(
    success: json["success"],
    message: json["message"],
    request: json["request"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "request": request,
  };
}