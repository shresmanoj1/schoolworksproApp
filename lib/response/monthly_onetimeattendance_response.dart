// To parse this JSON data, do
//
//     final oneTimeAttendanceMonthlyResponse = oneTimeAttendanceMonthlyResponseFromJson(jsonString);

import 'dart:convert';

OneTimeAttendanceMonthlyResponse oneTimeAttendanceMonthlyResponseFromJson(
        String str) =>
    OneTimeAttendanceMonthlyResponse.fromJson(json.decode(str));

String oneTimeAttendanceMonthlyResponseToJson(
        OneTimeAttendanceMonthlyResponse data) =>
    json.encode(data.toJson());

class OneTimeAttendanceMonthlyResponse {
  OneTimeAttendanceMonthlyResponse({
    this.success,
    this.data,
  });

  bool? success;
  List<Datum>? data;

  factory OneTimeAttendanceMonthlyResponse.fromJson(
          Map<String, dynamic> json) =>
      OneTimeAttendanceMonthlyResponse(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.totalAttendance,
    this.month,
    this.year,
    this.monthN,
    this.percentage,
    this.presentDays,
  });

  num? totalAttendance;
  String? month;
  int? year;
  int? monthN;
  String? percentage;
  String? presentDays;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        totalAttendance:
            json["totalAttendance"] == null ? null : json["totalAttendance"],
        month: json["month"] == null ? null : json["month"],
        year: json["year"] == null ? null : json["year"],
        monthN: json["monthN"] == null ? null : json["monthN"],
        percentage:
            json["percentage"] == null ? null : json["percentage"],
        presentDays: json["presentDays"] == null ? null : json["presentDays"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "totalAttendance": totalAttendance == null ? null : totalAttendance,
        "month": month == null ? null : month,
        "year": year == null ? null : year,
        "monthN": monthN == null ? null : monthN,
        "percentage": percentage == null ? null : percentage,
        "presentDays": presentDays == null ? null : presentDays,
      };
}
