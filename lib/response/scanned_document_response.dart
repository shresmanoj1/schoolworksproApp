// To parse this JSON data, do
//
//     final scannedAttendanceResponse = scannedAttendanceResponseFromJson(jsonString);

import 'dart:convert';

ScannedAttendanceResponse scannedAttendanceResponseFromJson(String str) => ScannedAttendanceResponse.fromJson(json.decode(str));

String scannedAttendanceResponseToJson(ScannedAttendanceResponse data) => json.encode(data.toJson());

class ScannedAttendanceResponse {
  bool? success;
  List<String>? scannedAttendance;

  ScannedAttendanceResponse({
    this.success,
    this.scannedAttendance,
  });

  factory ScannedAttendanceResponse.fromJson(Map<String, dynamic> json) => ScannedAttendanceResponse(
    success: json["success"],
    scannedAttendance: List<String>.from(json["scannedAttendance"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "scannedAttendance": List<dynamic>.from(scannedAttendance!.map((x) => x)),
  };
}
