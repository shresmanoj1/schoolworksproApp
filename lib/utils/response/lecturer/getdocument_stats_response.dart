// To parse this JSON data, do
//
//     final getDocumentForStatsResponse = getDocumentForStatsResponseFromJson(jsonString);

import 'dart:convert';

GetDocumentForStatsResponse getDocumentForStatsResponseFromJson(String str) => GetDocumentForStatsResponse.fromJson(json.decode(str));

String getDocumentForStatsResponseToJson(GetDocumentForStatsResponse data) => json.encode(data.toJson());

class GetDocumentForStatsResponse {
  GetDocumentForStatsResponse({
    this.success,
    this.documents,
  });

  bool ? success;
  List<dynamic> ? documents;

  factory GetDocumentForStatsResponse.fromJson(Map<String, dynamic> json) => GetDocumentForStatsResponse(
    success: json["success"],
    documents: List<dynamic>.from(json["documents"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "documents": List<dynamic>.from(documents!.map((x) => x.toJson())),
  };
}



