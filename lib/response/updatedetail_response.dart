// To parse this JSON data, do
//
//     final updatedetailResponse = updatedetailResponseFromJson(jsonString);

import 'dart:convert';

UpdatedetailResponse updatedetailResponseFromJson(String str) =>
    UpdatedetailResponse.fromJson(json.decode(str));

String updatedetailResponseToJson(UpdatedetailResponse data) =>
    json.encode(data.toJson());

class UpdatedetailResponse {
  UpdatedetailResponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory UpdatedetailResponse.fromJson(Map<String, dynamic> json) =>
      UpdatedetailResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
