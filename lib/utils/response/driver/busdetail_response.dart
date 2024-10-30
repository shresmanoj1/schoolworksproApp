// To parse this JSON data, do
//
//     final getBusDetailResponse = getBusDetailResponseFromJson(jsonString);

import 'dart:convert';

GetBusDetailResponse getBusDetailResponseFromJson(String str) =>
    GetBusDetailResponse.fromJson(json.decode(str));

String getBusDetailResponseToJson(GetBusDetailResponse data) =>
    json.encode(data.toJson());

class GetBusDetailResponse {
  GetBusDetailResponse({
    this.success,
    this.bus,
    this.message,
  });

  bool? success;
  dynamic bus;
  String? message;

  factory GetBusDetailResponse.fromJson(Map<String, dynamic> json) =>
      GetBusDetailResponse(
        success: json["success"],
        bus: json["bus"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "bus": bus,
        "message": message,
      };
}
