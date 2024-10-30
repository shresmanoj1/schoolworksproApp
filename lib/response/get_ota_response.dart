// To parse this JSON data, do
//
//     final getOtaResponse = getOtaResponseFromJson(jsonString);

import 'dart:convert';

GetOtaResponse getOtaResponseFromJson(String str) => GetOtaResponse.fromJson(json.decode(str));

String getOtaResponseToJson(GetOtaResponse data) => json.encode(data.toJson());

class GetOtaResponse {
  GetOtaResponse({
    this.success,
    this.batchArr,
  });

  bool ? success;
  List<String> ? batchArr;

  factory GetOtaResponse.fromJson(Map<String, dynamic> json) => GetOtaResponse(
    success: json["success"],
    batchArr: List<String>.from(json["batchArr"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "batchArr": List<dynamic>.from(batchArr!.map((x) => x)),
  };
}
