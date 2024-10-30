// To parse this JSON data, do
//
//     final respondLogisticsResponse = respondLogisticsResponseFromJson(jsonString);

import 'dart:convert';

RespondLogisticsResponse respondLogisticsResponseFromJson(String str) =>
    RespondLogisticsResponse.fromJson(json.decode(str));

String respondLogisticsResponseToJson(RespondLogisticsResponse data) =>
    json.encode(data.toJson());

class RespondLogisticsResponse {
  RespondLogisticsResponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory RespondLogisticsResponse.fromJson(Map<String, dynamic> json) =>
      RespondLogisticsResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
