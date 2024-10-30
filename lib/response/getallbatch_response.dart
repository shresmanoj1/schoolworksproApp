// To parse this JSON data, do
//
//     final getAllBatchResponse = getAllBatchResponseFromJson(jsonString);

import 'dart:convert';

GetAllBatchResponse getAllBatchResponseFromJson(String str) =>
    GetAllBatchResponse.fromJson(json.decode(str));

String getAllBatchResponseToJson(GetAllBatchResponse data) =>
    json.encode(data.toJson());

class GetAllBatchResponse {
  GetAllBatchResponse({
    this.success,
    this.allBatch,
  });

  bool? success;
  List<AllBatch>? allBatch;

  factory GetAllBatchResponse.fromJson(Map<String, dynamic> json) =>
      GetAllBatchResponse(
        success: json["success"],
        allBatch: List<AllBatch>.from(
            json["allBatch"].map((x) => AllBatch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "allBatch": List<dynamic>.from(allBatch!.map((x) => x.toJson())),
      };
}

class AllBatch {
  AllBatch({
    this.passedOut,
    this.feeShow,
    this.id,
    this.batch,
    this.institution,
  });

  bool? passedOut;
  bool? feeShow;
  String? id;
  String? batch;
  String? institution;

  factory AllBatch.fromJson(Map<String, dynamic> json) => AllBatch(
        passedOut: json["passedOut"],
        feeShow: json["feeShow"],
        id: json["_id"],
        batch: json["batch"],
        institution: json["institution"],
      );

  Map<String, dynamic> toJson() => {
        "passedOut": passedOut,
        "feeShow": feeShow,
        "_id": id,
        "batch": batch,
        "institution": institution,
      };
}
