// To parse this JSON data, do
//
//     final adminRequestDetailResponse = adminRequestDetailResponseFromJson(jsonString);

import 'dart:convert';

AdminRequestDetailResponse adminRequestDetailResponseFromJson(String str) => AdminRequestDetailResponse.fromJson(json.decode(str));

String adminRequestDetailResponseToJson(AdminRequestDetailResponse data) => json.encode(data.toJson());

class AdminRequestDetailResponse {
  AdminRequestDetailResponse({
    this.success,
    this.request,
  });

  bool ? success;
  dynamic request;

  factory AdminRequestDetailResponse.fromJson(Map<String, dynamic> json) => AdminRequestDetailResponse(
    success: json["success"],
    request: json["request"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "request": request,
  };
}
