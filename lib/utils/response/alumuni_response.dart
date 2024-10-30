// To parse this JSON data, do
//
//     final alumuniResponse = alumuniResponseFromJson(jsonString);

import 'dart:convert';

AlumuniResponse alumuniResponseFromJson(String str) => AlumuniResponse.fromJson(json.decode(str));

String alumuniResponseToJson(AlumuniResponse data) => json.encode(data.toJson());

class AlumuniResponse {
  AlumuniResponse({
    this.success,
    this.count,
    this.allBatch,
  });

  bool ? success;
  int ? count;
  List<AllmuniBatch> ? allBatch;

  factory AlumuniResponse.fromJson(Map<String, dynamic> json) => AlumuniResponse(
    success: json["success"],
    count: json["count"],
    allBatch: List<AllmuniBatch>.from(json["allBatch"].map((x) => AllmuniBatch.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "allBatch": List<dynamic>.from(allBatch!.map((x) => x.toJson())),
  };
}

class AllmuniBatch {
  AllmuniBatch({
    this.passedOut,
    this.feeShow,
    this.oneTimeAttendence,
    this.id,
    this.batch,
    this.institution,
    this.incharge,
  });

  bool ? passedOut;
  bool ? feeShow;
  bool ? oneTimeAttendence;
  String ? id;
  String ? batch;
  String ? institution;
  String ? incharge;

  factory AllmuniBatch.fromJson(Map<String, dynamic> json) => AllmuniBatch(
    passedOut: json["passedOut"],
    feeShow: json["feeShow"],
    oneTimeAttendence: json["one_time_attendence"],
    id: json["_id"],
    batch: json["batch"],
    institution: json["institution"],
    incharge: json["incharge"],
  );

  Map<String, dynamic> toJson() => {
    "passedOut": passedOut,
    "feeShow": feeShow,
    "one_time_attendence": oneTimeAttendence,
    "_id": id,
    "batch": batch,
    "institution": institution,
    "incharge": incharge,
  };
}
