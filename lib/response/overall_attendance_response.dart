// To parse this JSON data, do
//
//     final overallAttendanceResponse = overallAttendanceResponseFromJson(jsonString);

import 'dart:convert';

OverallAttendanceResponse overallAttendanceResponseFromJson(String str) => OverallAttendanceResponse.fromJson(json.decode(str));

String overallAttendanceResponseToJson(OverallAttendanceResponse data) => json.encode(data.toJson());

class OverallAttendanceResponse {
  bool? success;
  num? presentSessions;
  num? absentSessions;
  num? totalSessions;
  double? totalPresentPercentage;
  num? currentPresentSessions;
  num? currentAbsentSessions;
  num? currentTotalSessions;
  double? currentTotalPresentPercentage;

  OverallAttendanceResponse({
    this.success,
    this.presentSessions,
    this.absentSessions,
    this.totalSessions,
    this.totalPresentPercentage,
    this.currentPresentSessions,
    this.currentAbsentSessions,
    this.currentTotalSessions,
    this.currentTotalPresentPercentage,
  });

  factory OverallAttendanceResponse.fromJson(Map<String, dynamic> json) => OverallAttendanceResponse(
    success: json["success"],
    presentSessions: json["presentSessions"],
    absentSessions: json["absentSessions"],
    totalSessions: json["totalSessions"],
    totalPresentPercentage: json["totalPresentPercentage"],
    currentPresentSessions: json["currentPresentSessions"],
    currentAbsentSessions: json["currentAbsentSessions"],
    currentTotalSessions: json["currentTotalSessions"],
    currentTotalPresentPercentage: json["currentTotalPresentPercentage"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "presentSessions": presentSessions,
    "absentSessions": absentSessions,
    "totalSessions": totalSessions,
    "totalPresentPercentage": totalPresentPercentage,
    "currentPresentSessions": currentPresentSessions,
    "currentAbsentSessions": currentAbsentSessions,
    "currentTotalSessions": currentTotalSessions,
    "currentTotalPresentPercentage": currentTotalPresentPercentage,
  };
}
