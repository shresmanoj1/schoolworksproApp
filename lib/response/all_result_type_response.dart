// To parse this JSON data, do
//
//     final allResultTypeResponse = allResultTypeResponseFromJson(jsonString);

import 'dart:convert';

AllResultTypeResponse allResultTypeResponseFromJson(String str) => AllResultTypeResponse.fromJson(json.decode(str));

String allResultTypeResponseToJson(AllResultTypeResponse data) => json.encode(data.toJson());

class AllResultTypeResponse {
  String? success;
  List<AllResultType>? allResultType;

  AllResultTypeResponse({
    this.success,
    this.allResultType,
  });

  factory AllResultTypeResponse.fromJson(Map<String, dynamic> json) => AllResultTypeResponse(
    success: json["success"],
    allResultType: List<AllResultType>.from(json["allResultType"].map((x) => AllResultType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "allResultType": List<dynamic>.from(allResultType!.map((x) => x.toJson())),
  };
}

class AllResultType {
  String? resultId;
  String? resultTitle;
  String? resultSlug;

  AllResultType({
    this.resultId,
    this.resultTitle,
    this.resultSlug,
  });

  factory AllResultType.fromJson(Map<String, dynamic> json) => AllResultType(
    resultId: json["resultId"],
    resultTitle: json["resultTitle"],
    resultSlug: json["resultSlug"],
  );

  Map<String, dynamic> toJson() => {
    "resultId": resultId,
    "resultTitle": resultTitle,
    "resultSlug": resultSlug,
  };
}
