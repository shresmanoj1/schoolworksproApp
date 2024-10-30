// To parse this JSON data, do
//
//     final addRequestResponse = addRequestResponseFromJson(jsonString);

import 'dart:convert';

AddRequestResponse addRequestResponseFromJson(String str) => AddRequestResponse.fromJson(json.decode(str));

String addRequestResponseToJson(AddRequestResponse data) => json.encode(data.toJson());

class AddRequestResponse {
  AddRequestResponse({
    this.success,
    this.message,
    this.request,
  });

  bool ? success;
  String ? message;
  dynamic request;

  factory AddRequestResponse.fromJson(Map<String, dynamic> json) => AddRequestResponse(
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
