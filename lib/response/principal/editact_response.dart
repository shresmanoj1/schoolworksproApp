// To parse this JSON data, do
//
//     final editActResponse = editActResponseFromJson(jsonString);

import 'dart:convert';

EditActResponse editActResponseFromJson(String str) =>
    EditActResponse.fromJson(json.decode(str));

String editActResponseToJson(EditActResponse data) =>
    json.encode(data.toJson());

class EditActResponse {
  EditActResponse({
    this.success,
    this.message,
    this.result,
  });

  bool? success;
  String? message;
  dynamic result;

  factory EditActResponse.fromJson(Map<String, dynamic> json) =>
      EditActResponse(
        success: json["success"],
        message: json["message"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "result": result,
      };
}
