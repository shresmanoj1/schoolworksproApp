// To parse this JSON data, do
//
//     final getProgressForStatsResponse = getProgressForStatsResponseFromJson(jsonString);

import 'dart:convert';

GetProgressForStatsResponse getProgressForStatsResponseFromJson(String str) =>
    GetProgressForStatsResponse.fromJson(json.decode(str));

String getProgressForStatsResponseToJson(GetProgressForStatsResponse data) =>
    json.encode(data.toJson());

class GetProgressForStatsResponse {
  GetProgressForStatsResponse({
    this.success,
    this.allProgress,
  });

  bool? success;
  List<dynamic>? allProgress;

  factory GetProgressForStatsResponse.fromJson(Map<String, dynamic> json) =>
      GetProgressForStatsResponse(
        success: json["success"],
        allProgress: List<dynamic>.from(json["allProgress"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "allProgress": List<dynamic>.from(allProgress!.map((x) => x.toJson())),
      };
}
