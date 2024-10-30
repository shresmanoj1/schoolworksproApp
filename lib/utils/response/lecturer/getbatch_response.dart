// To parse this JSON data, do
//
//     final getBatchResponse = getBatchResponseFromJson(jsonString);

import 'dart:convert';

GetBatchResponse getBatchResponseFromJson(String str) => GetBatchResponse.fromJson(json.decode(str));

String getBatchResponseToJson(GetBatchResponse data) => json.encode(data.toJson());

class GetBatchResponse {
  GetBatchResponse({
    this.success,
    this.batcharr,
  });

  bool ? success;
  List<String> ? batcharr;

  factory GetBatchResponse.fromJson(Map<String, dynamic> json) => GetBatchResponse(
    success: json["success"] == null ? null : json["success"],
    batcharr: json["batcharr"] == null ? null : List<String>.from(json["batcharr"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "batcharr": batcharr == null ? null : List<dynamic>.from(batcharr!.map((x) => x)),
  };
}
