// To parse this JSON data, do
//
//     final busStatusChangeResponse = busStatusChangeResponseFromJson(jsonString);

import 'dart:convert';

BusStatusChangeResponse busStatusChangeResponseFromJson(String str) =>
    BusStatusChangeResponse.fromJson(json.decode(str));

String busStatusChangeResponseToJson(BusStatusChangeResponse data) =>
    json.encode(data.toJson());

class BusStatusChangeResponse {
  BusStatusChangeResponse({
    this.success,
    this.bus,
    this.message,
  });

  bool? success;
  dynamic bus;
  String? message;

  factory BusStatusChangeResponse.fromJson(Map<String, dynamic> json) =>
      BusStatusChangeResponse(
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
