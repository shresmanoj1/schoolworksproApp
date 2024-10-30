// To parse this JSON data, do
//
//     final getReportPlagResponse = getReportPlagResponseFromJson(jsonString);

import 'dart:convert';

GetReportPlagResponse getReportPlagResponseFromJson(String str) => GetReportPlagResponse.fromJson(json.decode(str));

String getReportPlagResponseToJson(GetReportPlagResponse data) => json.encode(data.toJson());

class GetReportPlagResponse {
  GetReportPlagResponse({
    this.success,
    this.data,
  });

  bool? success;
  dynamic data;

  factory GetReportPlagResponse.fromJson(Map<String, dynamic> json) => GetReportPlagResponse(
    success: json["success"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
  };
}
