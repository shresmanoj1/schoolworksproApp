// To parse this JSON data, do
//
//     final getDisciplinaryForStatsResponse = getDisciplinaryForStatsResponseFromJson(jsonString);

import 'dart:convert';

GetDisciplinaryForStatsResponse getDisciplinaryForStatsResponseFromJson(
        String str) =>
    GetDisciplinaryForStatsResponse.fromJson(json.decode(str));

String getDisciplinaryForStatsResponseToJson(
        GetDisciplinaryForStatsResponse data) =>
    json.encode(data.toJson());

class GetDisciplinaryForStatsResponse {
  GetDisciplinaryForStatsResponse({
    this.success,
    this.result,
    this.count,
  });

  bool? success;
  List<dynamic>? result;
  int? count;

  factory GetDisciplinaryForStatsResponse.fromJson(Map<String, dynamic> json) =>
      GetDisciplinaryForStatsResponse(
        success: json["success"],
        result: List<dynamic>.from(json["result"].map((x) => x)),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "result": List<dynamic>.from(result!.map((x) => x)),
        "count": count,
      };
}
