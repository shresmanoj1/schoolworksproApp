// To parse this JSON data, do
//
//     final studentBusResponse = studentBusResponseFromJson(jsonString);

import 'dart:convert';

StudentBusResponse studentBusResponseFromJson(String str) => StudentBusResponse.fromJson(json.decode(str));

String studentBusResponseToJson(StudentBusResponse data) => json.encode(data.toJson());

class StudentBusResponse {
  bool? success;
  Bus? bus;

  StudentBusResponse({
    this.success,
    this.bus,
  });

  factory StudentBusResponse.fromJson(Map<String, dynamic> json) => StudentBusResponse(
    success: json["success"],
    bus: json["bus"] == null ? Bus() : Bus.fromJson(json["bus"]) ,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "bus": bus?.toJson(),
  };
}

class Bus {
  String? busNumber;
  String? busName;
  String? route;
  String? driver;

  Bus({
    this.busNumber,
    this.busName,
    this.route,
    this.driver,
  });

  factory Bus.fromJson(Map<String, dynamic> json) => Bus(
    busNumber: json["bus_number"],
    busName: json["bus_name"],
    route: json["route"],
    driver: json["driver"],
  );

  Map<String, dynamic> toJson() => {
    "bus_number": busNumber,
    "bus_name": busName,
    "route": route,
    "driver": driver,
  };
}
