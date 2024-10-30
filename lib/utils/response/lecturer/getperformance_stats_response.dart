import 'dart:convert';

GetPerformanceForStatsResponse getPerformanceForStatsResponseFromJson(
        String str) =>
    GetPerformanceForStatsResponse.fromJson(json.decode(str));

String getPerformanceForStatsResponseToJson(
        GetPerformanceForStatsResponse data) =>
    json.encode(data.toJson());

class GetPerformanceForStatsResponse {
  GetPerformanceForStatsResponse({
    this.success,
    this.commentCount,
    this.yearOne,
    this.yearTwo,
    this.yearThree,
    this.attendance,
  });

  bool? success;
  dynamic commentCount;
  dynamic yearOne;
  dynamic yearTwo;
  dynamic yearThree;
  List<dynamic>? attendance;

  factory GetPerformanceForStatsResponse.fromJson(Map<String, dynamic> json) =>
      GetPerformanceForStatsResponse(
        success: json["success"],
        commentCount: json["commentCount"],
        yearOne: json["yearOne"],
        yearTwo: json["yearTwo"],
        yearThree: json["yearThree"],
        attendance: List<dynamic>.from(json["attendance"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "commentCount": commentCount,
        "yearOne": yearOne,
        "yearTwo": yearTwo,
        "yearThree": yearThree,
        "attendance": List<dynamic>.from(attendance!.map((x) => x)),
      };
}
