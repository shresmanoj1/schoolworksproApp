// To parse this JSON data, do
//
//     final getBusReponse = getBusReponseFromJson(jsonString);

import 'dart:convert';

GetBusResponse getBusReponseFromJson(String str) => GetBusResponse.fromJson(json.decode(str));

String getBusReponseToJson(GetBusResponse data) => json.encode(data.toJson());

class GetBusResponse {
  GetBusResponse({
    this.success,
    this.buses,
  });

  bool? success;
  List<Bus>? buses;

  factory GetBusResponse.fromJson(Map<String, dynamic> json) => GetBusResponse(
    success: json["success"],
    buses: List<Bus>.from(json["buses"].map((x) => Bus.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "buses": List<dynamic>.from(buses!.map((x) => x.toJson())),
  };
}

class Bus {
  Bus({
    this.id,
    this.busNumber,
    this.busName,
    this.route,
  });

  String? id;
  String? busNumber;
  String? busName;
  String? route;

  factory Bus.fromJson(Map<String, dynamic> json) => Bus(
    id: json["_id"],
    busNumber: json["bus_number"],
    busName: json["bus_name"],
    route: json["route"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "bus_number": busNumber,
    "bus_name": busName,
    "route": route,
  };
}
